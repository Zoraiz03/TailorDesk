import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/core/database/database_provider.dart';
import 'package:tailor/features/customers/customer_form_screen.dart';
import 'package:tailor/features/customers/data/customers_dao.dart';

void main() {
  late AppDatabase database;
  late CustomersDao dao;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    dao = CustomersDao(database);
  });

  tearDown(() => database.close());

  Widget subject({Customer? customer}) {
    return ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: MaterialApp(home: CustomerFormScreen(customer: customer)),
    );
  }

  testWidgets('requires a name and phone number', (tester) async {
    await tester.pumpWidget(subject());
    await tester.tap(find.byKey(const ValueKey('save-customer')));
    await tester.pump();

    expect(find.text('Enter the customer name'), findsOneWidget);
    expect(find.text('Enter a phone number'), findsOneWidget);
    expect(await database.select(database.customers).get(), isEmpty);
  });

  testWidgets('rejects an invalid phone number', (tester) async {
    await tester.pumpWidget(subject());
    await tester.enterText(
      find.byKey(const ValueKey('customer-name')),
      'Ahmed Khan',
    );
    await tester.enterText(
      find.byKey(const ValueKey('customer-phone')),
      'not a phone',
    );
    await tester.tap(find.byKey(const ValueKey('save-customer')));
    await tester.pump();

    expect(find.text('Enter a valid phone number'), findsOneWidget);
    expect(await database.select(database.customers).get(), isEmpty);
  });

  testWidgets('creates a valid customer', (tester) async {
    await tester.pumpWidget(subject());
    await tester.enterText(
      find.byKey(const ValueKey('customer-name')),
      'Ahmed Khan',
    );
    await tester.enterText(
      find.byKey(const ValueKey('customer-phone')),
      '0300 1234567',
    );
    await tester.tap(find.byKey(const ValueKey('save-customer')));
    await tester.pumpAndSettle();

    final customers = await database.select(database.customers).get();
    expect(customers, hasLength(1));
    expect(customers.single.name, 'Ahmed Khan');
  });

  testWidgets('edits an existing customer', (tester) async {
    final id = await dao.createCustomer(name: 'Ahmed', phone: '03001234567');
    final customer = await dao.getById(id);
    await tester.pumpWidget(subject(customer: customer));

    await tester.enterText(
      find.byKey(const ValueKey('customer-name')),
      'Ahmed Khan',
    );
    await tester.tap(find.byKey(const ValueKey('save-customer')));
    await tester.pumpAndSettle();

    expect((await dao.getById(id))!.name, 'Ahmed Khan');
  });
}
