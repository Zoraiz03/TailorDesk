import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/features/customers/data/customers_dao.dart';
import 'package:tailor/features/licensing/activation_store.dart';
import 'package:tailor/features/licensing/license_models.dart';
import 'package:tailor/features/licensing/license_service.dart';
import 'package:tailor/features/licensing/license_verifier.dart';
import 'package:tailor/features/measurements/data/measurements_dao.dart';
import 'package:tailor/features/measurements/measurement_models.dart';
import 'package:tailor/features/measurements/measurement_templates.dart';
import 'package:tailor/features/settings/backup/backup_service.dart';
import 'package:tailor/features/settings/shop_settings.dart';
import 'package:tailor/features/settings/shop_settings_providers.dart';

void main() {
  late SimpleKeyPairData signingKey;
  late Uint8List publicKey;
  late LicenseVerifier verifier;
  late AppDatabase database;
  late MemoryActivationStore store;

  setUp(() async {
    signingKey = await (await Ed25519().newKeyPair()).extract();
    publicKey = Uint8List.fromList(signingKey.publicKey.bytes);
    verifier = LicenseVerifier(trustedPublicKeys: {'test-key': publicKey});
    database = AppDatabase(
      NativeDatabase.memory(),
      businessWritesAllowed: false,
    );
    store = MemoryActivationStore(installationId: _installationA);
  });

  tearDown(() async {
    signingKey.destroy();
    await database.close();
  });

  test(
    'valid offline activation survives restart and ignores maintenance expiry',
    () async {
      final license = await _license(
        signingKey,
        maintenanceThrough: DateTime.utc(2020, 1, 1),
        maximumRelease: currentReleaseSequence,
      );
      final service = LicenseService(
        store: store,
        verifier: verifier,
        database: database,
      );

      final imported = await service.importLicense(utf8.encode(license));
      expect(imported.isActive, isTrue);
      expect(database.businessWritesAllowed, isTrue);

      database.setBusinessWritesAllowed(false);
      final restarted = await service.load();
      expect(restarted.isActivated, isTrue);
      expect(restarted.license!.maintenanceThrough, DateTime.utc(2020, 1, 1));
      expect(database.businessWritesAllowed, isTrue);
    },
  );

  test('rejects tampering, wrong installation, product, and key', () async {
    final valid = await _license(signingKey);
    final envelope = SignedLicenseEnvelope.decode(utf8.encode(valid));
    final tamperedPayload = Uint8List.fromList(envelope.payloadBytes);
    tamperedPayload[tamperedPayload.length - 2] ^= 1;
    final tampered = SignedLicenseEnvelope(
      formatVersion: envelope.formatVersion,
      keyId: envelope.keyId,
      payloadBytes: tamperedPayload,
      signatureBytes: envelope.signatureBytes,
    ).encode();
    expect(
      (await verifier.verify(
        utf8.encode(tampered),
        installationId: _installationA,
      )).isActive,
      isFalse,
    );

    final badSignature = Uint8List.fromList(envelope.signatureBytes)..[0] ^= 1;
    final signatureTampered = SignedLicenseEnvelope(
      formatVersion: envelope.formatVersion,
      keyId: envelope.keyId,
      payloadBytes: envelope.payloadBytes,
      signatureBytes: badSignature,
    ).encode();
    expect(
      (await verifier.verify(
        utf8.encode(signatureTampered),
        installationId: _installationA,
      )).status,
      LicenseStatus.invalidSignature,
    );
    expect(
      (await verifier.verify(
        utf8.encode(valid),
        installationId: _installationB,
      )).status,
      LicenseStatus.wrongInstallation,
    );

    final wrongProduct = await _license(
      signingKey,
      productId: 'another-product',
    );
    expect(
      (await verifier.verify(
        utf8.encode(wrongProduct),
        installationId: _installationA,
      )).status,
      LicenseStatus.wrongProduct,
    );
    final untrusted = LicenseVerifier(trustedPublicKeys: const {});
    expect(
      (await untrusted.verify(
        utf8.encode(valid),
        installationId: _installationA,
      )).status,
      LicenseStatus.untrustedKey,
    );
    final otherKey = await (await Ed25519().newKeyPair()).extract();
    addTearDown(otherKey.destroy);
    final wrongTrustedKey = LicenseVerifier(
      trustedPublicKeys: {
        'test-key': Uint8List.fromList(otherKey.publicKey.bytes),
      },
    );
    expect(
      (await wrongTrustedKey.verify(
        utf8.encode(valid),
        installationId: _installationA,
      )).status,
      LicenseStatus.invalidSignature,
    );
  });

  test(
    'rejects malformed, oversized, unsupported, and under-entitled input',
    () async {
      expect(
        (await verifier.verify([
          1,
          2,
          3,
        ], installationId: _installationA)).status,
        LicenseStatus.malformed,
      );
      expect(
        (await verifier.verify(
          List<int>.filled(maximumLicenseBytes + 1, 65),
          installationId: _installationA,
        )).status,
        LicenseStatus.malformed,
      );
      final valid = SignedLicenseEnvelope.decode(
        utf8.encode(await _license(signingKey)),
      );
      final unsupported = SignedLicenseEnvelope(
        formatVersion: 99,
        keyId: valid.keyId,
        payloadBytes: valid.payloadBytes,
        signatureBytes: valid.signatureBytes,
      ).encode();
      expect(
        (await verifier.verify(
          utf8.encode(unsupported),
          installationId: _installationA,
        )).status,
        LicenseStatus.unsupportedFormat,
      );
      final oldRelease = await _license(
        signingKey,
        maximumRelease: currentReleaseSequence - 1,
      );
      expect(
        (await verifier.verify(
          utf8.encode(oldRelease),
          installationId: _installationA,
        )).status,
        LicenseStatus.releaseNotEntitled,
      );
      final future = await _license(
        signingKey,
        maximumRelease: currentReleaseSequence + 5,
      );
      expect(
        (await verifier.verify(
          utf8.encode(future),
          installationId: _installationA,
        )).isActive,
        isTrue,
      );
    },
  );

  test(
    'invalid or lower-entitlement import preserves current activation',
    () async {
      final service = LicenseService(
        store: store,
        verifier: verifier,
        database: database,
      );
      final current = await _license(
        signingKey,
        licenseId: 'license-current',
        maximumRelease: currentReleaseSequence + 2,
        maintenanceThrough: DateTime.utc(2028, 12, 31),
      );
      await service.importLicense(utf8.encode(current));
      final stored = store.license;

      final lower = await _license(
        signingKey,
        licenseId: 'license-lower',
        maximumRelease: currentReleaseSequence,
      );
      expect(
        (await service.importLicense(utf8.encode(lower))).isActive,
        isFalse,
      );
      expect(store.license, stored);
      expect((await service.importLicense([1, 2, 3])).isActive, isFalse);
      expect(store.license, stored);
    },
  );

  test('storage failure never regenerates installation identity', () async {
    store = MemoryActivationStore()..readError = StateError('unavailable');
    final state = await LicenseService(
      store: store,
      verifier: verifier,
      database: database,
    ).load();
    expect(state.validation.status, LicenseStatus.storageUnavailable);
    expect(store.installationId, isNull);
    expect(database.businessWritesAllowed, isFalse);
  });

  test(
    'installation identity is random-format and stable across loads',
    () async {
      store = MemoryActivationStore();
      final service = LicenseService(
        store: store,
        verifier: verifier,
        database: database,
      );
      final first = await service.load();
      final second = await service.load();
      expect(first.installationId, matches(r'^inst_[A-Za-z0-9_-]{32}$'));
      expect(second.installationId, first.installationId);
    },
  );

  test('activation request export is exact canonical issuer JSON', () {
    final bytes = LicenseService.activationRequestBytesForInstallation(
      _installationA,
    );
    expect(
      utf8.decode(bytes),
      '{"formatVersion":1,"productId":"tailordesk",'
      '"installationId":"$_installationA"}',
    );
    final decoded = ActivationRequest.decode(bytes);
    expect(decoded.formatVersion, activationRequestFormatVersion);
    expect(decoded.productId, tailorDeskProductId);
    expect(decoded.installationId, _installationA);
  });

  test(
    'read-only recovery preserves reads and blocks independent write routes',
    () async {
      database.setBusinessWritesAllowed(true);
      final customerId = await CustomersDao(
        database,
      ).createCustomer(name: 'Existing', phone: '0300');
      database.setBusinessWritesAllowed(false);

      expect(
        (await CustomersDao(database).getById(customerId))!.name,
        'Existing',
      );
      expect(
        () => CustomersDao(
          database,
        ).createCustomer(name: 'Blocked', phone: '0301'),
        throwsA(isA<ActivationRequiredException>()),
      );
      expect(
        () => MeasurementsDao(database).createProfile(
          MeasurementDraft(
            customerId: customerId,
            garmentType: GarmentType.shirt,
            profileName: 'Blocked',
            unit: MeasurementUnit.inches,
            basis: MeasurementBasis.body,
            values: const {
              'length': 30,
              'shoulder': 18,
              'sleeve': 24,
              'chest': 40,
              'waist': 36,
            },
            fitPreference: FitPreference.regular,
          ),
        ),
        throwsA(isA<ActivationRequiredException>()),
      );
      expect(
        () => ShopSettingsRepository(
          database,
        ).save(const ShopDetails(name: 'Blocked Shop')),
        throwsA(isA<ActivationRequiredException>()),
      );
    },
  );

  test(
    'business backup restore does not transfer or overwrite activation',
    () async {
      await database.close();
      final directory = await Directory.systemTemp.createTemp(
        'license_backup_',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/tailor.sqlite');
      database = AppDatabase(NativeDatabase(file));
      await CustomersDao(
        database,
      ).createCustomer(name: 'Backed up', phone: '0300');
      final backupService = BackupService(databasePath: () async => file.path);
      final backup = await backupService.createBackup(database);
      store.license = 'destination-license-state';
      database.setBusinessWritesAllowed(false);

      expect(
        () => backupService.restore(database, backup),
        throwsA(isA<ActivationRequiredException>()),
      );
      database.setBusinessWritesAllowed(true);
      await backupService.restore(database, backup);
      expect(store.license, 'destination-license-state');
    },
  );
}

const _installationA = 'inst_AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
const _installationB = 'inst_BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB';

Future<String> _license(
  SimpleKeyPairData key, {
  String licenseId = 'license-001',
  String productId = tailorDeskProductId,
  DateTime? maintenanceThrough,
  int maximumRelease = currentReleaseSequence,
}) async {
  final payload = LicensePayload(
    formatVersion: licenseFormatVersion,
    keyId: 'test-key',
    licenseId: licenseId,
    productId: productId,
    shopCustomerId: 'customer-001',
    licensedShopName: 'Test Tailors',
    installationId: _installationA,
    issuedAt: DateTime.utc(2026, 10, 12),
    licenseType: 'perpetual',
    maintenanceThrough: maintenanceThrough ?? DateTime.utc(2027, 10, 12),
    maximumReleaseSequence: maximumRelease,
  );
  final payloadBytes = payload.canonicalBytes();
  final signature = await Ed25519().sign(payloadBytes, keyPair: key);
  return SignedLicenseEnvelope(
    formatVersion: licenseFormatVersion,
    keyId: 'test-key',
    payloadBytes: payloadBytes,
    signatureBytes: Uint8List.fromList(signature.bytes),
  ).encode();
}
