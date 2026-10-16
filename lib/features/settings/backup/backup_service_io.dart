import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../../../core/database/app_database.dart';
import 'backup_models.dart';

class BackupService {
  BackupService({Future<String> Function()? databasePath})
    : _databasePath = databasePath ?? _defaultDatabasePath;

  static const backupFormatVersion = 1;
  static const _databaseEntry = 'database.sqlite';
  static const _manifestEntry = 'manifest.json';
  static const _maximumArchiveBytes = 512 * 1024 * 1024;

  final Future<String> Function() _databasePath;

  static Future<String> _defaultDatabasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return p.join(directory.path, 'tailor_db.sqlite');
  }

  Future<Uint8List> createBackup(AppDatabase database) async {
    final temp = await Directory.systemTemp.createTemp('tailordesk_backup_');
    try {
      final snapshot = File(p.join(temp.path, _databaseEntry));
      await _vacuumInto(database, snapshot.path);
      final databaseBytes = await snapshot.readAsBytes();
      final createdAt = DateTime.now().toUtc();
      final manifest = <String, Object>{
        'backupFormatVersion': backupFormatVersion,
        'databaseSchemaVersion': database.schemaVersion,
        'createdAt': createdAt.toIso8601String(),
        'files': <String, Object>{
          _databaseEntry: <String, Object>{
            'sha256': sha256.convert(databaseBytes).toString(),
            'size': databaseBytes.length,
          },
        },
        'attachments': const <Object>[],
      };
      final archive = Archive()
        ..addFile(ArchiveFile.bytes(_databaseEntry, databaseBytes))
        ..addFile(ArchiveFile.string(_manifestEntry, jsonEncode(manifest)));
      return ZipEncoder().encodeBytes(archive);
    } finally {
      await temp.delete(recursive: true);
    }
  }

  Future<BackupValidationResult> validate(Uint8List archiveBytes) async {
    if (archiveBytes.isEmpty || archiveBytes.length > _maximumArchiveBytes) {
      throw const BackupException('The backup file is empty or too large.');
    }
    late final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(archiveBytes, verify: true);
    } catch (_) {
      throw const BackupException(
        'The selected file is not a valid backup archive.',
      );
    }

    final entries = <String, ArchiveFile>{};
    for (final entry in archive) {
      final name = entry.name.replaceAll('\\', '/');
      if (entry.isSymbolicLink ||
          entry.size > _maximumArchiveBytes ||
          name.startsWith('/') ||
          name.split('/').contains('..') ||
          name != p.posix.normalize(name)) {
        throw const BackupException('The backup contains an unsafe file path.');
      }
      if (!entry.isFile || !{_manifestEntry, _databaseEntry}.contains(name)) {
        throw const BackupException('The backup contains unsupported files.');
      }
      if (entries.containsKey(name)) {
        throw const BackupException('The backup contains duplicate files.');
      }
      entries[name] = entry;
    }
    if (!entries.keys.toSet().containsAll({_manifestEntry, _databaseEntry})) {
      throw const BackupException(
        'The backup manifest or database is missing.',
      );
    }

    late final Map<String, dynamic> manifest;
    try {
      manifest =
          jsonDecode(utf8.decode(entries[_manifestEntry]!.content))
              as Map<String, dynamic>;
    } catch (_) {
      throw const BackupException('The backup manifest is malformed.');
    }
    final format = manifest['backupFormatVersion'];
    final schema = manifest['databaseSchemaVersion'];
    final createdText = manifest['createdAt'];
    if (format != backupFormatVersion) {
      throw BackupException('Backup format $format is not supported.');
    }
    if (schema is! int || schema < 1) {
      throw const BackupException('The backup schema version is invalid.');
    }
    if (schema > AppDatabase.currentSchemaVersion) {
      throw const BackupException(
        'This backup requires a newer version of TailorDesk.',
      );
    }
    late final DateTime createdAt;
    try {
      createdAt = DateTime.parse(createdText as String);
    } catch (_) {
      throw const BackupException('The backup creation time is invalid.');
    }

    final databaseBytes = entries[_databaseEntry]!.content;
    final files = manifest['files'];
    final databaseMetadata = files is Map ? files[_databaseEntry] : null;
    if (databaseMetadata is! Map ||
        databaseMetadata['size'] != databaseBytes.length ||
        databaseMetadata['sha256'] !=
            sha256.convert(databaseBytes).toString()) {
      throw const BackupException(
        'The backup checksum does not match its database.',
      );
    }

    final temp = await Directory.systemTemp.createTemp('tailordesk_validate_');
    final candidate = File(p.join(temp.path, _databaseEntry));
    try {
      await candidate.writeAsBytes(databaseBytes, flush: true);
      final raw = sqlite.sqlite3.open(candidate.path);
      final actualVersion = raw.userVersion;
      final integrity = raw.select('PRAGMA integrity_check').first.values.first;
      raw.close();
      if (actualVersion != schema) {
        throw const BackupException(
          'The manifest does not match the database schema.',
        );
      }
      if (integrity != 'ok') {
        throw const BackupException(
          'The backup database failed its integrity check.',
        );
      }

      return BackupValidationResult(
        databaseBytes: databaseBytes,
        sourceSchemaVersion: schema,
        createdAt: createdAt,
      );
    } on BackupException {
      rethrow;
    } catch (_) {
      throw const BackupException(
        'The backup database could not be opened safely.',
      );
    } finally {
      await temp.delete(recursive: true);
    }
  }

  Future<String> restore(AppDatabase database, Uint8List archiveBytes) async {
    final validated = await validate(archiveBytes);
    final activePath = await _databasePath();
    final active = File(activePath);
    final directory = active.parent;
    await directory.create(recursive: true);
    final stamp = DateTime.now().toUtc().toIso8601String().replaceAll(':', '-');
    final safety = File(
      p.join(directory.path, 'tailor_db.pre-restore-$stamp.sqlite'),
    );
    await _vacuumInto(database, safety.path);

    final replacement = File('$activePath.restore.tmp');
    final original = File('$activePath.restore-original');
    await replacement.writeAsBytes(validated.databaseBytes, flush: true);
    await database.close();
    await _deleteSidecars(activePath);

    var originalMoved = false;
    var replacementInstalled = false;
    try {
      final migrated = AppDatabase(NativeDatabase(replacement));
      try {
        await migrated.customSelect('SELECT 1').getSingle();
        final migratedIntegrity = await migrated
            .customSelect('PRAGMA integrity_check')
            .getSingle();
        if (migratedIntegrity.data.values.first != 'ok') {
          throw const BackupException(
            'The migrated backup failed its integrity check.',
          );
        }
      } finally {
        await migrated.close();
      }
      if (await original.exists()) await original.delete();
      if (await active.exists()) {
        await active.rename(original.path);
        originalMoved = true;
      }
      await replacement.rename(active.path);
      replacementInstalled = true;
      final check = sqlite.sqlite3.open(active.path);
      final integrity = check
          .select('PRAGMA integrity_check')
          .first
          .values
          .first;
      check.close();
      if (integrity != 'ok') {
        throw const FileSystemException('Integrity check failed');
      }
      if (await original.exists()) await original.delete();
      return safety.path;
    } catch (_) {
      if (replacementInstalled && await active.exists()) await active.delete();
      if (originalMoved && await original.exists()) {
        await original.rename(active.path);
      }
      if (await replacement.exists()) await replacement.delete();
      throw const BackupException(
        'Restore failed. The original database was recovered.',
      );
    }
  }

  Future<void> _vacuumInto(AppDatabase database, String targetPath) async {
    final target = File(targetPath);
    if (await target.exists()) await target.delete();
    final quoted = targetPath.replaceAll("'", "''");
    await database.customStatement("VACUUM INTO '$quoted'");
  }

  Future<void> _deleteSidecars(String databasePath) async {
    for (final suffix in ['-wal', '-shm']) {
      final sidecar = File('$databasePath$suffix');
      if (await sidecar.exists()) await sidecar.delete();
    }
  }
}
