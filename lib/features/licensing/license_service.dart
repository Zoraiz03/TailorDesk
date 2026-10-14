import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import '../../core/database/app_database.dart';
import 'activation_store.dart';
import 'license_models.dart';
import 'license_verifier.dart';

class LicenseAppState {
  const LicenseAppState({
    required this.installationId,
    required this.validation,
    required this.hasBusinessData,
  });

  final String installationId;
  final LicenseValidationResult validation;
  final bool hasBusinessData;

  bool get isActivated => validation.isActive;
  LicensePayload? get license => validation.payload;
}

class LicenseService {
  LicenseService({
    required this.store,
    required this.verifier,
    required this.database,
    Random? secureRandom,
  }) : _secureRandom = secureRandom ?? Random.secure();

  final ActivationStore store;
  final LicenseVerifier verifier;
  final AppDatabase database;
  final Random _secureRandom;

  Future<LicenseAppState> load() async {
    late final String installationId;
    try {
      installationId = await _installationId();
    } catch (_) {
      database.setBusinessWritesAllowed(false);
      return LicenseAppState(
        installationId: '',
        validation: const LicenseValidationResult(
          status: LicenseStatus.storageUnavailable,
          message:
              'Activation storage is unavailable. The installation identity was not regenerated.',
        ),
        hasBusinessData: await _hasBusinessData(),
      );
    }

    LicenseValidationResult validation;
    try {
      final stored = await store.readLicense();
      validation = stored == null
          ? const LicenseValidationResult(
              status: LicenseStatus.missing,
              message: 'No license has been imported for this installation.',
            )
          : await verifier.verify(
              utf8.encode(stored),
              installationId: installationId,
            );
    } catch (_) {
      validation = const LicenseValidationResult(
        status: LicenseStatus.storageUnavailable,
        message: 'The saved activation could not be read safely.',
      );
    }
    database.setBusinessWritesAllowed(validation.isActive);
    return LicenseAppState(
      installationId: installationId,
      validation: validation,
      hasBusinessData: await _hasBusinessData(),
    );
  }

  Future<LicenseValidationResult> importLicense(List<int> bytes) async {
    final installationId = await _installationId();
    final candidate = await verifier.verify(
      bytes,
      installationId: installationId,
    );
    if (!candidate.isActive) return candidate;

    final stored = await store.readLicense();
    if (stored != null) {
      final current = await verifier.verify(
        utf8.encode(stored),
        installationId: installationId,
      );
      if (current.isActive &&
          _isLowerEntitlement(candidate.payload!, current.payload!)) {
        return const LicenseValidationResult(
          status: LicenseStatus.releaseNotEntitled,
          message:
              'The imported license has lower entitlement than the current license.',
        );
      }
    }
    await store.writeLicense(utf8.decode(bytes, allowMalformed: false));
    database.setBusinessWritesAllowed(true);
    return candidate;
  }

  Future<Uint8List> activationRequestBytes() async {
    return activationRequestBytesForInstallation(await _installationId());
  }

  static Uint8List activationRequestBytesForInstallation(
    String installationId,
  ) {
    final request = ActivationRequest(
      formatVersion: activationRequestFormatVersion,
      productId: tailorDeskProductId,
      installationId: installationId,
    );
    return Uint8List.fromList(utf8.encode(request.encode()));
  }

  bool _isLowerEntitlement(LicensePayload candidate, LicensePayload current) {
    if (candidate.maximumReleaseSequence != current.maximumReleaseSequence) {
      return candidate.maximumReleaseSequence < current.maximumReleaseSequence;
    }
    return candidate.maintenanceThrough.isBefore(current.maintenanceThrough);
  }

  Future<String> _installationId() async {
    final existing = await store.readInstallationId();
    if (existing != null) {
      if (!RegExp(r'^inst_[A-Za-z0-9_-]{32}$').hasMatch(existing)) {
        throw StateError('Stored installation ID is invalid');
      }
      return existing;
    }
    final randomBytes = Uint8List(24);
    for (var index = 0; index < randomBytes.length; index++) {
      randomBytes[index] = _secureRandom.nextInt(256);
    }
    final generated = 'inst_${encodeBase64Url(randomBytes)}';
    await store.writeInstallationId(generated);
    final confirmed = await store.readInstallationId();
    if (confirmed != generated) {
      throw StateError('Installation identity could not be stored safely');
    }
    return generated;
  }

  Future<bool> _hasBusinessData() async {
    final row = await database.customSelect('''
      SELECT
        (SELECT COUNT(*) FROM customers) +
        (SELECT COUNT(*) FROM orders) +
        (SELECT COUNT(*) FROM karigars) AS record_count
    ''').getSingle();
    final count = row.read<int>('record_count');
    if (count > 0) return true;
    final setup = await (database.select(
      database.appSettings,
    )..where((entry) => entry.key.equals('setup_completed'))).getSingleOrNull();
    return setup?.value == 'true';
  }
}
