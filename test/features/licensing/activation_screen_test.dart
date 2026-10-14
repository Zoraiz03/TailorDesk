import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/features/licensing/activation_screen.dart';
import 'package:tailor/features/licensing/license_models.dart';
import 'package:tailor/features/licensing/license_providers.dart';
import 'package:tailor/features/licensing/license_service.dart';
import 'package:tailor/features/licensing/license_verifier.dart';

const installation = 'inst_Vbf57-ek4IAv2vUVPwYTNP1z_2dWGxbR';

class _UnactivatedController extends LicenseController {
  @override
  Future<LicenseAppState> build() async => const LicenseAppState(
    installationId: installation,
    validation: LicenseValidationResult(status: LicenseStatus.missing),
    hasBusinessData: false,
  );
}

void main() {
  const channel = MethodChannel('tailordesk/delivery');
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  for (final outcome in ['saved', 'cancelled', 'failed']) {
    testWidgets('Android activation download handles $outcome', (tester) async {
      expect(defaultTargetPlatform, TargetPlatform.android);
      var calls = 0;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls++;
            expect(call.method, 'saveActivationRequest');
            final bytes = call.arguments['bytes'] as Uint8List;
            expect(
              bytes,
              LicenseService.activationRequestBytesForInstallation(
                installation,
              ),
            );
            expect(
              ActivationRequest.decode(bytes).installationId,
              installation,
            );
            if (outcome == 'failed') {
              throw PlatformException(code: 'save_failed');
            }
            return outcome == 'saved';
          });
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            licenseStateProvider.overrideWith(_UnactivatedController.new),
          ],
          child: const MaterialApp(home: ActivationScreen()),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Download activation request'));
      await tester.pumpAndSettle();
      expect(calls, 1);
      final expected = switch (outcome) {
        'saved' =>
          'Downloaded tailordesk-activation-request.json with the exact issuer JSON.',
        'cancelled' => 'Download was cancelled.',
        _ => 'The activation request could not be downloaded on this platform.',
      };
      expect(find.text(expected), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
