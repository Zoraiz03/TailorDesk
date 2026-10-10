import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/features/customers/data/customers_dao.dart';

void main() {
  group('CustomersDao', () {
    late AppDatabase database;
    late CustomersDao dao;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      dao = CustomersDao(database);
    });

    tearDown(() => database.close());

    test('creates and reads a customer', () async {
      final id = await dao.createCustomer(
        name: '  Ahmed Khan  ',
        phone: ' 0300 1234567 ',
        address: ' Lahore ',
      );

      final customer = await dao.getById(id);

      expect(customer, isNotNull);
      expect(customer!.name, 'Ahmed Khan');
      expect(customer.phone, '0300 1234567');
      expect(customer.address, 'Lahore');
    });

    test('updates a customer without changing the creation time', () async {
      final id = await dao.createCustomer(name: 'Ahmed', phone: '03001234567');
      final before = await dao.getById(id);

      await dao.updateCustomer(
        id: id,
        name: 'Ahmed Khan',
        phone: '03111234567',
        notes: 'Prefers a loose fit',
      );
      final after = await dao.getById(id);

      expect(after!.name, 'Ahmed Khan');
      expect(after.phone, '03111234567');
      expect(after.notes, 'Prefers a loose fit');
      expect(after.createdAt, before!.createdAt);
    });

    test('watchAll emits changes and delete removes the customer', () async {
      expect(await dao.watchAll().first, isEmpty);
      final id = await dao.createCustomer(name: 'Bilal', phone: '03007654321');
      expect(await dao.watchAll().first, hasLength(1));

      await dao.deleteCustomer(id);
      expect(await dao.watchAll().first, isEmpty);
    });
  });

  test('migrates the v1 AppSettings schema to v2 without data loss', () async {
    final directory = await Directory.systemTemp.createTemp(
      'tailor_migration_test_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/tailor.sqlite');
    final database = AppDatabase(
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
          rawDatabase.execute(
            "INSERT INTO app_settings (key, value) VALUES ('shop_name', 'Legacy Shop')",
          );
          rawDatabase.execute('PRAGMA user_version = 1');
        },
      ),
    );
    addTearDown(database.close);

    final setting = await database.select(database.appSettings).getSingle();
    final customerId = await CustomersDao(
      database,
    ).createCustomer(name: 'Migrated Customer', phone: '03001234567');

    expect(setting.key, 'shop_name');
    expect(setting.value, 'Legacy Shop');
    expect(customerId, 1);
    expect(
      await database
          .customSelect('PRAGMA user_version')
          .getSingle()
          .then((row) => row.read<int>('user_version')),
      2,
    );
  });

  test('customers persist after the database is closed and reopened', () async {
    final directory = await Directory.systemTemp.createTemp(
      'tailor_persistence_test_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/tailor.sqlite');

    final firstDatabase = AppDatabase(NativeDatabase(file));
    await CustomersDao(
      firstDatabase,
    ).createCustomer(name: 'Persistent Customer', phone: '03001234567');
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(NativeDatabase(file));
    addTearDown(reopenedDatabase.close);
    final customers = await CustomersDao(reopenedDatabase).watchAll().first;

    expect(customers, hasLength(1));
    expect(customers.single.name, 'Persistent Customer');
  });
}
