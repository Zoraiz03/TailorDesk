import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/core/database/database_provider.dart';
import 'package:tailor/features/orders/new_order_screen.dart';

void main() {
  testWidgets('validation keeps entered advance when customer is missing', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: NewOrderScreen()),
      ),
    );
    await tester.pumpAndSettle();

    final advance = find.widgetWithText(TextFormField, 'Advance (PKR)');
    await tester.scrollUntilVisible(
      advance,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(advance, '1234');
    final advanceController = tester.widget<TextFormField>(advance).controller!;
    await tester.scrollUntilVisible(
      find.text('Review & save order'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Review & save order'));
    await tester.pump();

    await tester.drag(find.byType(Scrollable).first, const Offset(0, 1000));
    await tester.pump();
    expect(find.text('Select a customer'), findsOneWidget);
    expect(advanceController.text, '1234');
    expect(await database.select(database.orders).get(), isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
