import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/features/customers/data/customers_dao.dart';
import 'package:tailor/features/karigars/data/karigars_dao.dart';
import 'package:tailor/features/karigars/karigar_models.dart';
import 'package:tailor/features/measurements/data/measurements_dao.dart';
import 'package:tailor/features/measurements/measurement_models.dart';
import 'package:tailor/features/measurements/measurement_templates.dart';
import 'package:tailor/features/orders/data/orders_dao.dart';
import 'package:tailor/features/orders/order_models.dart';

void main() {
  test(
    'complete offline order workflow preserves history and exact totals',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final customers = CustomersDao(database);
      final measurements = MeasurementsDao(database);
      final orders = OrdersDao(database);
      final karigars = KarigarsDao(database);

      final customerId = await customers.createCustomer(
        name: 'Acceptance Customer',
        phone: '03001234567',
      );
      final profileId = await measurements.createProfile(
        MeasurementDraft(
          customerId: customerId,
          garmentType: GarmentType.shirt,
          profileName: 'Client review',
          unit: MeasurementUnit.inches,
          basis: MeasurementBasis.body,
          values: const {
            'length': 30,
            'shoulder': 18,
            'sleeve': 24,
            'chest': 40,
            'waist': 36,
          },
          fitPreference: FitPreference.regular,
          styleInstructions: 'Single cuff',
        ),
      );
      final bookedRevision = (await measurements.getProfile(
        profileId,
      ))!.latestRevision;

      final orderId = await orders.createOrder(
        NewOrderDraft(
          submissionKey: 'offline-acceptance-order',
          customerId: customerId,
          bookingDate: DateTime(2026, 10, 11),
          deliveryDate: DateTime(2026, 10, 20),
          lines: [
            OrderLineDraft(
              measurementRevisionId: bookedRevision.id,
              quantity: 2,
              stitchingPricePaisa: 100000,
              additionalChargePaisa: 25000,
              additionalChargeDescription: 'Buttons',
            ),
            OrderLineDraft(
              measurementRevisionId: bookedRevision.id,
              quantity: 1,
              stitchingPricePaisa: 150000,
              clothChargePaisa: 75000,
            ),
          ],
          advancePaisa: 100000,
        ),
      );

      await measurements.createRevision(
        profileId: profileId,
        draft: MeasurementDraft(
          customerId: customerId,
          garmentType: GarmentType.shirt,
          profileName: 'Client review',
          unit: MeasurementUnit.inches,
          basis: MeasurementBasis.body,
          values: const {
            'length': 32,
            'shoulder': 19,
            'sleeve': 25,
            'chest': 44,
            'waist': 40,
          },
          fitPreference: FitPreference.loose,
          styleInstructions: 'Double cuff',
        ),
      );

      var order = (await orders.getOrder(orderId))!;
      expect(order.totalPaisa, 450000);
      expect(order.netPaidPaisa, 100000);
      expect(order.balancePaisa, 350000);
      expect(order.items.first.measurementValuesJson, contains('40.0'));
      expect(order.items.first.measurementValuesJson, isNot(contains('44.0')));
      expect(order.items.first.styleInstructions, 'Single cuff');

      final firstKarigar = await karigars.createKarigar(name: 'Ali');
      final secondKarigar = await karigars.createKarigar(name: 'Bilal');
      await karigars.assignItem(
        orderItemId: order.items.first.id,
        karigarId: firstKarigar,
      );
      await karigars.assignItem(
        orderItemId: order.items.last.id,
        karigarId: secondKarigar,
      );
      await karigars.assignItem(
        orderItemId: order.items.first.id,
        karigarId: secondKarigar,
        reassignReason: 'Balance workshop load',
      );

      final reassignmentHistory = await karigars
          .watchAssignmentsForItem(order.items.first.id)
          .first;
      expect(reassignmentHistory, hasLength(2));
      expect(
        reassignmentHistory
            .where((entry) => !entry.isActive)
            .single
            .assignment
            .reassignReason,
        'Balance workshop load',
      );

      for (final item in order.items) {
        final assignment = (await karigars.getActiveAssignment(item.id))!;
        await karigars.startWork(assignment.id);
        await karigars.completeWork(assignment.id);
      }
      expect((await orders.getOrder(orderId))!.progress, OrderProgress.ready);

      await orders.addLedgerEntry(
        orderId: orderId,
        amountPaisa: 350000,
        type: PaymentRecordType.payment,
        method: PaymentMethod.cash,
        date: DateTime(2026, 10, 20),
      );
      order = (await orders.getOrder(orderId))!;
      expect(order.netPaidPaisa, 450000);
      expect(order.balancePaisa, 0);

      await orders.updateItemStatus(
        order.items.first.id,
        OrderItemStatus.delivered,
      );
      expect(
        (await orders.getOrder(orderId))!.progress,
        OrderProgress.partiallyDelivered,
      );
      await orders.updateItemStatus(
        order.items.last.id,
        OrderItemStatus.delivered,
      );
      expect(
        (await orders.getOrder(orderId))!.progress,
        OrderProgress.delivered,
      );

      final cancellableOrderId = await orders.createOrder(
        NewOrderDraft(
          submissionKey: 'offline-acceptance-cancellation',
          customerId: customerId,
          bookingDate: DateTime(2026, 10, 11),
          deliveryDate: DateTime(2026, 10, 22),
          lines: [
            OrderLineDraft(
              measurementRevisionId: bookedRevision.id,
              quantity: 1,
              stitchingPricePaisa: 50000,
            ),
          ],
        ),
      );
      final cancellableItem = (await orders.getOrder(
        cancellableOrderId,
      ))!.items.single;
      await karigars.assignItem(
        orderItemId: cancellableItem.id,
        karigarId: firstKarigar,
      );
      await orders.cancelOrder(cancellableOrderId);
      expect(await karigars.getActiveAssignment(cancellableItem.id), isNull);
      expect(
        (await karigars.watchAssignmentsForItem(cancellableItem.id).first)
            .single
            .status,
        AssignmentStatus.cancelled,
      );

      final dashboard = await orders.watchDashboard().first;
      expect(dashboard.activeOrders, 0);
      expect(dashboard.outstandingPaisa, 0);
      expect(await customers.watchAll().first, hasLength(1));
    },
  );
}
