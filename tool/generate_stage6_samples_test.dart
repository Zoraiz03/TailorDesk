import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/features/customers/data/customers_dao.dart';
import 'package:tailor/features/documents/order_document_service.dart';
import 'package:tailor/features/karigars/data/karigars_dao.dart';
import 'package:tailor/features/karigars/karigar_models.dart';
import 'package:tailor/features/measurements/data/measurements_dao.dart';
import 'package:tailor/features/measurements/measurement_models.dart';
import 'package:tailor/features/measurements/measurement_templates.dart';
import 'package:tailor/features/orders/data/orders_dao.dart';
import 'package:tailor/features/orders/order_models.dart';
import 'package:tailor/features/settings/shop_settings.dart';

void main() {
  test('generate Stage 6 visual QA PDFs', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final customers = CustomersDao(database);
    final measurements = MeasurementsDao(database);
    final orders = OrdersDao(database);
    final karigars = KarigarsDao(database);
    final customerId = await customers.createCustomer(
      name: 'Muhammad Shahzaib Ahmed Khan - Representative Long Customer Name',
      phone: '0300 1234567',
      address: '42 Main Boulevard, Gulberg, Lahore, Punjab',
    );
    final profileId = await measurements.createProfile(
      MeasurementDraft(
        customerId: customerId,
        garmentType: GarmentType.shirt,
        profileName: 'Formal shirt',
        unit: MeasurementUnit.inches,
        basis: MeasurementBasis.body,
        values: const {
          'length': 31.5,
          'shoulder': 18.25,
          'sleeve': 25.75,
          'collar': 15.5,
          'chest': 41.25,
          'waist': 37.5,
          'cuff': 9.25,
        },
        fitPreference: FitPreference.regular,
        styleInstructions:
            'French placket, rounded cuffs, contrast thread inside collar, and carefully matched checks.',
        notes: 'Measurements were confirmed from the finished sample garment.',
      ),
    );
    final revision = (await measurements.getProfile(profileId))!.latestRevision;
    final simpleId = await orders.createOrder(
      NewOrderDraft(
        submissionKey: 'visual-simple',
        customerId: customerId,
        bookingDate: DateTime(2026, 10, 10),
        deliveryDate: DateTime(2026, 10, 20),
        advancePaisa: 100000,
        notes: 'Please call before delivery.',
        lines: [
          OrderLineDraft(
            measurementRevisionId: revision.id,
            quantity: 2,
            stitchingPricePaisa: 150000,
            clothChargePaisa: 50000,
          ),
          OrderLineDraft(
            measurementRevisionId: revision.id,
            quantity: 1,
            stitchingPricePaisa: 175000,
            styleInstructions: 'Use pearl buttons and reinforce the collar.',
          ),
        ],
      ),
    );
    final simple = (await orders.getOrder(simpleId))!;
    final oneItemSimple = OrderRecord(
      order: simple.order,
      customer: simple.customer,
      items: [simple.items.first],
      payments: simple.payments,
    );
    final firstKarigar = await karigars.createKarigar(name: 'Master Ali');
    final secondKarigar = await karigars.createKarigar(name: 'Bilal Stitching');
    await karigars.assignItem(
      orderItemId: simple.items[0].id,
      karigarId: firstKarigar,
      internalDeadline: DateTime(2026, 10, 18),
      workInstructions: 'Keep all checks aligned across the front and pocket.',
    );
    await karigars.assignItem(
      orderItemId: simple.items[1].id,
      karigarId: secondKarigar,
      internalDeadline: DateTime(2026, 10, 19),
      workInstructions: 'Confirm button spacing before finishing.',
    );
    final firstAssignment =
        (await karigars.watchAssignmentsForItem(simple.items[0].id).first)
            .first;
    final secondAssignment =
        (await karigars.watchAssignmentsForItem(simple.items[1].id).first)
            .first;

    final longId = await orders.createOrder(
      NewOrderDraft(
        submissionKey: 'visual-long',
        customerId: customerId,
        bookingDate: DateTime(2026, 10, 10),
        deliveryDate: DateTime(2026, 11, 10),
        notes: List.filled(
          18,
          'Long order notes must wrap cleanly without clipping or unreadable text.',
        ).join(' '),
        lines: List.generate(
          42,
          (index) => OrderLineDraft(
            measurementRevisionId: revision.id,
            quantity: (index % 3) + 1,
            stitchingPricePaisa: 100000 + (index * 1000),
            additionalChargePaisa: index.isEven ? 5000 : 0,
            additionalChargeDescription: index.isEven
                ? 'Finishing detail ${index + 1}'
                : '',
          ),
        ),
      ),
    );
    final longOrder = (await orders.getOrder(longId))!;

    final regular = ByteData.sublistView(
      await File('assets/fonts/Roboto-Regular.ttf').readAsBytes(),
    );
    final medium = ByteData.sublistView(
      await File('assets/fonts/Roboto-Medium.ttf').readAsBytes(),
    );
    const shop = ShopDetails(
      name: 'Stitch & Style Studio',
      address: 'Main Boulevard, Lahore',
      phone: '042-1234567',
      receiptFooter: 'Thank you for choosing local craftsmanship.',
    );
    final service = OrderDocumentService();
    final output = Directory('output/pdf');
    await output.create(recursive: true);

    Future<void> write(
      String name,
      OrderDocumentKind kind,
      OrderRecord record, [
      AssignmentRecord? assignment,
    ]) async {
      final document = await service.generateWithFonts(
        kind: kind,
        shop: shop,
        order: record,
        assignment: assignment,
        generatedAt: DateTime.utc(2026, 10, 10, 12),
        regularFont: regular,
        mediumFont: medium,
      );
      await File('${output.path}/$name').writeAsBytes(document.bytes);
    }

    await write(
      'stage6-simple-receipt.pdf',
      OrderDocumentKind.customerReceipt,
      simple,
    );
    await write(
      'stage6-combined-page.pdf',
      OrderDocumentKind.combined,
      oneItemSimple,
      firstAssignment,
    );
    await write(
      'stage6-multipage-long-order.pdf',
      OrderDocumentKind.customerReceipt,
      longOrder,
    );
    await write(
      'stage6-second-worker-slip.pdf',
      OrderDocumentKind.karigarSlip,
      simple,
      secondAssignment,
    );
  });
}
