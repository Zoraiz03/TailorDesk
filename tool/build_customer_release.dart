import 'dart:convert';
import 'dart:io';

import 'package:tailor/features/licensing/license_models.dart';

/// Owner-operated wrapper: one external JSON config supplies all release inputs.
/// This tool never reads a license private key or generates credentials.
Future<void> main(List<String> arguments) async {
  try {
    if (arguments.length != 1) {
      throw ArgumentError(
        'Usage: dart run tool/build_customer_release.dart /absolute/release.json',
      );
    }
    final config =
        jsonDecode(await File(arguments.single).readAsString())
            as Map<String, dynamic>;
    if (config['ownerConfirmed'] != true) {
      throw StateError('Owner confirmation is required in the release config.');
    }
    final id = config['applicationId'];
    final name = config['versionName'];
    final code = config['versionCode'];
    if (id is! String ||
        !RegExp(r'^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*){2,}$').hasMatch(id) ||
        id.startsWith('com.example.')) {
      throw StateError(
        'A permanent non-placeholder applicationId is required.',
      );
    }
    if (name is! String ||
        !RegExp(r'^\d+\.\d+\.\d+$').hasMatch(name) ||
        code is! int ||
        code < 1 ||
        code > 2100000000) {
      throw StateError(
        'A versionName and positive Android versionCode are required.',
      );
    }
    if (config['licenseReleaseSequence'] != currentReleaseSequence) {
      throw StateError(
        'Config must acknowledge current license release sequence $currentReleaseSequence.',
      );
    }
    final signing = config['signingProperties'];
    if (signing is! String ||
        !signing.startsWith('/') ||
        !File(signing).existsSync()) {
      throw StateError(
        'An existing external signingProperties file is required.',
      );
    }
    final repo = Directory.current.resolveSymbolicLinksSync();
    if (File(signing).resolveSymbolicLinksSync().startsWith('$repo/')) {
      throw StateError('Signing properties must be outside the repository.');
    }
    final files = config['productionPublicKeyFiles'];
    if (files is! List || files.isEmpty) {
      throw StateError('Explicit production public-key files are required.');
    }
    final keys = <String, String>{};
    for (final path in files) {
      final key =
          jsonDecode(await File(path as String).readAsString())
              as Map<String, dynamic>;
      if (key.keys.toSet().difference({
            'formatVersion',
            'algorithm',
            'keyId',
            'publicKey',
          }).isNotEmpty ||
          key.length != 4 ||
          key['formatVersion'] != 1 ||
          key['algorithm'] != 'Ed25519') {
        throw StateError('Only Ed25519 PUBLIC key documents are accepted.');
      }
      final keyId = key['keyId'] as String;
      final value = key['publicKey'] as String;
      if (!RegExp(r'^[A-Za-z0-9][A-Za-z0-9._:-]*$').hasMatch(keyId) ||
          keyId.startsWith('dev-') ||
          keyId.startsWith('stage11-test') ||
          keys.containsKey(keyId) ||
          decodeBase64Url(value, field: 'public key').length != 32) {
        throw StateError('Invalid, duplicate, or non-production public key.');
      }
      keys[keyId] = value;
    }
    stdout.writeln(
      'Building $id $name ($code), license release $currentReleaseSequence.',
    );
    final process = await Process.start(
      'flutter',
      [
        'build',
        'apk',
        '--release',
        '--build-name=$name',
        '--build-number=$code',
        '--dart-define=TAILORDESK_LICENSE_TRUST_MODE=production',
        '--dart-define=TAILORDESK_LICENSE_PUBLIC_KEYS=${jsonEncode(keys)}',
      ],
      environment: {
        'ORG_GRADLE_PROJECT_tailordeskApplicationId': id,
        'ORG_GRADLE_PROJECT_tailordeskSigningProperties': signing,
        'ORG_GRADLE_PROJECT_tailordeskNonProductionRelease': 'false',
      },
      mode: ProcessStartMode.inheritStdio,
    );
    exitCode = await process.exitCode;
  } catch (_) {
    // Never include file contents or credential values in diagnostics.
    stderr.writeln(
      'Customer release blocked: confirm identity/version/release sequence, '
      'external signing properties, and production public-key files in the config.',
    );
    exitCode = 64;
  }
}
