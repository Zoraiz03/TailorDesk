import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/core/localization/presentation_preferences.dart';
import 'package:tailor/features/customers/data/customers_dao.dart';
import 'package:tailor/features/documents/order_document_service.dart';
import 'package:tailor/features/karigars/data/karigars_dao.dart';
import 'package:tailor/features/measurements/data/measurements_dao.dart';
import 'package:tailor/features/measurements/measurement_models.dart';
import 'package:tailor/features/measurements/measurement_templates.dart';
import 'package:tailor/features/orders/data/orders_dao.dart';
import 'package:tailor/features/orders/order_models.dart';
import 'package:tailor/features/settings/shop_settings.dart';

void main() {
  test('generate inspected localization sample PDFs', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final customers = CustomersDao(database);
    final measurements = MeasurementsDao(database);
    final orders = OrdersDao(database);
    final karigars = KarigarsDao(database);

    final customerId = await customers.createCustomer(
      name: 'احمد خان / Ahmed Khan',
      phone: '0300 1234567',
      address: 'گلبرگ، لاہور / Gulberg, Lahore',
    );
    final profileId = await measurements.createProfile(
      MeasurementDraft(
        customerId: customerId,
        garmentType: GarmentType.shirt,
        profileName: 'عید / Eid',
        unit: MeasurementUnit.inches,
        basis: MeasurementBasis.body,
        values: const {
          'length': 30.5,
          'shoulder': 18.25,
          'sleeve': 24.75,
          'collar': 15.5,
          'chest': 40.5,
          'waist': 36.25,
          'cuff': 9.5,
        },
        fitPreference: FitPreference.regular,
        styleInstructions:
            'سفید بٹن، باریک سلائی / White buttons, fine stitching',
        notes: 'ناپ دوبارہ چیک کریں / Recheck measurements',
      ),
    );
    final revision = (await measurements.getProfile(profileId))!.latestRevision;
    final orderId = await orders.createOrder(
      NewOrderDraft(
        submissionKey: 'localization-sample',
        customerId: customerId,
        bookingDate: DateTime(2026, 10, 14),
        deliveryDate: DateTime(2026, 10, 28),
        advancePaisa: 500000,
        notes: 'گاہک کو شام میں فون کریں / Call the customer in the evening.',
        lines: List.generate(
          9,
          (index) => OrderLineDraft(
            measurementRevisionId: revision.id,
            quantity: index.isEven ? 2 : 1,
            stitchingPricePaisa: 225000 + (index * 1000),
            clothChargePaisa: index * 2500,
            additionalChargePaisa: index == 0 ? 50000 : 0,
            additionalChargeDescription: index == 0
                ? 'خاص بٹن / Special buttons'
                : '',
          ),
        ),
      ),
    );
    final order = (await orders.getOrder(orderId))!;
    final karigarId = await karigars.createKarigar(
      name: 'استاد علی / Ustad Ali',
    );
    await karigars.assignItem(
      orderItemId: order.items.first.id,
      karigarId: karigarId,
      internalDeadline: DateTime(2026, 10, 25),
      workInstructions:
          'کالر احتیاط سے بنائیں / Take special care with the collar.',
    );
    final assignment =
        (await karigars.watchAssignmentsForItem(order.items.first.id).first)
            .first;

    ByteData font(String path) =>
        ByteData.sublistView(File(path).readAsBytesSync());
    final regular = font('assets/fonts/Roboto-Regular.ttf');
    final medium = font('assets/fonts/Roboto-Medium.ttf');
    final urduRegular = font('assets/fonts/NotoNaskhArabic-Regular.ttf');
    final urduMedium = font('assets/fonts/NotoNaskhArabic-Medium.ttf');
    const shop = ShopDetails(
      name: 'سوئی دھاگہ ٹیلرز / Sui Dhaga Tailors',
      phone: '042 1234567',
      address: 'مین بازار، لاہور / Main Bazaar, Lahore',
      receiptFooter: 'شکریہ / Thank you',
    );
    final service = OrderDocumentService();
    final output = Directory('output/pdf')..createSync(recursive: true);

    for (final entry in <(String, DocumentLanguage, OrderDocumentKind)>[
      (
        'tailordesk-sample-english.pdf',
        DocumentLanguage.english,
        OrderDocumentKind.customerReceipt,
      ),
      (
        'tailordesk-sample-urdu.pdf',
        DocumentLanguage.urdu,
        OrderDocumentKind.customerReceipt,
      ),
      (
        'tailordesk-sample-bilingual.pdf',
        DocumentLanguage.bilingual,
        OrderDocumentKind.combined,
      ),
    ]) {
      final document = await service.generateWithFonts(
        kind: entry.$3,
        shop: shop,
        order: order,
        assignment: entry.$3 == OrderDocumentKind.combined ? assignment : null,
        generatedAt: DateTime(2026, 10, 14, 14, 30),
        regularFont: regular,
        mediumFont: medium,
        urduRegularFont: urduRegular,
        urduMediumFont: urduMedium,
        documentLanguage: entry.$2,
      );
      File('${output.path}/${entry.$1}').writeAsBytesSync(document.bytes);
    }
  });
}
