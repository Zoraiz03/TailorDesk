import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../order_models.dart';

part 'orders_dao.g.dart';

@DriftAccessor(
  tables: [
    Orders,
    OrderItems,
    Payments,
    Customers,
    MeasurementProfiles,
    MeasurementRevisions,
    KarigarAssignments,
  ],
)
class OrdersDao extends DatabaseAccessor<AppDatabase> with _$OrdersDaoMixin {
  OrdersDao(super.attachedDatabase);

  Future<int> createOrder(NewOrderDraft draft) async {
    draft.validate();
    return transaction(() async {
      final duplicate =
          await (select(orders)
                ..where((row) => row.submissionKey.equals(draft.submissionKey))
                ..limit(1))
              .getSingleOrNull();
      if (duplicate != null) throw const DuplicateOrderSubmissionException();

      final customer = await (select(
        customers,
      )..where((row) => row.id.equals(draft.customerId))).getSingleOrNull();
      if (customer == null) throw StateError('Customer not found');

      final now = DateTime.now();
      final temporaryNumber = 'PENDING-${draft.submissionKey}';
      final orderId = await into(orders).insert(
        OrdersCompanion.insert(
          orderNumber: temporaryNumber,
          submissionKey: draft.submissionKey,
          customerId: draft.customerId,
          bookingDate: draft.bookingDate,
          deliveryDate: draft.deliveryDate,
          notes: Value(draft.notes.trim()),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      final orderNumber =
          'ORD-${draft.bookingDate.year.toString().padLeft(4, '0')}'
          '${draft.bookingDate.month.toString().padLeft(2, '0')}'
          '${draft.bookingDate.day.toString().padLeft(2, '0')}-'
          '${orderId.toString().padLeft(4, '0')}';
      await (update(orders)..where((row) => row.id.equals(orderId))).write(
        OrdersCompanion(orderNumber: Value(orderNumber)),
      );

      for (final line in draft.lines) {
        final revisionQuery = select(measurementRevisions).join([
          innerJoin(
            measurementProfiles,
            measurementProfiles.id.equalsExp(measurementRevisions.profileId),
          ),
        ])..where(measurementRevisions.id.equals(line.measurementRevisionId));
        final revisionRow = await revisionQuery.getSingleOrNull();
        if (revisionRow == null) {
          throw StateError('Measurement revision not found');
        }
        final revision = revisionRow.readTable(measurementRevisions);
        final profile = revisionRow.readTable(measurementProfiles);
        if (profile.customerId != draft.customerId) {
          throw ArgumentError('Measurements belong to another customer');
        }
        await into(orderItems).insert(
          OrderItemsCompanion.insert(
            orderId: orderId,
            measurementRevisionId: revision.id,
            garmentType: revision.garmentType,
            garmentLabelEnglish: Value(revision.garmentLabelEnglish),
            garmentLabelUrdu: Value(revision.garmentLabelUrdu),
            quantity: line.quantity,
            measurementProfileName: revision.profileName,
            measurementUnit: revision.unit,
            measurementBasis: revision.measurementBasis,
            measurementValuesJson: revision.valuesJson,
            measurementFieldDefinitionsJson: Value(
              revision.fieldDefinitionsJson,
            ),
            fitPreference: revision.fitPreference,
            measurementNotes: Value(revision.notes),
            styleInstructions: Value(
              line.styleInstructions.trim().isEmpty
                  ? revision.styleInstructions
                  : line.styleInstructions.trim(),
            ),
            stitchingPricePaisa: line.stitchingPricePaisa,
            clothChargePaisa: Value(line.clothChargePaisa),
            additionalChargePaisa: Value(line.additionalChargePaisa),
            additionalChargeDescription: Value(
              line.additionalChargeDescription.trim(),
            ),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
      }
      if (draft.advancePaisa > 0) {
        await into(payments).insert(
          PaymentsCompanion.insert(
            orderId: orderId,
            amountPaisa: draft.advancePaisa,
            paymentDate: draft.bookingDate,
            method: draft.advanceMethod.storageKey,
            recordType: PaymentRecordType.payment.storageKey,
            notes: Value(draft.advanceNotes.trim()),
            createdAt: Value(now),
          ),
        );
      }
      return orderId;
    });
  }

  Stream<List<OrderRecord>> watchAll() => _watchRecords();

  Stream<List<OrderRecord>> watchForCustomer(int customerId) =>
      _watchRecords(customerId: customerId);

  Stream<List<OrderRecord>> _watchRecords({int? customerId}) {
    return customSelect(
      'SELECT 1 AS change_token',
      readsFrom: {orders, customers, orderItems, payments},
    ).watchSingle().asyncMap((_) => _getRecords(customerId: customerId));
  }

  Future<List<OrderRecord>> getAllOrders({int? customerId}) =>
      _getRecords(customerId: customerId);

  Future<List<OrderRecord>> _getRecords({int? customerId}) async {
    final query = select(
      orders,
    ).join([innerJoin(customers, customers.id.equalsExp(orders.customerId))]);
    if (customerId != null) query.where(orders.customerId.equals(customerId));
    query.orderBy([OrderingTerm.desc(orders.createdAt)]);
    final rows = await query.get();
    final result = <OrderRecord>[];
    for (final row in rows) {
      result.add(
        await _record(row.readTable(orders), row.readTable(customers)),
      );
    }
    return result;
  }

  Stream<OrderRecord?> watchOrder(int orderId) {
    return customSelect(
      'SELECT ? AS order_id',
      variables: [Variable.withInt(orderId)],
      readsFrom: {orders, customers, orderItems, payments},
    ).watchSingle().asyncMap((_) => getOrder(orderId));
  }

  Future<OrderRecord?> getOrder(int orderId) async {
    final row = await (select(orders).join([
      innerJoin(customers, customers.id.equalsExp(orders.customerId)),
    ])..where(orders.id.equals(orderId))).getSingleOrNull();
    if (row == null) return null;
    return _record(row.readTable(orders), row.readTable(customers));
  }

  Future<OrderRecord> _record(Order order, Customer customer) async {
    final items =
        await (select(orderItems)
              ..where((row) => row.orderId.equals(order.id))
              ..orderBy([(row) => OrderingTerm.asc(row.id)]))
            .get();
    final ledger =
        await (select(payments)
              ..where((row) => row.orderId.equals(order.id))
              ..orderBy([(row) => OrderingTerm.desc(row.paymentDate)]))
            .get();
    return OrderRecord(
      order: order,
      customer: customer,
      items: items,
      payments: ledger,
    );
  }

  Future<int> addLedgerEntry({
    required int orderId,
    required int amountPaisa,
    required PaymentRecordType type,
    required PaymentMethod method,
    required DateTime date,
    String notes = '',
  }) {
    if (amountPaisa <= 0) throw ArgumentError('Amount must be positive');
    return transaction(() async {
      final record = await getOrder(orderId);
      if (record == null) throw StateError('Order not found');
      if (type == PaymentRecordType.payment &&
          amountPaisa > record.balancePaisa) {
        throw const ExcessPaymentException();
      }
      if (type == PaymentRecordType.refund &&
          amountPaisa > record.netPaidPaisa) {
        throw const ExcessRefundException();
      }
      return into(payments).insert(
        PaymentsCompanion.insert(
          orderId: orderId,
          amountPaisa: amountPaisa,
          paymentDate: date,
          method: method.storageKey,
          recordType: type.storageKey,
          notes: Value(notes.trim()),
        ),
      );
    });
  }

  Future<void> updateItemStatus(int itemId, OrderItemStatus status) async {
    await (update(orderItems)..where((row) => row.id.equals(itemId))).write(
      OrderItemsCompanion(
        status: Value(status.storageKey),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateSchedule({
    required int orderId,
    required DateTime deliveryDate,
    required String notes,
  }) async {
    final existing = await (select(
      orders,
    )..where((row) => row.id.equals(orderId))).getSingle();
    if (deliveryDate.isBefore(
      DateTime(
        existing.bookingDate.year,
        existing.bookingDate.month,
        existing.bookingDate.day,
      ),
    )) {
      throw ArgumentError('Delivery date cannot be before booking date');
    }
    await (update(orders)..where((row) => row.id.equals(orderId))).write(
      OrdersCompanion(
        deliveryDate: Value(deliveryDate),
        notes: Value(notes.trim()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> cancelOrder(int orderId) {
    return transaction(() async {
      final record = await getOrder(orderId);
      if (record == null) throw StateError('Order not found');
      if (record.progress == OrderProgress.delivered) {
        throw const DeliveredOrderCancellationException();
      }
      if (record.netPaidPaisa > 0) {
        throw RefundRequiredBeforeCancellationException(record.netPaidPaisa);
      }
      final now = DateTime.now();
      await (update(orders)..where((row) => row.id.equals(orderId))).write(
        OrdersCompanion(cancelledAt: Value(now), updatedAt: Value(now)),
      );
      // Cancel order items and close any active karigar assignments in one tx.
      final activeItemIds = record.items
          .where(
            (item) => item.status != 'cancelled' && item.status != 'delivered',
          )
          .map((item) => item.id)
          .toList();
      await (update(
        orderItems,
      )..where((row) => row.orderId.equals(orderId))).write(
        OrderItemsCompanion(
          status: Value(OrderItemStatus.cancelled.storageKey),
          updatedAt: Value(now),
        ),
      );
      // Close active karigar assignments for each affected item.
      if (activeItemIds.isNotEmpty) {
        await (update(karigarAssignments)..where(
              (row) =>
                  row.orderItemId.isIn(activeItemIds) &
                  row.status.isIn(['assigned', 'in_progress']),
            ))
            .write(
              KarigarAssignmentsCompanion(
                status: const Value('cancelled'),
                reassignReason: const Value('Order cancelled'),
                updatedAt: Value(now),
              ),
            );
      }
    });
  }

  Stream<DashboardMetrics> watchDashboard() {
    return customSelect(
      'SELECT 1 AS change_token',
      readsFrom: {orders, customers, orderItems, payments, karigarAssignments},
    ).watchSingle().asyncMap((_) async {
      final records = await _getRecords();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final active = records
          .where(
            (record) =>
                record.progress != OrderProgress.cancelled &&
                record.progress != OrderProgress.delivered,
          )
          .toList();
      bool sameDay(DateTime value) =>
          value.year == today.year &&
          value.month == today.month &&
          value.day == today.day;
      final upcoming = active.toList()
        ..sort(
          (left, right) =>
              left.order.deliveryDate.compareTo(right.order.deliveryDate),
        );

      // Karigar dashboard metrics.
      final assignedItemIds =
          await (selectOnly(karigarAssignments)
                ..addColumns([karigarAssignments.orderItemId])
                ..where(
                  karigarAssignments.status.isIn(['assigned', 'in_progress']),
                ))
              .get();
      final assignedIds = assignedItemIds
          .map((r) => r.read(karigarAssignments.orderItemId)!)
          .toSet();

      final unassigned =
          (await (select(orderItems)..where(
                    (row) =>
                        row.status.isNotIn([
                          'cancelled',
                          'delivered',
                          'ready',
                        ]) &
                        (assignedIds.isEmpty
                            ? const Constant<bool>(true)
                            : row.id.isNotIn(assignedIds)),
                  ))
                  .get())
              .length;

      final overdueAssign =
          (await (select(karigarAssignments)..where(
                    (row) =>
                        row.status.isIn(['assigned', 'in_progress']) &
                        row.internalDeadline.isSmallerThanValue(now),
                  ))
                  .get())
              .length;

      return DashboardMetrics(
        activeOrders: active.length,
        dueToday: active
            .where((record) => sameDay(record.order.deliveryDate))
            .length,
        overdue: active
            .where((record) => record.order.deliveryDate.isBefore(today))
            .length,
        outstandingPaisa: records
            .where((record) => record.progress != OrderProgress.cancelled)
            .fold(
              0,
              (total, record) =>
                  total + (record.balancePaisa > 0 ? record.balancePaisa : 0),
            ),
        upcoming: upcoming.take(5).toList(),
        unassignedItems: unassigned,
        overdueAssignments: overdueAssign,
      );
    });
  }
}
