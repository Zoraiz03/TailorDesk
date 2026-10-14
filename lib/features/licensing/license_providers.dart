import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';
import 'activation_store.dart';
import 'license_service.dart';
import 'license_verifier.dart';

final activationStoreProvider = Provider<ActivationStore>((ref) {
  return SecureActivationStore();
});

final licenseVerifierProvider = Provider<LicenseVerifier>((ref) {
  return LicenseVerifier(
    trustedPublicKeys: LicenseVerifier.trustedKeysFromEnvironment(),
  );
});

final licenseServiceProvider = Provider<LicenseService>((ref) {
  return LicenseService(
    store: ref.watch(activationStoreProvider),
    verifier: ref.watch(licenseVerifierProvider),
    database: ref.watch(databaseProvider),
  );
});

class LicenseController extends AsyncNotifier<LicenseAppState> {
  @override
  Future<LicenseAppState> build() => ref.watch(licenseServiceProvider).load();

  Future<LicenseValidationResult> importLicense(List<int> bytes) async {
    final result = await ref.read(licenseServiceProvider).importLicense(bytes);
    if (result.isActive) {
      state = AsyncData(await ref.read(licenseServiceProvider).load());
    }
    return result;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(licenseServiceProvider).load(),
    );
  }
}

final licenseStateProvider =
    AsyncNotifierProvider<LicenseController, LicenseAppState>(
      LicenseController.new,
    );

class ReadOnlySessionController extends Notifier<bool> {
  @override
  bool build() => false;

  void enable() => state = true;
  void disable() => state = false;
}

final readOnlySessionProvider =
    NotifierProvider<ReadOnlySessionController, bool>(
      ReadOnlySessionController.new,
    );
