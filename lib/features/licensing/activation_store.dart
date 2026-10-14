import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class ActivationStore {
  Future<String?> readInstallationId();
  Future<void> writeInstallationId(String value);
  Future<String?> readLicense();
  Future<void> writeLicense(String value);
}

class SecureActivationStore implements ActivationStore {
  SecureActivationStore({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(storageNamespace: 'tailordesk_activation'),
          );

  static const _installationKey = 'installation_id_v1';
  static const _licenseKey = 'signed_license_v1';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readInstallationId() => _storage.read(key: _installationKey);

  @override
  Future<void> writeInstallationId(String value) =>
      _storage.write(key: _installationKey, value: value);

  @override
  Future<String?> readLicense() => _storage.read(key: _licenseKey);

  @override
  Future<void> writeLicense(String value) =>
      _storage.write(key: _licenseKey, value: value);
}

class MemoryActivationStore implements ActivationStore {
  MemoryActivationStore({this.installationId, this.license});

  String? installationId;
  String? license;
  Object? readError;
  Object? writeError;

  void _checkRead() {
    if (readError != null) throw readError!;
  }

  void _checkWrite() {
    if (writeError != null) throw writeError!;
  }

  @override
  Future<String?> readInstallationId() async {
    _checkRead();
    return installationId;
  }

  @override
  Future<void> writeInstallationId(String value) async {
    _checkWrite();
    installationId = value;
  }

  @override
  Future<String?> readLicense() async {
    _checkRead();
    return license;
  }

  @override
  Future<void> writeLicense(String value) async {
    _checkWrite();
    license = value;
  }
}
