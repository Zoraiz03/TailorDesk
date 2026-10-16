import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import 'shop_settings.dart';

class ShopSettingsRepository {
  ShopSettingsRepository(this.database);

  final AppDatabase database;

  static const shopNameKey = 'shop_name';
  static const shopAddressKey = 'shop_address';
  static const shopPhoneKey = 'shop_phone';
  static const receiptFooterKey = 'receipt_footer';
  static const defaultUnitKey = 'default_measurement_unit';
  static const setupCompletedKey = 'setup_completed';
  static const setupStepKey = 'setup_step';

  Stream<ShopDetails> watch() =>
      database.select(database.appSettings).watch().map(_fromRows);

  Future<ShopDetails> get() async =>
      _fromRows(await database.select(database.appSettings).get());

  ShopDetails _fromRows(List<AppSetting> rows) {
    final values = {for (final row in rows) row.key: row.value};
    return ShopDetails(
      name: (values[shopNameKey] ?? '').trim().isEmpty
          ? ShopDetails.defaults.name
          : values[shopNameKey]!.trim(),
      address: (values[shopAddressKey] ?? '').trim(),
      phone: (values[shopPhoneKey] ?? '').trim(),
      receiptFooter: (values[receiptFooterKey] ?? '').trim(),
      defaultMeasurementUnit: values[defaultUnitKey] == 'centimetres'
          ? 'centimetres'
          : 'inches',
    );
  }

  Stream<ShopSetupState> watchSetup() =>
      database.select(database.appSettings).watch().map((rows) {
        final values = {for (final row in rows) row.key: row.value};
        return ShopSetupState(
          completed: values[setupCompletedKey] == 'true',
          step: int.tryParse(values[setupStepKey] ?? '') ?? 0,
        );
      });

  Future<void> save(ShopDetails details) async {
    if (details.name.trim().isEmpty) {
      throw ArgumentError('Shop name is required');
    }
    await database.transaction(() async {
      await _put(shopNameKey, details.name.trim());
      await _put(shopAddressKey, details.address.trim());
      await _put(shopPhoneKey, details.phone.trim());
      await _put(receiptFooterKey, details.receiptFooter.trim());
      await _put(defaultUnitKey, details.defaultMeasurementUnit);
    });
  }

  Future<void> saveSetupProgress(ShopDetails details, int step) async {
    await save(details);
    await _put(setupStepKey, '$step');
  }

  Future<void> completeSetup(ShopDetails details) async {
    await database.transaction(() async {
      await save(details);
      await _put(setupCompletedKey, 'true');
      await _put(setupStepKey, '0');
    });
  }

  Future<void> _put(String key, String value) {
    return database
        .into(database.appSettings)
        .insert(
          AppSettingsCompanion.insert(key: key, value: Value(value)),
          mode: InsertMode.insertOrReplace,
        );
  }
}

final shopSettingsRepositoryProvider = Provider<ShopSettingsRepository>((ref) {
  return ShopSettingsRepository(ref.watch(databaseProvider));
});

final shopDetailsProvider = StreamProvider<ShopDetails>((ref) {
  return ref.watch(shopSettingsRepositoryProvider).watch();
});

final shopSetupProvider = StreamProvider<ShopSetupState>((ref) {
  return ref.watch(shopSettingsRepositoryProvider).watchSetup();
});
