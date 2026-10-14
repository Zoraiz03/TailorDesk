import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/features/customers/data/customers_dao.dart';
import 'package:tailor/features/settings/backup/backup_service.dart';
import 'package:tailor/features/settings/garment_catalog.dart';
import 'package:tailor/features/settings/garment_catalog_providers.dart';

void main() {
  late Directory temp;
  late File databaseFile;
  late AppDatabase database;
  late BackupService service;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('tailordesk_backup_test_');
    databaseFile = File('${temp.path}/tailor_db.sqlite');
    database = AppDatabase(NativeDatabase(databaseFile));
    service = BackupService(databasePath: () async => databaseFile.path);
  });

  tearDown(() async {
    await database.close();
    if (await temp.exists()) await temp.delete(recursive: true);
  });

  test('backup and restore round trip replaces later data', () async {
    final customers = CustomersDao(database);
    await customers.createCustomer(name: 'In backup', phone: '0300');
    final backup = await service.createBackup(database);
    await customers.createCustomer(name: 'Added later', phone: '0301');

    final safetyPath = await service.restore(database, backup);
    final reopened = AppDatabase(NativeDatabase(databaseFile));
    database = reopened;
    final restored = await CustomersDao(reopened).watchAll().first;

    expect(restored.map((customer) => customer.name), ['In backup']);
    expect(await File(safetyPath).exists(), isTrue);
  });

  test('corrupt archive is rejected and existing data survives', () async {
    await CustomersDao(database).createCustomer(name: 'Safe', phone: '0300');
    await expectLater(
      service.restore(database, Uint8List.fromList([1, 2, 3, 4])),
      throwsA(isA<BackupException>()),
    );
    expect((await CustomersDao(database).watchAll().first).single.name, 'Safe');
  });

  test('unsupported backup format is rejected', () async {
    final archive = Archive()
      ..addFile(ArchiveFile.bytes('database.sqlite', [1, 2, 3]))
      ..addFile(
        ArchiveFile.string(
          'manifest.json',
          jsonEncode({
            'backupFormatVersion': 99,
            'databaseSchemaVersion': 5,
            'createdAt': DateTime.utc(2026).toIso8601String(),
            'files': {
              'database.sqlite': {
                'sha256': sha256.convert([1, 2, 3]).toString(),
                'size': 3,
              },
            },
          }),
        ),
      );
    await expectLater(
      service.validate(ZipEncoder().encodeBytes(archive)),
      throwsA(isA<BackupException>()),
    );
  });

  test('compatible schema 4 backup migrates during validation', () async {
    await CustomersDao(database).createCustomer(name: 'Legacy', phone: '0300');
    await database.close();
    final raw = sqlite.sqlite3.open(databaseFile.path);
    raw.execute(
      'ALTER TABLE measurement_revisions DROP COLUMN template_version_id',
    );
    raw.execute(
      'ALTER TABLE measurement_revisions DROP COLUMN field_definitions_json',
    );
    raw.execute(
      'ALTER TABLE order_items DROP COLUMN measurement_field_definitions_json',
    );
    raw.execute(
      'ALTER TABLE measurement_revisions DROP COLUMN garment_label_english',
    );
    raw.execute(
      'ALTER TABLE measurement_revisions DROP COLUMN garment_label_urdu',
    );
    raw.execute('ALTER TABLE order_items DROP COLUMN garment_label_english');
    raw.execute('ALTER TABLE order_items DROP COLUMN garment_label_urdu');
    raw.execute('DROP TABLE measurement_template_fields');
    raw.execute('DROP TABLE measurement_template_versions');
    raw.execute('DROP TABLE garment_catalog_entries');
    raw.execute('DROP TABLE karigar_assignments');
    raw.execute('DROP TABLE karigars');
    raw.userVersion = 4;
    raw.close();
    final bytes = await databaseFile.readAsBytes();
    final archive = Archive()
      ..addFile(ArchiveFile.bytes('database.sqlite', bytes))
      ..addFile(
        ArchiveFile.string(
          'manifest.json',
          jsonEncode({
            'backupFormatVersion': 1,
            'databaseSchemaVersion': 4,
            'createdAt': DateTime.utc(2026).toIso8601String(),
            'attachments': <Object>[],
            'files': {
              'database.sqlite': {
                'sha256': sha256.convert(bytes).toString(),
                'size': bytes.length,
              },
            },
          }),
        ),
      );

    final backupBytes = ZipEncoder().encodeBytes(archive);
    await databaseFile.delete();
    database = AppDatabase(NativeDatabase(databaseFile));
    await CustomersDao(database).createCustomer(name: 'Current', phone: '0301');

    await service.restore(database, backupBytes);
    final migrated = AppDatabase(NativeDatabase(databaseFile));
    database = migrated;
    expect(migrated.schemaVersion, 7);
    expect(
      (await CustomersDao(migrated).watchAll().first).single.name,
      'Legacy',
    );
    expect(await migrated.select(migrated.karigars).get(), isEmpty);
  });

  test(
    'backup restores Stage 9 catalog, template versions, and prices',
    () async {
      final catalog = GarmentCatalogRepository(database);
      final customId = await catalog.createCustomTemplate(
        name: 'Custom Peshwas',
        nameUrdu: 'خاص پیشواز',
        convention: 'body',
        fields: const [
          GarmentTemplateField(
            id: 'length',
            label: 'Length',
            labelUrdu: 'لمبائی',
            order: 0,
            required: true,
          ),
        ],
        defaultPricePaisa: 175000,
      );
      final backup = await service.createBackup(database);
      await catalog.updateEntry(garmentId: customId, defaultPricePaisa: 99900);

      await service.restore(database, backup);
      database = AppDatabase(NativeDatabase(databaseFile));
      final restored = await GarmentCatalogRepository(
        database,
      ).getById(customId);
      expect(restored, isNotNull);
      expect(restored!.entry.defaultStitchingPricePaisa, 175000);
      expect(restored.templateVersion.versionNumber, 1);
      expect(restored.fields.single.label, 'Length');
      expect(restored.entry.displayNameUrdu, 'خاص پیشواز');
      expect(restored.fields.single.labelUrdu, 'لمبائی');
    },
  );
}
