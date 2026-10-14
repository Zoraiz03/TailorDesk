import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/features/customers/data/customers_dao.dart';
import 'package:tailor/features/measurements/data/measurements_dao.dart';
import 'package:tailor/features/measurements/measurement_models.dart';
import 'package:tailor/features/measurements/measurement_templates.dart';
import 'package:tailor/features/orders/data/orders_dao.dart';
import 'package:tailor/features/orders/order_models.dart';
import 'package:tailor/features/settings/garment_catalog.dart';
import 'package:tailor/features/settings/garment_catalog_providers.dart';
import 'package:tailor/features/settings/shop_settings.dart';
import 'package:tailor/features/settings/shop_settings_providers.dart';

void main() {
  test('fresh setup progress survives reopening and completion', () async {
    final directory = await Directory.systemTemp.createTemp('tailor_setup_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/tailor.sqlite');
    var database = AppDatabase(NativeDatabase(file));
    var settings = ShopSettingsRepository(database);

    expect((await settings.watchSetup().first).completed, isFalse);
    await settings.saveSetupProgress(
      const ShopDetails(
        name: 'Needle House',
        phone: '0300',
        defaultMeasurementUnit: 'centimetres',
      ),
      2,
    );
    await database.close();

    database = AppDatabase(NativeDatabase(file));
    settings = ShopSettingsRepository(database);
    expect((await settings.watchSetup().first).step, 2);
    expect((await settings.get()).name, 'Needle House');
    expect((await settings.get()).defaultMeasurementUnit, 'centimetres');
    await settings.completeSetup(await settings.get());
    expect((await settings.watchSetup().first).completed, isTrue);
    await database.close();
  });

  test(
    'catalog preserves required and extra garments and supports ordering',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = GarmentCatalogRepository(database);

      final initial = await repository.getCatalog();
      expect(
        initial.map((item) => item.entry.garmentId),
        containsAll([
          'shalwar_qameez',
          'coat',
          'trouser',
          'shirt',
          'waistcoat',
          'jacket',
          'kurta',
          'sherwani',
        ]),
      );
      await repository.updateEntry(garmentId: 'coat', enabled: false);
      expect(
        (await repository.getCatalog(
          enabledOnly: true,
        )).map((item) => item.entry.garmentId),
        isNot(contains('coat')),
      );
      await repository.reorder([
        'jacket',
        ...initial.map((e) => e.entry.garmentId).where((id) => id != 'jacket'),
      ]);
      expect((await repository.getCatalog()).first.entry.garmentId, 'jacket');
    },
  );

  test(
    'template revisions archive fields and preserve booked snapshots',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final catalog = GarmentCatalogRepository(database);
      final customers = CustomersDao(database);
      final measurements = MeasurementsDao(database);
      final orders = OrdersDao(database);
      final garmentId = await catalog.createCustomTemplate(
        name: 'Achkan Special',
        nameUrdu: 'خاص اچکن',
        convention: 'finished_garment',
        fields: const [
          GarmentTemplateField(
            id: 'front_length',
            label: 'Front length',
            labelUrdu: 'سامنے کی لمبائی',
            order: 0,
            required: true,
          ),
          GarmentTemplateField(
            id: 'chest',
            label: 'Chest',
            labelUrdu: 'چھاتی',
            order: 1,
            required: true,
          ),
        ],
        defaultPricePaisa: 250000,
      );
      final v1 = (await catalog.getById(garmentId))!;
      final customerId = await customers.createCustomer(
        name: 'Ali',
        phone: '0300',
      );
      final profileId = await measurements.createProfile(
        MeasurementDraft.catalog(
          customerId: customerId,
          garmentId: garmentId,
          garmentLabelEnglish: v1.entry.displayName,
          garmentLabelUrdu: v1.entry.displayNameUrdu ?? '',
          profileName: 'Wedding',
          unit: MeasurementUnit.inches,
          basis: MeasurementBasis.finishedGarment,
          values: const {'front_length': 42, 'chest': 40},
          fitPreference: FitPreference.regular,
          templateVersionId: v1.templateVersion.id,
          fieldDefinitions: v1.fields,
        ),
      );
      final revision = (await measurements.getProfile(
        profileId,
      ))!.latestRevision;
      final orderId = await orders.createOrder(
        NewOrderDraft(
          submissionKey: 'stage9-snapshot',
          customerId: customerId,
          bookingDate: DateTime(2026, 10, 12),
          deliveryDate: DateTime(2026, 10, 20),
          lines: [
            OrderLineDraft(
              measurementRevisionId: revision.id,
              quantity: 1,
              stitchingPricePaisa: 250000,
            ),
          ],
        ),
      );

      await catalog.reviseTemplate(
        garmentId: garmentId,
        name: 'Achkan Revised',
        nameUrdu: 'ترمیم شدہ اچکن',
        convention: 'finished_garment',
        fields: const [
          GarmentTemplateField(
            id: 'chest',
            label: 'Finished chest',
            labelUrdu: 'تیار چھاتی',
            order: 0,
            required: true,
          ),
        ],
      );
      await catalog.updateEntry(
        garmentId: garmentId,
        defaultPricePaisa: 300000,
      );

      final v2 = (await catalog.getById(garmentId))!;
      expect(v2.templateVersion.versionNumber, 2);
      expect(
        v2.fields.singleWhere((field) => field.id == 'front_length').archived,
        isTrue,
      );
      expect(v2.entry.defaultStitchingPricePaisa, 300000);
      expect(v2.entry.displayNameUrdu, 'ترمیم شدہ اچکن');
      expect(
        decodeFieldDefinitions(
          revision.fieldDefinitionsJson,
          garmentId,
        ).first.label,
        'Front length',
      );
      final booked = (await orders.getOrder(orderId))!.items.single;
      expect(booked.stitchingPricePaisa, 250000);
      expect(booked.garmentLabelEnglish, 'Achkan Special');
      expect(booked.garmentLabelUrdu, 'خاص اچکن');
      expect(
        decodeFieldDefinitions(
          booked.measurementFieldDefinitionsJson,
          garmentId,
        ).first.label,
        'Front length',
      );
      expect(
        decodeFieldDefinitions(
          booked.measurementFieldDefinitionsJson,
          garmentId,
        ).first.labelUrdu,
        'سامنے کی لمبائی',
      );
    },
  );

  test('migrates an actual schema 5 database without losing records', () async {
    final directory = await Directory.systemTemp.createTemp('tailor_v5_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/tailor.sqlite');
    var database = AppDatabase(NativeDatabase(file));
    final customerId = await CustomersDao(
      database,
    ).createCustomer(name: 'Existing', phone: '0300');
    await MeasurementsDao(database).createProfile(
      MeasurementDraft(
        customerId: customerId,
        garmentType: GarmentType.shirt,
        profileName: 'Existing Shirt',
        unit: MeasurementUnit.inches,
        basis: MeasurementBasis.body,
        values: const {
          'length': 30,
          'shoulder': 18,
          'sleeve': 24,
          'chest': 40,
          'waist': 36,
        },
        fitPreference: FitPreference.regular,
      ),
    );
    await ShopSettingsRepository(
      database,
    ).save(const ShopDetails(name: 'Existing Shop'));
    await database.close();

    final raw = sqlite.sqlite3.open(file.path);
    raw.execute('PRAGMA foreign_keys = OFF');
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
    raw.userVersion = 5;
    raw.close();

    database = AppDatabase(NativeDatabase(file));
    addTearDown(database.close);
    expect(
      (await CustomersDao(database).watchAll().first).single.name,
      'Existing',
    );
    expect(
      (await ShopSettingsRepository(database).get()).name,
      'Existing Shop',
    );
    expect(
      (await ShopSettingsRepository(database).watchSetup().first).completed,
      isTrue,
    );
    final migratedRevision = await database
        .select(database.measurementRevisions)
        .getSingle();
    expect(
      decodeFieldDefinitions(
        migratedRevision.fieldDefinitionsJson,
        migratedRevision.garmentType,
      ).map((field) => field.label),
      contains('Chest'),
    );
    expect(
      (await GarmentCatalogRepository(database).getCatalog()),
      hasLength(8),
    );
    expect(
      await database
          .customSelect('PRAGMA user_version')
          .getSingle()
          .then((row) => row.read<int>('user_version')),
      7,
    );
  });

  test('migrates schema 6 and seeds bilingual built-in labels', () async {
    final directory = await Directory.systemTemp.createTemp('tailor_v6_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/tailor.sqlite');
    var database = AppDatabase(NativeDatabase(file));
    await database.select(database.garmentCatalogEntries).get();
    await database.close();

    final raw = sqlite.sqlite3.open(file.path);
    raw.execute(
      'ALTER TABLE garment_catalog_entries DROP COLUMN display_name_urdu',
    );
    raw.execute(
      'ALTER TABLE measurement_template_fields DROP COLUMN display_label_urdu',
    );
    raw.execute(
      'ALTER TABLE measurement_revisions DROP COLUMN garment_label_english',
    );
    raw.execute(
      'ALTER TABLE measurement_revisions DROP COLUMN garment_label_urdu',
    );
    raw.execute('ALTER TABLE order_items DROP COLUMN garment_label_english');
    raw.execute('ALTER TABLE order_items DROP COLUMN garment_label_urdu');
    raw.userVersion = 6;
    raw.close();

    database = AppDatabase(NativeDatabase(file));
    addTearDown(database.close);
    final shirt = await GarmentCatalogRepository(database).getById('shirt');
    expect(shirt!.entry.displayName, 'Shirt');
    expect(shirt.entry.displayNameUrdu, 'شرٹ');
    expect(
      shirt.fields.firstWhere((field) => field.id == 'chest').labelUrdu,
      'چھاتی',
    );
    expect(
      await database
          .customSelect('PRAGMA user_version')
          .getSingle()
          .then((row) => row.read<int>('user_version')),
      7,
    );
  });
}
