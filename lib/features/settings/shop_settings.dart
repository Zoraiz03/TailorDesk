class ShopDetails {
  const ShopDetails({
    required this.name,
    this.address = '',
    this.phone = '',
    this.receiptFooter = '',
  });

  static const defaults = ShopDetails(name: 'Stitch & Style Studio');

  final String name;
  final String address;
  final String phone;
  final String receiptFooter;
}
