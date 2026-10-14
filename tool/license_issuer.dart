import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart' as p;
import 'package:tailor/features/licensing/license_models.dart';
import 'package:tailor/features/licensing/license_verifier.dart';

Future<void> main(List<String> arguments) async {
  try {
    if (arguments.isEmpty ||
        {'help', '--help', '-h'}.contains(arguments.first)) {
      _usage();
      return;
    }
    final command = arguments.first;
    final options = _options(arguments.skip(1).toList());
    switch (command) {
      case 'generate-keys':
        await _generateKeys(options);
      case 'issue':
        await _issue(options, event: 'issue');
      case 'renew':
        await _renew(options);
      case 'replace-device':
        await _replaceDevice(options);
      case 'inspect':
        await _inspect(options);
      default:
        throw ArgumentError('Unknown command: $command');
    }
  } catch (error) {
    stderr.writeln('Error: $error');
    exitCode = 64;
  }
}

Future<void> _generateKeys(Map<String, String> options) async {
  final keyId = _required(options, 'key-id');
  final privatePath = _outsideRepository(_required(options, 'private-key'));
  final publicPath = p.absolute(_required(options, 'public-key'));
  if (await File(privatePath).exists() || await File(publicPath).exists()) {
    throw StateError('Refusing to overwrite an existing key file.');
  }
  final algorithm = Ed25519();
  final pair = await (await algorithm.newKeyPair()).extract();
  final privateDocument = jsonEncode(<String, Object>{
    'formatVersion': 1,
    'algorithm': 'Ed25519',
    'keyId': keyId,
    'privateKey': encodeBase64Url(pair.bytes),
    'publicKey': encodeBase64Url(pair.publicKey.bytes),
  });
  final publicDocument = jsonEncode(<String, Object>{
    'formatVersion': 1,
    'algorithm': 'Ed25519',
    'keyId': keyId,
    'publicKey': encodeBase64Url(pair.publicKey.bytes),
  });
  await File(privatePath).parent.create(recursive: true);
  await File(publicPath).parent.create(recursive: true);
  await File(privatePath).writeAsString(privateDocument, flush: true);
  if (!Platform.isWindows) {
    final result = await Process.run('chmod', ['600', privatePath]);
    if (result.exitCode != 0) {
      await File(privatePath).delete();
      throw StateError('Could not restrict private-key file permissions.');
    }
  }
  await File(publicPath).writeAsString(publicDocument, flush: true);
  pair.destroy();
  stdout.writeln('Key pair created. Private key material was not printed.');
  stdout.writeln('Public key: $publicPath');
}

Future<void> _issue(
  Map<String, String> options, {
  required String event,
  String? replacementFor,
}) async {
  final request = ActivationRequest.decode(
    await File(_required(options, 'request')).readAsBytes(),
  );
  if (request.formatVersion != activationRequestFormatVersion ||
      request.productId != tailorDeskProductId) {
    throw const LicenseFormatException('Activation request is not supported.');
  }
  final key = await _readPrivateKey(_required(options, 'private-key'));
  final keyId = _required(options, 'key-id');
  if (key.keyId != keyId) throw StateError('Private key ID does not match.');
  final maintenance = _parseDate(_required(options, 'maintenance-through'));
  final release = int.parse(_required(options, 'max-release'));
  if (release <= 0) throw ArgumentError('max-release must be positive.');
  final payload = LicensePayload(
    formatVersion: licenseFormatVersion,
    keyId: keyId,
    licenseId: _required(options, 'license-id'),
    productId: tailorDeskProductId,
    shopCustomerId: _required(options, 'shop-id'),
    licensedShopName: _required(options, 'shop-name'),
    installationId: request.installationId,
    issuedAt: DateTime.now().toUtc(),
    licenseType: 'perpetual',
    maintenanceThrough: maintenance,
    maximumReleaseSequence: release,
  );
  final license = await _sign(payload, key);
  final output = p.absolute(_required(options, 'output'));
  final outputFile = File(output);
  if (await outputFile.exists()) {
    throw StateError('Refusing to overwrite an existing license file.');
  }
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString(license, flush: true);
  await _appendLedger(
    _outsideRepository(_required(options, 'ledger')),
    <String, Object?>{
      'event': event,
      'recordedAt': DateTime.now().toUtc().toIso8601String(),
      'licenseId': payload.licenseId,
      'keyId': payload.keyId,
      'shopCustomerId': payload.shopCustomerId,
      'licensedShopName': payload.licensedShopName,
      'installationId': payload.installationId,
      'maintenanceThrough': _date(payload.maintenanceThrough),
      'maximumReleaseSequence': payload.maximumReleaseSequence,
      'replacementFor': replacementFor,
      'licensePath': output,
    },
  );
  key.pair.destroy();
  stdout.writeln('License written: $output');
}

