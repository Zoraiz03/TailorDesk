class ShopDetails {
  const ShopDetails({
    required this.name,
    this.address = '',
    this.phone = '',
    this.receiptFooter = '',
    this.defaultMeasurementUnit = 'inches',
  });

  static const defaults = ShopDetails(name: 'Stitch & Style Studio');

  final String name;
  final String address;
  final String phone;
  final String receiptFooter;
  final String defaultMeasurementUnit;
}

class ShopSetupState {
  const ShopSetupState({required this.completed, required this.step});

  final bool completed;
  final int step;
}
