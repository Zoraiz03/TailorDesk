import 'dart:convert';
import 'dart:io';

/// Owner-operated wrapper: one external JSON config supplies all release inputs.
/// This tool never reads or generates signing credentials.
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
    final label = config['appLabel'];
    final name = config['versionName'];
    final code = config['versionCode'];
    if (id is! String ||
        !RegExp(r'^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*){2,}$').hasMatch(id) ||
        id.startsWith('com.example.')) {
      throw StateError(
        'A permanent non-placeholder applicationId is required.',
      );
    }
    if (label is! String || label.trim().isEmpty || label.length > 50) {
      throw StateError('A visible application label is required.');
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
    stdout.writeln('Building $id $name ($code).');
    final process = await Process.start(
      'flutter',
      [
        'build',
        'apk',
        '--release',
        '--build-name=$name',
        '--build-number=$code',
      ],
      environment: {
        'ORG_GRADLE_PROJECT_tailordeskApplicationId': id,
        'ORG_GRADLE_PROJECT_tailordeskAppLabel': label,
        'ORG_GRADLE_PROJECT_tailordeskSigningProperties': signing,
        'ORG_GRADLE_PROJECT_tailordeskNonProductionRelease': 'false',
      },
      mode: ProcessStartMode.inheritStdio,
    );
    exitCode = await process.exitCode;
  } catch (_) {
    // Never include file contents or credential values in diagnostics.
    stderr.writeln(
      'Customer release blocked: confirm identity/version/app label and '
      'external signing properties in the config.',
    );
    exitCode = 64;
  }
}
