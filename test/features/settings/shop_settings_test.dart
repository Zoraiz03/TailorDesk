import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/features/settings/shop_settings.dart';
import 'package:tailor/features/settings/shop_settings_providers.dart';

void main() {
  test('shop details persist in AppSettings', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = ShopSettingsRepository(database);

    expect((await repository.get()).name, ShopDetails.defaults.name);
    await repository.save(
      const ShopDetails(
        name: 'Needle & Thread',
        address: 'Lahore',
        phone: '042-1234567',
        receiptFooter: 'Thank you.',
      ),
    );

    final saved = await repository.get();
    expect(saved.name, 'Needle & Thread');
    expect(saved.address, 'Lahore');
    expect(saved.phone, '042-1234567');
    expect(saved.receiptFooter, 'Thank you.');
  });
}
