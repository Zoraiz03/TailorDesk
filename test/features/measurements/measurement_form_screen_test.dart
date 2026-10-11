import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/core/database/database_provider.dart';
import 'package:tailor/features/customers/data/customers_dao.dart';
import 'package:tailor/features/measurements/measurement_form_screen.dart';

void main() {
  late AppDatabase database;
  late Customer customer;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    final customersDao = CustomersDao(database);
    final id = await customersDao.createCustomer(
      name: 'Ahmed Khan',
      phone: '03001234567',
    );
    customer = (await customersDao.getById(id))!;
  });

  tearDown(() => database.close());

  Widget subject() {
    return ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: MaterialApp(home: MeasurementFormScreen(customer: customer)),
    );
  }

  testWidgets('shows required validation and creates no profile', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(subject());
    await tester.ensureVisible(find.byKey(const ValueKey('save-measurements')));
    await tester.tap(find.byKey(const ValueKey('save-measurements')));
    await tester.pump();

    expect(find.text('Enter a profile name'), findsOneWidget);
    expect(find.text('Required'), findsWidgets);
    expect(await database.select(database.measurementProfiles).get(), isEmpty);
    expect(await database.select(database.measurementRevisions).get(), isEmpty);
  });

  testWidgets('rejects a non-positive value without clearing input', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(subject());
    await tester.enterText(
      find.byKey(const ValueKey('measurement-profile-name')),
      'Everyday',
    );
    await tester.enterText(
      find.byKey(const ValueKey('measurement-kameez_length')),
      '0',
    );
    await tester.ensureVisible(find.byKey(const ValueKey('save-measurements')));
    await tester.tap(find.byKey(const ValueKey('save-measurements')));
    await tester.pump();

    expect(find.text('Must be positive'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('measurement-kameez_length')),
        matching: find.text('0'),
      ),
      findsOneWidget,
    );
    expect(await database.select(database.measurementProfiles).get(), isEmpty);
  });

  testWidgets('does not silently reinterpret values when unit changes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(subject());
    await tester.enterText(
      find.byKey(const ValueKey('measurement-kameez_length')),
      '30.5',
    );

    await tester.tap(find.text('Centimetres'));
    await tester.pumpAndSettle();

    expect(find.text('Change unit?'), findsOneWidget);
    expect(find.textContaining('never converted'), findsOneWidget);
    await tester.tap(find.text('Keep Values'));
    await tester.pumpAndSettle();
    expect(find.text('30.5'), findsOneWidget);

    await tester.tap(find.text('Centimetres'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear & Change'));
    await tester.pumpAndSettle();

    final field = tester.widget<TextFormField>(
      find.byKey(const ValueKey('measurement-kameez_length')),
    );
    expect(field.controller!.text, isEmpty);
  });
}
