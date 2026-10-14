import 'dart:convert';
import 'dart:typed_data';

const licenseFormatVersion = 1;
const activationRequestFormatVersion = 1;
const tailorDeskProductId = 'tailordesk';
const currentReleaseSequence = 10;
const maximumLicenseBytes = 64 * 1024;

String encodeBase64Url(List<int> bytes) =>
    base64Url.encode(bytes).replaceAll('=', '');

Uint8List decodeBase64Url(String value, {required String field}) {
  if (value.isEmpty ||
      value.length > maximumLicenseBytes ||
      !RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(value)) {
    throw LicenseFormatException('$field is not valid base64url.');
  }
  try {
    return Uint8List.fromList(base64Url.decode(base64Url.normalize(value)));
  } catch (_) {
    throw LicenseFormatException('$field is not valid base64url.');
  }
}

class LicenseFormatException implements Exception {
  const LicenseFormatException(this.message);
  final String message;

  @override
  String toString() => message;
}

class LicensePayload {
  const LicensePayload({
    required this.formatVersion,
    required this.keyId,
    required this.licenseId,
    required this.productId,
    required this.shopCustomerId,
    required this.licensedShopName,
    required this.installationId,
    required this.issuedAt,
    required this.licenseType,
    required this.maintenanceThrough,
    required this.maximumReleaseSequence,
  });

  final int formatVersion;
  final String keyId;
  final String licenseId;
  final String productId;
  final String shopCustomerId;
  final String licensedShopName;
  final String installationId;
  final DateTime issuedAt;
  final String licenseType;
  final DateTime maintenanceThrough;
  final int maximumReleaseSequence;

  Map<String, Object> toCanonicalMap() => <String, Object>{
    'formatVersion': formatVersion,
    'keyId': keyId,
    'licenseId': licenseId,
    'productId': productId,
    'shopCustomerId': shopCustomerId,
    'licensedShopName': licensedShopName,
    'installationId': installationId,
    'issuedAt': issuedAt.toUtc().toIso8601String(),
    'licenseType': licenseType,
    'maintenanceThrough': _dateText(maintenanceThrough),
    'maximumReleaseSequence': maximumReleaseSequence,
  };

  Uint8List canonicalBytes() =>
      Uint8List.fromList(utf8.encode(jsonEncode(toCanonicalMap())));

  static LicensePayload fromCanonicalBytes(Uint8List bytes) {
    if (bytes.isEmpty || bytes.length > maximumLicenseBytes) {
      throw const LicenseFormatException('License payload size is invalid.');
    }
    late final Object? decoded;
    try {
      decoded = jsonDecode(utf8.decode(bytes, allowMalformed: false));
    } catch (_) {
      throw const LicenseFormatException('License payload is malformed.');
    }
    if (decoded is! Map<String, dynamic>) {
      throw const LicenseFormatException('License payload must be an object.');
    }
    const expected = {
      'formatVersion',
      'keyId',
      'licenseId',
      'productId',
      'shopCustomerId',
      'licensedShopName',
      'installationId',
      'issuedAt',
      'licenseType',
      'maintenanceThrough',
      'maximumReleaseSequence',
    };
    if (decoded.keys.toSet().difference(expected).isNotEmpty ||
        expected.difference(decoded.keys.toSet()).isNotEmpty) {
      throw const LicenseFormatException(
        'License payload contains missing or unsupported fields.',
      );
    }
    final payload = LicensePayload(
      formatVersion: _requiredInt(decoded, 'formatVersion'),
      keyId: _requiredId(decoded, 'keyId'),
      licenseId: _requiredId(decoded, 'licenseId'),
      productId: _requiredId(decoded, 'productId'),
      shopCustomerId: _requiredId(decoded, 'shopCustomerId'),
      licensedShopName: _requiredText(decoded, 'licensedShopName', 160),
      installationId: _requiredId(decoded, 'installationId'),
      issuedAt: _requiredUtcTimestamp(decoded, 'issuedAt'),
      licenseType: _requiredId(decoded, 'licenseType'),
      maintenanceThrough: _requiredDate(decoded, 'maintenanceThrough'),
      maximumReleaseSequence: _requiredInt(decoded, 'maximumReleaseSequence'),
    );
    if (!const ListEquality().equals(payload.canonicalBytes(), bytes)) {
      throw const LicenseFormatException(
        'License payload serialization is not canonical.',
      );
    }
    return payload;
  }
}

class SignedLicenseEnvelope {
  const SignedLicenseEnvelope({
    required this.formatVersion,
    required this.keyId,
    required this.payloadBytes,
    required this.signatureBytes,
  });

  final int formatVersion;
  final String keyId;
  final Uint8List payloadBytes;
  final Uint8List signatureBytes;

  String encode() => jsonEncode(<String, Object>{
    'formatVersion': formatVersion,
    'keyId': keyId,
    'payload': encodeBase64Url(payloadBytes),
    'signature': encodeBase64Url(signatureBytes),
  });