Future<void> _renew(Map<String, String> options) async {
  final existing = await _verifiedPayload(options);
  final requestFile = await File(_required(options, 'request')).readAsBytes();
  final request = ActivationRequest.decode(requestFile);
  if (request.installationId != existing.installationId) {
    throw StateError('Renewal request belongs to another installation.');
  }
  options['license-id'] = _required(options, 'new-license-id');
  options['shop-id'] = existing.shopCustomerId;
  options['shop-name'] = existing.licensedShopName;
  final newRelease = int.parse(_required(options, 'max-release'));
  final newMaintenance = _parseDate(_required(options, 'maintenance-through'));
  if (newRelease < existing.maximumReleaseSequence ||
      newMaintenance.isBefore(existing.maintenanceThrough)) {
    throw StateError('Renewal cannot reduce the existing entitlement.');
  }
  await _issue(options, event: 'renewal', replacementFor: existing.licenseId);
}

Future<void> _replaceDevice(Map<String, String> options) async {
  final existing = await _verifiedPayload(options);
  options['license-id'] = _required(options, 'new-license-id');
  options['shop-id'] = existing.shopCustomerId;
  options['shop-name'] = existing.licensedShopName;
  options['maintenance-through'] = _date(existing.maintenanceThrough);
  options['max-release'] = '${existing.maximumReleaseSequence}';
  await _issue(
    options,
    event: 'replacement-device',
    replacementFor: existing.licenseId,
  );
}

Future<void> _inspect(Map<String, String> options) async {
  final payload = await _verifiedPayload(options);
  stdout.writeln(
    const JsonEncoder.withIndent('  ').convert(<String, Object>{
      ...payload.toCanonicalMap(),
      'signatureValid': true,
    }),
  );
}

Future<LicensePayload> _verifiedPayload(Map<String, String> options) async {
  final publicKey = await _readPublicKey(_required(options, 'public-key'));
  final envelopeBytes = await File(_required(options, 'license')).readAsBytes();
  final envelope = SignedLicenseEnvelope.decode(envelopeBytes);
  final payload = LicensePayload.fromCanonicalBytes(envelope.payloadBytes);
  final verifier = LicenseVerifier(
    trustedPublicKeys: {publicKey.keyId: publicKey.bytes},
    productId: payload.productId,
    releaseSequence: 0,
  );
  final result = await verifier.verify(
    envelopeBytes,
    installationId: payload.installationId,
  );
  if (!result.isActive) throw StateError(result.message);
  return payload;
}

Future<String> _sign(LicensePayload payload, _PrivateKeyFile key) async {
  final payloadBytes = payload.canonicalBytes();
  final signature = await Ed25519().sign(payloadBytes, keyPair: key.pair);
  return SignedLicenseEnvelope(
    formatVersion: licenseFormatVersion,
    keyId: payload.keyId,
    payloadBytes: payloadBytes,
    signatureBytes: Uint8List.fromList(signature.bytes),
  ).encode();
}

