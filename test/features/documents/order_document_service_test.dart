import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
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
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;
  late OrdersDao orders;
  late KarigarsDao karigars;
  late OrderRecord order;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    orders = OrdersDao(database);
    karigars = KarigarsDao(database);
    final customerId = await CustomersDao(
      database,
    ).createCustomer(name: 'A Customer With A Long Name', phone: '03001234567');
    final measurements = MeasurementsDao(database);
    final profileId = await measurements.createProfile(
      MeasurementDraft(
        customerId: customerId,
        garmentType: GarmentType.shirt,
        profileName: 'Frozen profile',
        unit: MeasurementUnit.inches,
        basis: MeasurementBasis.body,
        values: const {
          'length': 30.5,
          'shoulder': 18.25,
          'sleeve': 24.75,
          'chest': 40.5,
          'waist': 36.25,
        },
        fitPreference: FitPreference.regular,
        styleInstructions: 'Single cuff and matching thread',
      ),
    );
    final revision = (await measurements.getProfile(profileId))!.latestRevision;
    final orderId = await orders.createOrder(
      NewOrderDraft(
        submissionKey: 'documents-test',
        customerId: customerId,
        bookingDate: DateTime(2026, 10, 10),
        deliveryDate: DateTime(2026, 10, 20),
        advancePaisa: 100000,
        lines: [
          OrderLineDraft(
            measurementRevisionId: revision.id,
            quantity: 2,
            stitchingPricePaisa: 150000,
            clothChargePaisa: 50000,
            additionalChargePaisa: 25000,
            additionalChargeDescription: 'Buttons',
          ),
        ],
      ),
    );
    order = (await orders.getOrder(orderId))!;
    final karigarId = await karigars.createKarigar(name: 'Master Ali');
    await karigars.assignItem(
      orderItemId: order.items.single.id,
      karigarId: karigarId,
      internalDeadline: DateTime(2026, 10, 18),
      workInstructions: 'Keep the checks aligned',
    );
  });

  tearDown(() => database.close());

  Future<GeneratedOrderDocument> generate(
    OrderDocumentKind kind, {
    bool withAssignment = false,
  }) async {
    final regular = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final medium = await rootBundle.load('assets/fonts/Roboto-Medium.ttf');
    final history = await karigars
        .watchAssignmentsForItem(order.items.single.id)
        .first;
    return OrderDocumentService().generateWithFonts(
      kind: kind,
      shop: const ShopDetails(
        name: 'Test Tailors',
        phone: '042-1234567',
        receiptFooter: 'Thank you.',
      ),
      order: order,
      assignment: withAssignment ? history.first : null,
      generatedAt: DateTime.utc(2026, 10, 10, 12),
      regularFont: regular,
      mediumFont: medium,
    );
  }

  test('receipt uses the order calculation totals', () async {
    final document = await generate(OrderDocumentKind.customerReceipt);
    expect(document.bytes.take(4), [0x25, 0x50, 0x44, 0x46]);
    expect(document.auditText, contains('Order total PKR 3,750'));
    expect(document.auditText, contains('Net paid PKR 1,000'));
    expect(document.auditText, contains('Balance PKR 2,750'));
    expect(document.auditText, contains('ORDER RECEIPT'));
    expect(document.auditText, isNot(contains('tax invoice')));
  });

  test(
    'work slip contains frozen measurements and excludes finances',
    () async {
      final document = await generate(
        OrderDocumentKind.karigarSlip,
        withAssignment: true,
      );
      expect(document.auditText, contains('KARIGAR WORK SLIP'));
      expect(document.auditText, contains('Chest 40.5 in'));
      expect(document.auditText, contains('Keep the checks aligned'));
      expect(document.auditText, isNot(contains('Order total')));
      expect(document.auditText, isNot(contains('Balance')));
      expect(document.auditText, isNot(contains('PKR')));
    },
  );

  test('combined document contains both portions in one PDF', () async {
    final document = await generate(
      OrderDocumentKind.combined,
      withAssignment: true,
    );
    expect(document.auditText, contains('ORDER RECEIPT'));
    expect(document.auditText, contains('KARIGAR WORK SLIP'));
    expect(document.fileName, endsWith('-combined.pdf'));
  });

  test(
    'cancelled garment is labelled and excluded from receipt total',
    () async {
      await orders.updateItemStatus(
        order.items.single.id,
        OrderItemStatus.cancelled,
      );
      order = (await orders.getOrder(order.order.id))!;
      final document = await generate(OrderDocumentKind.customerReceipt);
      expect(document.auditText, contains('CANCELLED EXCLUDED'));
      expect(document.auditText, contains('Order total PKR 0'));
    },
  );
}