  static SignedLicenseEnvelope decode(List<int> bytes) {
    if (bytes.isEmpty || bytes.length > maximumLicenseBytes) {
      throw const LicenseFormatException('License file is empty or too large.');
    }
    late final Object? decoded;
    try {
      decoded = jsonDecode(utf8.decode(bytes, allowMalformed: false));
    } catch (_) {
      throw const LicenseFormatException('License envelope is malformed.');
    }
    if (decoded is! Map<String, dynamic> ||
        decoded.keys.toSet().difference(const {
          'formatVersion',
          'keyId',
          'payload',
          'signature',
        }).isNotEmpty ||
        decoded.length != 4) {
      throw const LicenseFormatException(
        'License envelope contains unsupported fields.',
      );
    }
    final format = _requiredInt(decoded, 'formatVersion');
    final keyId = _requiredId(decoded, 'keyId');
    final payloadText = _requiredText(decoded, 'payload', maximumLicenseBytes);
    final signatureText = _requiredText(
      decoded,
      'signature',
      maximumLicenseBytes,
    );
    return SignedLicenseEnvelope(
      formatVersion: format,
      keyId: keyId,
      payloadBytes: decodeBase64Url(payloadText, field: 'payload'),
      signatureBytes: decodeBase64Url(signatureText, field: 'signature'),
    );
  }
}

class ActivationRequest {
  const ActivationRequest({
    required this.formatVersion,
    required this.productId,
    required this.installationId,
  });

  final int formatVersion;
  final String productId;
  final String installationId;

  String encode() => jsonEncode(<String, Object>{
    'formatVersion': formatVersion,
    'productId': productId,
    'installationId': installationId,
  });

  static ActivationRequest decode(List<int> bytes) {
    if (bytes.isEmpty || bytes.length > 4096) {
      throw const LicenseFormatException(
        'Activation request is empty or too large.',
      );
    }
    late final Object? decoded;
    try {
      decoded = jsonDecode(utf8.decode(bytes, allowMalformed: false));
    } catch (_) {
      throw const LicenseFormatException('Activation request is malformed.');
    }
    if (decoded is! Map<String, dynamic> ||
        decoded.length != 3 ||
        decoded.keys.toSet().difference(const {
          'formatVersion',
          'productId',
          'installationId',
        }).isNotEmpty) {
      throw const LicenseFormatException(
        'Activation request contains unsupported fields.',
      );
    }
    return ActivationRequest(
      formatVersion: _requiredInt(decoded, 'formatVersion'),
      productId: _requiredId(decoded, 'productId'),
      installationId: _requiredId(decoded, 'installationId'),
    );
  }
}

int _requiredInt(Map<String, dynamic> map, String key) {
  final value = map[key];
  if (value is! int || value < 0) {
    throw LicenseFormatException('$key must be a non-negative integer.');
  }
  return value;
}

String _requiredText(Map<String, dynamic> map, String key, int maximumLength) {
  final value = map[key];
  if (value is! String ||
      value.trim() != value ||
      value.isEmpty ||
      value.length > maximumLength ||
      value.contains(RegExp(r'[\u0000-\u001f]'))) {
    throw LicenseFormatException('$key is invalid.');
  }
  return value;
}

String _requiredId(Map<String, dynamic> map, String key) {
  final value = _requiredText(map, key, 160);
  if (!RegExp(r'^[A-Za-z0-9][A-Za-z0-9._:-]*$').hasMatch(value)) {
    throw LicenseFormatException('$key is invalid.');
  }
  return value;
}

DateTime _requiredUtcTimestamp(Map<String, dynamic> map, String key) {
  final source = _requiredText(map, key, 40);
  late final DateTime parsed;
  try {
    parsed = DateTime.parse(source);
  } catch (_) {
    throw LicenseFormatException('$key is invalid.');
  }
  if (!parsed.isUtc || parsed.toIso8601String() != source) {
    throw LicenseFormatException('$key must be a canonical UTC timestamp.');
  }
  return parsed;
}

DateTime _requiredDate(Map<String, dynamic> map, String key) {
  final source = _requiredText(map, key, 10);
  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(source)) {
    throw LicenseFormatException('$key must be YYYY-MM-DD.');
  }
  final parts = source.split('-').map(int.parse).toList();
  final parsed = DateTime.utc(parts[0], parts[1], parts[2]);
  if (_dateText(parsed) != source) {
    throw LicenseFormatException('$key is not a valid date.');
  }
  return parsed;
}

String _dateText(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

class ListEquality {
  const ListEquality();

  bool equals(List<int> left, List<int> right) {
    if (left.length != right.length) return false;
    var difference = 0;
    for (var i = 0; i < left.length; i++) {
      difference |= left[i] ^ right[i];
    }
    return difference == 0;
  }
}
