import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'unconfirmed production example cannot start a customer build',
    () async {
      final result = await Process.run('dart', [
        'run',
        'tool/build_customer_release.dart',
        'config/production-release.example.json',
      ]);
      expect(result.exitCode, 64);
      expect(result.stderr, contains('Customer release blocked'));
      expect(result.stdout, isNot(contains('Building com.')));
    },
  );

  test('missing credentials cannot start an owner-confirmed build', () async {
    final folder = await Directory.systemTemp.createTemp(
      'tailordesk-config-test-',
    );
    addTearDown(() => folder.delete(recursive: true));
    final config =
        jsonDecode(
              await File(
                'config/production-release.example.json',
              ).readAsString(),
            )
            as Map<String, dynamic>;
    config['ownerConfirmed'] = true;
    final file = File('${folder.path}/release.json');
    await file.writeAsString(jsonEncode(config));
    final result = await Process.run('dart', [
      'run',
      'tool/build_customer_release.dart',
      file.path,
    ]);
    expect(result.exitCode, 64);
    expect(result.stderr, contains('Customer release blocked'));
    expect(result.stdout, isNot(contains('Building com.')));
  });
}
