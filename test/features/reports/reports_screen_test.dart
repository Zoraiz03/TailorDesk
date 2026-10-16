import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/core/database/database_provider.dart';
import 'package:tailor/features/reports/reports_screen.dart';

void main() {
  testWidgets('ReportsScreen renders all 4 tabs and empty states', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: ReportsScreen()),
      ),
    );

    // Initial tab: Due & Overdue
    await tester.pumpAndSettle();
    expect(find.text('Reports & analytics'), findsOneWidget);
    expect(find.text('Due & Overdue'), findsOneWidget);
    expect(find.text('Outstanding Balances'), findsOneWidget);
    expect(find.text('Collections'), findsOneWidget);
    expect(find.text('Workload'), findsOneWidget);

    // Empty state on Tab 1
    expect(find.text('All caught up!'), findsOneWidget);

    // Switch to Customer Balances (Tab 2)
    await tester.tap(find.text('Outstanding Balances'));
    await tester.pumpAndSettle();
    expect(find.text('No outstanding balances'), findsOneWidget);

    // Switch to Collections & Refunds (Tab 3)
    await tester.tap(find.text('Collections'));
    await tester.pumpAndSettle();
    expect(find.text('Gross collections'), findsOneWidget);
    expect(find.text('Net collections'), findsOneWidget);
    expect(find.text('Total refunds'), findsOneWidget);

    // Switch to Karigar Workload (Tab 4)
    await tester.tap(find.text('Workload'));
    await tester.pumpAndSettle();
    expect(find.text('Active workers'), findsOneWidget);
    expect(find.text('No karigars registered'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 10));
  });
}
