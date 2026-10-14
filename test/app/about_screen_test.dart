import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/app/about_screen.dart';

void main() {
  const channel = MethodChannel('tailordesk/delivery');
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets(
    'About shows installed version and unchanged entitlement sequence',
    (tester) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            expect(call.method, 'appVersion');
            return '12.0.0-test (12001)';
          });
      await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
      await tester.pumpAndSettle();
      expect(find.text('About TailorDesk'), findsOneWidget);
      expect(find.text('App version: 12.0.0-test (12001)'), findsOneWidget);
      expect(find.text('License release sequence: 10'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('About handles absent native version API on small screens', (
    tester,
  ) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          channel,
          (_) async => throw MissingPluginException(),
        );
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('See the installed application details'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