Future<_PrivateKeyFile> _readPrivateKey(String path) async {
  final decoded = jsonDecode(await File(path).readAsString());
  if (decoded is! Map<String, dynamic> ||
      decoded['formatVersion'] != 1 ||
      decoded['algorithm'] != 'Ed25519') {
    throw StateError('Unsupported private-key file.');
  }
  final keyId = decoded['keyId'] as String;
  final privateBytes = decodeBase64Url(
    decoded['privateKey'] as String,
    field: 'privateKey',
  );
  final publicBytes = decodeBase64Url(
    decoded['publicKey'] as String,
    field: 'publicKey',
  );
  if (privateBytes.length != 32 || publicBytes.length != 32) {
    throw StateError('Invalid Ed25519 key size.');
  }
  final derived = await (await Ed25519().newKeyPairFromSeed(
    privateBytes,
  )).extract();
  if (!_sameBytes(derived.publicKey.bytes, publicBytes)) {
    derived.destroy();
    throw StateError('Private and public key material do not match.');
  }
  return _PrivateKeyFile(keyId, derived);
}

Future<_PublicKeyFile> _readPublicKey(String path) async {
  final decoded = jsonDecode(await File(path).readAsString());
  if (decoded is! Map<String, dynamic> ||
      decoded['formatVersion'] != 1 ||
      decoded['algorithm'] != 'Ed25519') {
    throw StateError('Unsupported public-key file.');
  }
  final bytes = decodeBase64Url(
    decoded['publicKey'] as String,
    field: 'publicKey',
  );
  if (bytes.length != 32) throw StateError('Invalid Ed25519 public key size.');
  return _PublicKeyFile(decoded['keyId'] as String, bytes);
}

Future<void> _appendLedger(String path, Map<String, Object?> record) async {
  final file = File(path);
  await file.parent.create(recursive: true);
  await file.writeAsString(
    '${jsonEncode(record)}\n',
    mode: FileMode.append,
    flush: true,
  );
}

Map<String, String> _options(List<String> arguments) {
  final result = <String, String>{};
  for (var index = 0; index < arguments.length; index += 2) {
    if (index + 1 >= arguments.length || !arguments[index].startsWith('--')) {
      throw ArgumentError('Options must use --name value pairs.');
    }
    result[arguments[index].substring(2)] = arguments[index + 1];
  }
  return result;
}

String _required(Map<String, String> options, String name) {
  final value = options[name];
  if (value == null || value.trim().isEmpty) {
    throw ArgumentError('--$name is required.');
  }
  return value;
}

String _outsideRepository(String path) {
  final absolute = p.normalize(p.absolute(path));
  final repository = p.normalize(Directory.current.absolute.path);
  if (p.isWithin(repository, absolute) || absolute == repository) {
    throw ArgumentError(
      'Sensitive owner files must be outside the repository.',
    );
  }
  return absolute;
}

DateTime _parseDate(String source) {
  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(source)) {
    throw ArgumentError('Date must be YYYY-MM-DD.');
  }
  final parts = source.split('-').map(int.parse).toList();
  final value = DateTime.utc(parts[0], parts[1], parts[2]);
  if (_date(value) != source) throw ArgumentError('Invalid calendar date.');
  return value;
}

String _date(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

bool _sameBytes(List<int> left, List<int> right) {
  if (left.length != right.length) return false;
  var difference = 0;
  for (var index = 0; index < left.length; index++) {
    difference |= left[index] ^ right[index];
  }
  return difference == 0;
}

void _usage() {
  stdout.writeln('TailorDesk private license issuer');
  stdout.writeln(
    'Commands: generate-keys, issue, inspect, renew, replace-device',
  );
  stdout.writeln('Run commands only on the owner-controlled issuer machine.');
}

class _PrivateKeyFile {
  const _PrivateKeyFile(this.keyId, this.pair);
  final String keyId;
  final SimpleKeyPairData pair;
}

class _PublicKeyFile {
  const _PublicKeyFile(this.keyId, this.bytes);
  final String keyId;
  final Uint8List bytes;
}
