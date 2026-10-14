import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/features/customers/data/customers_dao.dart';
import 'package:tailor/features/measurements/data/measurements_dao.dart';
import 'package:tailor/features/measurements/measurement_models.dart';
import 'package:tailor/features/measurements/measurement_templates.dart';
import 'package:tailor/features/orders/data/orders_dao.dart';
import 'package:tailor/features/orders/order_models.dart';

void main() {
  late AppDatabase database;
  late CustomersDao customers;
  late MeasurementsDao measurements;
  late OrdersDao orders;
  late int customerId;
  late int revisionId;

  NewOrderDraft draft({
    String submissionKey = 'submit-1',
    List<OrderLineDraft>? lines,
    int advancePaisa = 0,
  }) {
    return NewOrderDraft(
      submissionKey: submissionKey,
      customerId: customerId,
      bookingDate: DateTime(2026, 10, 10),
      deliveryDate: DateTime(2026, 10, 20),
      lines:
          lines ??
          [
            OrderLineDraft(
              measurementRevisionId: revisionId,
              quantity: 2,
              stitchingPricePaisa: 150000,
              clothChargePaisa: 50000,
              additionalChargePaisa: 25000,
              additionalChargeDescription: 'Special buttons',
            ),
          ],
      advancePaisa: advancePaisa,
    );
  }

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    customers = CustomersDao(database);
    measurements = MeasurementsDao(database);
    orders = OrdersDao(database);
    customerId = await customers.createCustomer(
      name: 'Ahmed Khan',
      phone: '03001234567',
    );
    final profileId = await measurements.createProfile(
      MeasurementDraft(
        customerId: customerId,
        garmentType: GarmentType.shirt,
        profileName: 'Everyday',
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
        styleInstructions: 'Single cuff',
      ),
    );
    revisionId = (await measurements.getProfile(profileId))!.latestRevision.id;
  });

  tearDown(() => database.close());

  test(
    'creates multiple lines with quantity and exact integer money',
    () async {
      final orderId = await orders.createOrder(
        draft(
          advancePaisa: 100000,
          lines: [
            OrderLineDraft(
              measurementRevisionId: revisionId,
              quantity: 2,
              stitchingPricePaisa: 150000,
              clothChargePaisa: 50000,
              additionalChargePaisa: 25000,
              additionalChargeDescription: 'Buttons',
            ),
            OrderLineDraft(
              measurementRevisionId: revisionId,
              quantity: 1,
              stitchingPricePaisa: 99999,
            ),
          ],
        ),
      );

      final record = await orders.getOrder(orderId);
      expect(record!.items, hasLength(2));
      expect(record.totalPaisa, 474999);
      expect(record.netPaidPaisa, 100000);
      expect(record.balancePaisa, 374999);
      expect(record.order.orderNumber, 'ORD-20261010-0001');
    },
  );

  test('freezes measurement revision values and instructions', () async {
    final orderId = await orders.createOrder(draft());
    final profileId = (await measurements.getProfile(
      (await database.select(database.measurementProfiles).getSingle()).id,
    ))!.profile.id;
    await measurements.createRevision(
      profileId: profileId,
      draft: MeasurementDraft(
        customerId: customerId,
        garmentType: GarmentType.shirt,
        profileName: 'Everyday',
        unit: MeasurementUnit.inches,
        basis: MeasurementBasis.body,
        values: const {
          'length': 32,
          'shoulder': 19,
          'sleeve': 25,
          'chest': 42,
          'waist': 38,
        },
        fitPreference: FitPreference.slim,
        styleInstructions: 'Double cuff',
      ),
    );

    final item = (await orders.getOrder(orderId))!.items.single;
    expect(item.measurementRevisionId, revisionId);
    expect(item.measurementValuesJson, contains('30.5'));
    expect(item.measurementValuesJson, isNot(contains('32.0')));
    expect(item.styleInstructions, 'Single cuff');
  });

  test('payments, refunds, and excess amounts are enforced', () async {
    final orderId = await orders.createOrder(draft(advancePaisa: 100000));
    await orders.addLedgerEntry(
      orderId: orderId,
      amountPaisa: 50000,
      type: PaymentRecordType.payment,
      method: PaymentMethod.manualBankTransfer,
      date: DateTime(2026, 10, 11),
    );
    await orders.addLedgerEntry(
      orderId: orderId,
      amountPaisa: 25000,
      type: PaymentRecordType.refund,
      method: PaymentMethod.cash,
      date: DateTime(2026, 10, 12),
    );
    expect((await orders.getOrder(orderId))!.netPaidPaisa, 125000);
    await expectLater(
      orders.addLedgerEntry(
        orderId: orderId,
        amountPaisa: 300000,
        type: PaymentRecordType.payment,
        method: PaymentMethod.cash,
        date: DateTime.now(),
      ),
      throwsA(isA<ExcessPaymentException>()),
    );
    await expectLater(
      orders.addLedgerEntry(
        orderId: orderId,
        amountPaisa: 200000,
        type: PaymentRecordType.refund,
        method: PaymentMethod.cash,
        date: DateTime.now(),
      ),
      throwsA(isA<ExcessRefundException>()),
    );
  });

  test('duplicate submission is rejected and creates only one order', () async {
    await orders.createOrder(draft());
    await expectLater(
      orders.createOrder(draft()),
      throwsA(isA<DuplicateOrderSubmissionException>()),
    );
    expect(await database.select(database.orders).get(), hasLength(1));
  });

  test(
    'invalid line rolls back order, earlier items, and payment atomically',
    () async {
      await expectLater(
        orders.createOrder(
          draft(
            advancePaisa: 100,
            lines: [
              OrderLineDraft(
                measurementRevisionId: revisionId,
                quantity: 1,
                stitchingPricePaisa: 1000,
              ),
              const OrderLineDraft(
                measurementRevisionId: 9999,
                quantity: 1,
                stitchingPricePaisa: 1000,
              ),
            ],
          ),
        ),
        throwsStateError,
      );
      expect(await database.select(database.orders).get(), isEmpty);
      expect(await database.select(database.orderItems).get(), isEmpty);
      expect(await database.select(database.payments).get(), isEmpty);
    },
  );

  test(
    'partial delivery derives status and delivered cancellation is blocked',
    () async {
      final orderId = await orders.createOrder(
        draft(
          lines: [
            OrderLineDraft(
              measurementRevisionId: revisionId,
              quantity: 1,
              stitchingPricePaisa: 1000,
            ),
            OrderLineDraft(
              measurementRevisionId: revisionId,
              quantity: 1,
              stitchingPricePaisa: 1000,
            ),
          ],
        ),
      );
      final items = (await orders.getOrder(orderId))!.items;
      await orders.updateItemStatus(items.first.id, OrderItemStatus.delivered);
      expect(
        (await orders.getOrder(orderId))!.progress,
        OrderProgress.partiallyDelivered,
      );
      await orders.updateItemStatus(items.last.id, OrderItemStatus.delivered);
      expect(
        (await orders.getOrder(orderId))!.progress,
        OrderProgress.delivered,
      );
      await expectLater(
        orders.cancelOrder(orderId),
        throwsA(isA<DeliveredOrderCancellationException>()),
      );
    },
  );

  test(
    'cancellation requires refund then keeps history with zero total',
    () async {
      final orderId = await orders.createOrder(draft(advancePaisa: 50000));
      await expectLater(
        orders.cancelOrder(orderId),
        throwsA(isA<RefundRequiredBeforeCancellationException>()),
      );
      await orders.addLedgerEntry(
        orderId: orderId,
        amountPaisa: 50000,
        type: PaymentRecordType.refund,
        method: PaymentMethod.cash,
        date: DateTime.now(),
      );
      await orders.cancelOrder(orderId);
      final record = await orders.getOrder(orderId);
      expect(record!.progress, OrderProgress.cancelled);
      expect(record.totalPaisa, 0);
      expect(record.items, isNotEmpty);
      expect(record.payments, hasLength(2));
    },
  );

  test('v3 migration preserves customer and measurement revision', () async {
    await database.close();
    final directory = await Directory.systemTemp.createTemp(
      'tailor_v3_migration_',
    );
    addTearDown(() => directory.delete(recursive: true));
    final migrated = AppDatabase(
      NativeDatabase(
        File('${directory.path}/tailor.sqlite'),
        setup: (raw) {
          raw.execute(
            'CREATE TABLE app_settings (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, key TEXT NOT NULL UNIQUE CHECK (length(key) BETWEEN 1 AND 100), value TEXT NOT NULL DEFAULT \'\')',
          );
          raw.execute(
            'CREATE TABLE customers (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL CHECK (length(name) BETWEEN 1 AND 100), phone TEXT NOT NULL CHECK (length(phone) BETWEEN 1 AND 30), address TEXT NOT NULL DEFAULT \'\', notes TEXT NOT NULL DEFAULT \'\', created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL)',
          );
          raw.execute(
            'CREATE TABLE measurement_profiles (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, customer_id INTEGER NOT NULL REFERENCES customers(id) ON DELETE RESTRICT, garment_type TEXT NOT NULL CHECK (length(garment_type) BETWEEN 1 AND 50), profile_name TEXT NOT NULL CHECK (length(profile_name) BETWEEN 1 AND 100), created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL)',
          );
          raw.execute(
            'CREATE TABLE measurement_revisions (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, profile_id INTEGER NOT NULL REFERENCES measurement_profiles(id) ON DELETE RESTRICT, revision_number INTEGER NOT NULL, garment_type TEXT NOT NULL CHECK (length(garment_type) BETWEEN 1 AND 50), profile_name TEXT NOT NULL CHECK (length(profile_name) BETWEEN 1 AND 100), unit TEXT NOT NULL CHECK (length(unit) BETWEEN 1 AND 20), measurement_basis TEXT NOT NULL CHECK (length(measurement_basis) BETWEEN 1 AND 30), values_json TEXT NOT NULL, fit_preference TEXT NOT NULL CHECK (length(fit_preference) BETWEEN 1 AND 20), style_instructions TEXT NOT NULL DEFAULT \'\', notes TEXT NOT NULL DEFAULT \'\', created_at INTEGER NOT NULL, UNIQUE(profile_id, revision_number))',
          );
          raw.execute(
            "INSERT INTO customers VALUES (1, 'Existing', '0300', '', '', 1700000000, 1700000000)",
          );
          raw.execute(
            "INSERT INTO measurement_profiles VALUES (1, 1, 'shirt', 'Legacy', 1700000000, 1700000000)",
          );
          raw.execute(
            "INSERT INTO measurement_revisions VALUES (1, 1, 1, 'shirt', 'Legacy', 'inches', 'body', '{\"chest\":40}', 'regular', '', '', 1700000000)",
          );
          raw.execute('PRAGMA user_version = 3');
        },
      ),
    );
    addTearDown(migrated.close);

    expect(
      (await migrated.select(migrated.customers).getSingle()).name,
      'Existing',
    );
    expect(
      (await migrated.select(migrated.measurementRevisions).getSingle())
          .profileName,
      'Legacy',
    );
    expect(await migrated.select(migrated.orders).get(), isEmpty);
    expect(
      await migrated
          .customSelect('PRAGMA user_version')
          .getSingle()
          .then((row) => row.read<int>('user_version')),
      6,
    );
  });
}
