import 'dart:typed_data';

import '../../../core/database/app_database.dart';
import 'backup_models.dart';

class BackupService {
  BackupService({Future<String> Function()? databasePath});

  static const backupFormatVersion = 1;

  Future<Uint8List> createBackup(AppDatabase database) =>
      throw UnsupportedError(
        'Backup and restore are not supported in the web build.',
      );

  Future<BackupValidationResult> validate(Uint8List archiveBytes) =>
      throw UnsupportedError(
        'Backup and restore are not supported in the web build.',
      );

  Future<String> restore(AppDatabase database, Uint8List archiveBytes) =>
      throw UnsupportedError(
        'Backup and restore are not supported in the web build.',
      );
}
