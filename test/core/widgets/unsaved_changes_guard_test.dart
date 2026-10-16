import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/widgets/unsaved_changes_guard.dart';

void main() {
  testWidgets('asks before leaving a form with unsaved changes', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute(builder: (_) => const _GuardedForm()),
              ),
              child: const Text('Open form'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open form'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'unsaved value');
    await tester.pump();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Discard changes?'), findsOneWidget);
    await tester.tap(find.text('Keep editing'));
    await tester.pumpAndSettle();
    expect(find.text('Edit details'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(find.text('Open form'), findsOneWidget);
  });
}

class _GuardedForm extends StatefulWidget {
  const _GuardedForm();

  @override
  State<_GuardedForm> createState() => _GuardedFormState();
}

class _GuardedFormState extends State<_GuardedForm> {
  bool _dirty = false;

  @override
  Widget build(BuildContext context) => UnsavedChangesGuard(
    hasUnsavedChanges: _dirty,
    child: Scaffold(
      appBar: AppBar(title: const Text('Edit details')),
      body: TextField(onChanged: (_) => setState(() => _dirty = true)),
    ),
  );
}
