import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/features/customers/customer_providers.dart';
import 'package:tailor/features/customers/customers_screen.dart';

void main() {
  final now = DateTime(2026, 10, 10);
  final customers = [
    Customer(
      id: 1,
      name: 'Zain',
      phone: '03001234567',
      address: '',
      notes: '',
      createdAt: now,
      updatedAt: now,
    ),
    Customer(
      id: 2,
      name: 'Ahmed Khan',
      phone: '03117654321',
      address: '',
      notes: '',
      createdAt: now,
      updatedAt: now.add(const Duration(minutes: 1)),
    ),
  ];

  Widget subject() {
    return ProviderScope(
      overrides: [
        customersProvider.overrideWith((ref) => Stream.value(customers)),
      ],
      child: const MaterialApp(home: CustomersScreen()),
    );
  }

  testWidgets('searches customers by name and phone', (tester) async {
    await tester.pumpWidget(subject());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('customer-search')),
      '0311',
    );
    await tester.pump();

    expect(find.text('Ahmed Khan'), findsOneWidget);
    expect(find.text('Zain'), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('customer-search')),
      'zain',
    );
    await tester.pump();

    expect(find.text('Zain'), findsOneWidget);
    expect(find.text('Ahmed Khan'), findsNothing);
  });

  testWidgets('sorts customers by name', (tester) async {
    await tester.pumpWidget(subject());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Sort customers'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Name A–Z'));
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('Ahmed Khan')).dy,
      lessThan(tester.getTopLeft(find.text('Zain')).dy),
    );
  });
}
