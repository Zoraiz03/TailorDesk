import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'license_models.dart';

enum LicenseStatus {
  active,
  missing,
  malformed,
  untrustedKey,
  invalidSignature,
  wrongProduct,
  wrongInstallation,
  unsupportedFormat,
  releaseNotEntitled,
  storageUnavailable,
}

class LicenseValidationResult {
  const LicenseValidationResult({
    required this.status,
    this.payload,
    this.message = '',
  });

  final LicenseStatus status;
  final LicensePayload? payload;
  final String message;

  bool get isActive => status == LicenseStatus.active;
}

class LicenseVerifier {
  LicenseVerifier({
    required this.trustedPublicKeys,
    this.productId = tailorDeskProductId,
    this.releaseSequence = currentReleaseSequence,
    Ed25519? algorithm,
  }) : _algorithm = algorithm ?? Ed25519();

  final Map<String, Uint8List> trustedPublicKeys;
  final String productId;
  final int releaseSequence;
  final Ed25519 _algorithm;

  Future<LicenseValidationResult> verify(
    List<int> licenseBytes, {
    required String installationId,
  }) async {
    late final SignedLicenseEnvelope envelope;
    late final LicensePayload payload;
    try {
      envelope = SignedLicenseEnvelope.decode(licenseBytes);
      if (envelope.formatVersion != licenseFormatVersion) {
        return const LicenseValidationResult(
          status: LicenseStatus.unsupportedFormat,
          message: 'This license format is not supported.',
        );
      }
      payload = LicensePayload.fromCanonicalBytes(envelope.payloadBytes);
    } on LicenseFormatException catch (error) {
      return LicenseValidationResult(
        status: LicenseStatus.malformed,
        message: error.message,
      );
    }
    if (payload.formatVersion != licenseFormatVersion) {
      return const LicenseValidationResult(
        status: LicenseStatus.unsupportedFormat,
        message: 'This license payload format is not supported.',
      );
    }
    if (payload.keyId != envelope.keyId) {
      return const LicenseValidationResult(
        status: LicenseStatus.malformed,
        message: 'The license key identifiers do not match.',
      );
    }
    final publicKeyBytes = trustedPublicKeys[envelope.keyId];
    if (publicKeyBytes == null || publicKeyBytes.length != 32) {
      return const LicenseValidationResult(
        status: LicenseStatus.untrustedKey,
        message: 'The license was signed by an untrusted key.',
      );
    }
    if (envelope.signatureBytes.length != 64) {
      return const LicenseValidationResult(
        status: LicenseStatus.invalidSignature,
        message: 'The license signature has an invalid size.',
      );
    }
    final verified = await _algorithm.verify(
      envelope.payloadBytes,
      signature: Signature(
        envelope.signatureBytes,
        publicKey: SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519),
      ),
    );
    if (!verified) {
      return const LicenseValidationResult(
        status: LicenseStatus.invalidSignature,
        message: 'The license signature is invalid.',
      );
    }
    if (payload.productId != productId) {
      return const LicenseValidationResult(
        status: LicenseStatus.wrongProduct,
        message: 'This license is for a different product.',
      );
    }
    if (payload.installationId != installationId) {
      return const LicenseValidationResult(
        status: LicenseStatus.wrongInstallation,
        message: 'This license belongs to a different installation.',
      );
    }
    if (payload.licenseType != 'perpetual') {
      return const LicenseValidationResult(
        status: LicenseStatus.malformed,
        message: 'The license type is not supported.',
      );
    }
    if (payload.maximumReleaseSequence < releaseSequence) {
      return LicenseValidationResult(
        status: LicenseStatus.releaseNotEntitled,
        payload: payload,
        message:
            'This license covers release ${payload.maximumReleaseSequence}, '
            'but this app is release $releaseSequence.',
      );
    }
    return LicenseValidationResult(
      status: LicenseStatus.active,
      payload: payload,
    );
  }

  static Map<String, Uint8List> trustedKeysFromEnvironment() {
    const trustMode = String.fromEnvironment(
      'TAILORDESK_LICENSE_TRUST_MODE',
      defaultValue: 'unconfigured',
    );
    if (!{'development', 'test', 'production'}.contains(trustMode)) {
      return const {};
    }
    const source = String.fromEnvironment(
      'TAILORDESK_LICENSE_PUBLIC_KEYS',
      defaultValue: '{}',
    );
    try {
      final decoded = jsonDecode(source);
      if (decoded is! Map<String, dynamic>) return const {};
      final result = <String, Uint8List>{};
      for (final entry in decoded.entries) {
        if (!RegExp(r'^[A-Za-z0-9][A-Za-z0-9._:-]*$').hasMatch(entry.key) ||
            entry.value is! String) {
          return const {};
        }
        if (trustMode == 'production' &&
            (entry.key.startsWith('dev-') ||
                entry.key.startsWith('stage11-test'))) {
          return const {};
        }
        final bytes = decodeBase64Url(
          entry.value as String,
          field: 'public key',
        );
        if (bytes.length != 32) return const {};
        result[entry.key] = bytes;
      }
      return result;
    } catch (_) {
      return const {};
    }
  }
}
