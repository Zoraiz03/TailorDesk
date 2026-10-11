import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/features/customers/data/customers_dao.dart';
import 'package:tailor/features/measurements/data/measurements_dao.dart';
import 'package:tailor/features/measurements/measurement_models.dart';
import 'package:tailor/features/measurements/measurement_templates.dart';

void main() {
  late AppDatabase database;
  late CustomersDao customersDao;
  late MeasurementsDao measurementsDao;
  late int customerId;

  MeasurementDraft draft({
    int? ownerId,
    String profileName = 'Everyday',
    MeasurementUnit unit = MeasurementUnit.inches,
    Map<String, double>? values,
  }) {
    return MeasurementDraft(
      customerId: ownerId ?? customerId,
      garmentType: GarmentType.shirt,
      profileName: profileName,
      unit: unit,
      basis: MeasurementBasis.body,
      values:
          values ??
          const {
            'length': 30.5,
            'shoulder': 18.25,
            'sleeve': 24.75,
            'chest': 40.5,
            'waist': 36.25,
          },
      fitPreference: FitPreference.regular,
      styleInstructions: 'Single cuff',
      notes: 'Provisional body measurements',
    );
  }

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    customersDao = CustomersDao(database);
    measurementsDao = MeasurementsDao(database);
    customerId = await customersDao.createCustomer(
      name: 'Ahmed Khan',
      phone: '03001234567',
    );
  });

  tearDown(() => database.close());

  test(
    'creates and retrieves a profile with decimal values and unit',
    () async {
      final profileId = await measurementsDao.createProfile(
        draft(unit: MeasurementUnit.centimetres),
      );

      final record = await measurementsDao.getProfile(profileId);

      expect(record, isNotNull);
      expect(record!.profile.customerId, customerId);
      expect(record.latestRevision.revisionNumber, 1);
      expect(record.latestRevision.unit, 'centimetres');
      expect(record.values['length'], 30.5);
      expect(record.values['shoulder'], 18.25);
    },
  );

  test(
    'editing creates an immutable revision and preserves the previous one',
    () async {
      final profileId = await measurementsDao.createProfile(draft());
      final revisionNumber = await measurementsDao.createRevision(
        profileId: profileId,
        draft: draft(
          profileName: 'Wedding',
          values: const {
            'length': 31.0,
            'shoulder': 18.25,
            'sleeve': 25.0,
            'chest': 41.0,
            'waist': 37.0,
          },
        ),
      );

      final history = await measurementsDao.watchHistory(profileId).first;
      final current = await measurementsDao.getProfile(profileId);

      expect(revisionNumber, 2);
      expect(history, hasLength(2));
      expect(history[0].revisionNumber, 2);
      expect(decodeMeasurementValues(history[0].valuesJson)['length'], 31.0);
      expect(history[1].revisionNumber, 1);
      expect(decodeMeasurementValues(history[1].valuesJson)['length'], 30.5);
      expect(current!.latestRevision.profileName, 'Wedding');
    },
  );

  test(
    'profiles remain linked to one customer and block customer deletion',
    () async {
      final otherCustomerId = await customersDao.createCustomer(
        name: 'Bilal Hussain',
        phone: '03111234567',
      );
      final profileId = await measurementsDao.createProfile(draft());

      expect(
        await measurementsDao.watchForCustomer(customerId).first,
        hasLength(1),
      );
      expect(
        await measurementsDao.watchForCustomer(otherCustomerId).first,
        isEmpty,
      );
      await expectLater(
        customersDao.deleteCustomer(customerId),
        throwsA(isA<CustomerHasMeasurementsException>()),
      );
      await expectLater(
        (database.delete(
          database.customers,
        )..where((customer) => customer.id.equals(customerId))).go(),
        throwsA(anything),
      );
      await expectLater(
        measurementsDao.createRevision(
          profileId: profileId,
          draft: draft(ownerId: otherCustomerId),
        ),
        throwsArgumentError,
      );
      await expectLater(
        measurementsDao.createRevision(
          profileId: profileId,
          draft: draft(unit: MeasurementUnit.centimetres),
        ),
        throwsArgumentError,
      );
    },
  );

  test('rejects missing, zero, and negative required values', () async {
    expect(
      () => measurementsDao.createProfile(draft(values: const {})),
      throwsArgumentError,
    );
    expect(
      () => measurementsDao.createProfile(
        draft(
          values: const {
            'length': 0,
            'shoulder': 18,
            'sleeve': 24,
            'chest': 40,
            'waist': 36,
          },
        ),
      ),
      throwsArgumentError,
    );
    expect(
      () => measurementsDao.createProfile(
        draft(
          values: const {
            'length': -1,
            'shoulder': 18,
            'sleeve': 24,
            'chest': 40,
            'waist': 36,
          },
        ),
      ),
      throwsArgumentError,
    );
  });

  test('migrates v2 and preserves its customer records', () async {
    await database.close();
    final directory = await Directory.systemTemp.createTemp(
      'tailor_v2_migration_test_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/tailor.sqlite');
    final migratedDatabase = AppDatabase(
      NativeDatabase(
        file,
        setup: (rawDatabase) {
          rawDatabase.execute('''
            CREATE TABLE app_settings (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              key TEXT NOT NULL UNIQUE CHECK (length(key) BETWEEN 1 AND 100),
              value TEXT NOT NULL DEFAULT ''
            )
          ''');
          rawDatabase.execute('''
            CREATE TABLE customers (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL CHECK (length(name) BETWEEN 1 AND 100),
              phone TEXT NOT NULL CHECK (length(phone) BETWEEN 1 AND 30),
              address TEXT NOT NULL DEFAULT '',
              notes TEXT NOT NULL DEFAULT '',
              created_at INTEGER NOT NULL,
              updated_at INTEGER NOT NULL
            )
          ''');
          rawDatabase.execute('''
            INSERT INTO customers
              (name, phone, address, notes, created_at, updated_at)
            VALUES
              ('Existing Customer', '03001234567', '', '', 1700000000, 1700000000)
          ''');
          rawDatabase.execute('PRAGMA user_version = 2');
        },
      ),
    );
    addTearDown(migratedDatabase.close);

    final existingCustomer = await migratedDatabase
        .select(migratedDatabase.customers)
        .getSingle();
    final profileId = await MeasurementsDao(migratedDatabase).createProfile(
      MeasurementDraft(
        customerId: existingCustomer.id,
        garmentType: GarmentType.shirt,
        profileName: 'After Migration',
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

    expect(existingCustomer.name, 'Existing Customer');
    expect(profileId, 1);
    expect(
      await migratedDatabase
          .customSelect('PRAGMA user_version')
          .getSingle()
          .then((row) => row.read<int>('user_version')),
      5,
    );
  });
}
