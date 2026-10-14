import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show DateTimeRange;

import '../../../core/database/app_database.dart';
import '../../karigars/data/karigars_dao.dart';
import '../../karigars/karigar_models.dart';
import '../../orders/data/orders_dao.dart';
import '../../orders/order_models.dart';
import '../report_models.dart';

/// Data Access Object for business reports and analytics.
class ReportsDao {
  ReportsDao(this.db)
    : _ordersDao = OrdersDao(db),
      _karigarsDao = KarigarsDao(db);

  final AppDatabase db;
  final OrdersDao _ordersDao;
  final KarigarsDao _karigarsDao;

  // ── 1. Orders Due & Overdue ───────────────────────────────────────────────

  Stream<DueOrdersReport> watchDueOrdersReport() {
    return db
        .customSelect(
          'SELECT 1 AS change_token',
          readsFrom: {db.orders, db.customers, db.orderItems, db.payments},
        )
        .watchSingle()
        .asyncMap((_) => getDueOrdersReport());
  }

  Future<DueOrdersReport> getDueOrdersReport() async {
    final allOrders = await _ordersDao.getAllOrders();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final activeOrders = allOrders.where(
      (record) =>
          record.progress != OrderProgress.cancelled &&
          record.progress != OrderProgress.delivered,
    );

    final overdue = <DueOrderReportItem>[];
    final dueToday = <DueOrderReportItem>[];
    final upcoming = <DueOrderReportItem>[];

    for (final order in activeOrders) {
      final delivery = order.order.deliveryDate;
      final deliveryDateOnly = DateTime(
        delivery.year,
        delivery.month,
        delivery.day,
      );
      final daysDiff = deliveryDateOnly.difference(today).inDays;

      final item = DueOrderReportItem(
        orderRecord: order,
        daysDifference: daysDiff,
      );

      if (daysDiff < 0) {
        overdue.add(item);
      } else if (daysDiff == 0) {
        dueToday.add(item);
      } else {
        upcoming.add(item);
      }
    }

    // Sort overdue: most overdue first (lowest daysDifference)
    overdue.sort((a, b) => a.daysDifference.compareTo(b.daysDifference));
    // Sort upcoming: closest delivery date first
    upcoming.sort((a, b) => a.daysDifference.compareTo(b.daysDifference));

    return DueOrdersReport(
      overdueOrders: overdue,
      dueTodayOrders: dueToday,
      upcomingOrders: upcoming,
    );
  }

  // ── 2. Outstanding Customer Balances ─────────────────────────────────────

  Stream<CustomerBalancesReport> watchCustomerBalancesReport() {
    return db
        .customSelect(
          'SELECT 1 AS change_token',
          readsFrom: {db.orders, db.customers, db.orderItems, db.payments},
        )
        .watchSingle()
        .asyncMap((_) => getCustomerBalancesReport());
  }

  Future<CustomerBalancesReport> getCustomerBalancesReport() async {
    final allOrders = await _ordersDao.getAllOrders();
    final ordersByCustomer = <int, List<OrderRecord>>{};

    for (final order in allOrders) {
      if (order.progress == OrderProgress.cancelled) continue;
      ordersByCustomer
          .putIfAbsent(order.customer.id, () => <OrderRecord>[])
          .add(order);
    }

    final items = <CustomerBalanceReportItem>[];
    var totalOutstandingPaisa = 0;

    for (final entry in ordersByCustomer.entries) {
      final customerOrders = entry.value;
      final customer = customerOrders.first.customer;
      final ordersWithBalance = customerOrders
          .where((o) => o.balancePaisa > 0)
          .toList();

      final totalBalancePaisa = ordersWithBalance.fold<int>(
        0,
        (sum, o) => sum + o.balancePaisa,
      );

      if (totalBalancePaisa > 0) {
        final totalBilledPaisa = customerOrders.fold<int>(
          0,
          (sum, o) => sum + o.totalPaisa,
        );
        final totalPaidPaisa = customerOrders.fold<int>(
          0,
          (sum, o) => sum + o.netPaidPaisa,
        );

        items.add(
          CustomerBalanceReportItem(
            customer: customer,
            unpaidOrdersCount: ordersWithBalance.length,
            totalBalancePaisa: totalBalancePaisa,
            totalBilledPaisa: totalBilledPaisa,
            totalPaidPaisa: totalPaidPaisa,
            ordersWithBalance: ordersWithBalance,
          ),
        );
        totalOutstandingPaisa += totalBalancePaisa;
      }
    }

    // Sort by total balance descending (largest debtor first)
    items.sort((a, b) => b.totalBalancePaisa.compareTo(a.totalBalancePaisa));

    return CustomerBalancesReport(
      items: items,
      totalOutstandingPaisa: totalOutstandingPaisa,
    );
  }

  // ── 3. Payment Collections and Refunds Over a Period ─────────────────────

  Stream<CollectionsReport> watchCollectionsReport({
    CollectionsPeriod period = CollectionsPeriod.thisMonth,
    DateTimeRange? customRange,
  }) {
    return db
        .customSelect(
          'SELECT 1 AS change_token',
          readsFrom: {db.payments, db.orders, db.customers},
        )
        .watchSingle()
        .asyncMap(
          (_) => getCollectionsReport(period: period, customRange: customRange),
        );
  }

  Future<CollectionsReport> getCollectionsReport({
    CollectionsPeriod period = CollectionsPeriod.thisMonth,
    DateTimeRange? customRange,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime? startDate;
    DateTime? endDate;

    switch (period) {
      case CollectionsPeriod.today:
        startDate = today;
        endDate = today.add(const Duration(days: 1));
        break;
      case CollectionsPeriod.thisWeek:
        startDate = today.subtract(const Duration(days: 7));
        endDate = today.add(const Duration(days: 1));
        break;
      case CollectionsPeriod.thisMonth:
        startDate = today.subtract(const Duration(days: 30));
        endDate = today.add(const Duration(days: 1));
        break;
      case CollectionsPeriod.allTime:
        startDate = null;
        endDate = null;
        break;
      case CollectionsPeriod.custom:
        if (customRange != null) {
          startDate = DateTime(
            customRange.start.year,
            customRange.start.month,
            customRange.start.day,
          );
          endDate = DateTime(
            customRange.end.year,
            customRange.end.month,
            customRange.end.day,
          ).add(const Duration(days: 1));
        }
        break;
    }

    final query = db.select(db.payments).join([
      innerJoin(db.orders, db.orders.id.equalsExp(db.payments.orderId)),
      innerJoin(db.customers, db.customers.id.equalsExp(db.orders.customerId)),
    ]);

    if (startDate != null) {
      query.where(db.payments.paymentDate.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where(db.payments.paymentDate.isSmallerThanValue(endDate));
    }

    query.orderBy([
      OrderingTerm.desc(db.payments.paymentDate),
      OrderingTerm.desc(db.payments.id),
    ]);

    final rows = await query.get();

    var grossCollections = 0;
    var totalRefunds = 0;
    var cashCollections = 0;
    var bankTransferCollections = 0;
    var cashRefunds = 0;
    var bankTransferRefunds = 0;
    var paymentCount = 0;
    var refundCount = 0;
    final entries = <PaymentLedgerReportItem>[];

    for (final row in rows) {
      final payment = row.readTable(db.payments);
      final order = row.readTable(db.orders);
      final customer = row.readTable(db.customers);

      final isRefund =
          payment.recordType == PaymentRecordType.refund.storageKey;
      final isCash = payment.method == PaymentMethod.cash.storageKey;

      if (isRefund) {
        totalRefunds += payment.amountPaisa;
        refundCount++;
        if (isCash) {
          cashRefunds += payment.amountPaisa;
        } else {
          bankTransferRefunds += payment.amountPaisa;
        }
      } else {
        grossCollections += payment.amountPaisa;
        paymentCount++;
        if (isCash) {
          cashCollections += payment.amountPaisa;
        } else {
          bankTransferCollections += payment.amountPaisa;
        }
      }

      entries.add(
        PaymentLedgerReportItem(
          payment: payment,
          orderNumber: order.orderNumber,
          orderId: order.id,
          customerName: customer.name,
          customerId: customer.id,
        ),
      );
    }

    return CollectionsReport(
      period: period,
      startDate: startDate,
      endDate: endDate,
      grossCollectionsPaisa: grossCollections,
      totalRefundsPaisa: totalRefunds,
      cashCollectionsPaisa: cashCollections,
      bankTransferCollectionsPaisa: bankTransferCollections,
      cashRefundsPaisa: cashRefunds,
      bankTransferRefundsPaisa: bankTransferRefunds,
      paymentCount: paymentCount,
      refundCount: refundCount,
      ledgerEntries: entries,
    );
  }

  // ── 4. Karigar Workload & Pending Assignments ─────────────────────────────

  Stream<KarigarWorkloadReport> watchKarigarWorkloadReport() {
    return db
        .customSelect(
          'SELECT 1 AS change_token',
          readsFrom: {
            db.karigars,
            db.karigarAssignments,
            db.orderItems,
            db.orders,
            db.customers,
          },
        )
        .watchSingle()
        .asyncMap((_) => getKarigarWorkloadReport());
  }

  Future<KarigarWorkloadReport> getKarigarWorkloadReport() async {
    final now = DateTime.now();
    final allKarigars = await (db.select(
      db.karigars,
    )..orderBy([(k) => OrderingTerm.asc(k.name)])).get();

    final allAssignments = await _karigarsDao.getAssignments();
    final assignmentsByKarigar = <int, List<AssignmentRecord>>{};

    for (final assignment in allAssignments) {
      assignmentsByKarigar
          .putIfAbsent(assignment.karigar.id, () => <AssignmentRecord>[])
          .add(assignment);
    }

    final workerWorkloads = <KarigarWorkloadItem>[];
    var totalActiveWorkers = 0;
    var totalActiveAssignments = 0;
    var totalOverdueAssignments = 0;

    for (final karigar in allKarigars) {
      if (karigar.status == 'active') totalActiveWorkers++;

      final assignments = assignmentsByKarigar[karigar.id] ?? const [];
      final activeAssignments = assignments.where((a) => a.isActive).toList();

      var assigned = 0;
      var inProgress = 0;
      var completed = 0;
      var overdueDeadlines = 0;

      for (final a in assignments) {
        if (a.status == AssignmentStatus.completed) {
          completed++;
        } else if (a.status == AssignmentStatus.inProgress) {
          inProgress++;
        } else if (a.status == AssignmentStatus.assigned) {
          assigned++;
        }
      }

      for (final a in activeAssignments) {
        final deadline = a.assignment.internalDeadline;
        if (deadline != null && deadline.isBefore(now)) {
          overdueDeadlines++;
        }
      }

      totalActiveAssignments += activeAssignments.length;
      totalOverdueAssignments += overdueDeadlines;

      workerWorkloads.add(
        KarigarWorkloadItem(
          karigar: karigar,
          assignedCount: assigned,
          inProgressCount: inProgress,
          completedCount: completed,
          overdueDeadlinesCount: overdueDeadlines,
          activeAssignments: activeAssignments,
        ),
      );
    }

    // Find unassigned garment items in active orders
    final assignedItemIds =
        (await (db.selectOnly(db.karigarAssignments)
                  ..addColumns([db.karigarAssignments.orderItemId])
                  ..where(
                    db.karigarAssignments.status.isIn([
                      'assigned',
                      'in_progress',
                    ]),
                  ))
                .get())
            .map((r) => r.read(db.karigarAssignments.orderItemId)!)
            .toSet();

    final unassignedQuery =
        db.select(db.orderItems).join([
          innerJoin(db.orders, db.orders.id.equalsExp(db.orderItems.orderId)),
          innerJoin(
            db.customers,
            db.customers.id.equalsExp(db.orders.customerId),
          ),
        ])..where(
          db.orders.cancelledAt.isNull() &
              db.orderItems.status.isNotIn(['cancelled', 'delivered', 'ready']),
        );

    if (assignedItemIds.isNotEmpty) {
      unassignedQuery.where(db.orderItems.id.isNotIn(assignedItemIds));
    }

    final unassignedRows = await unassignedQuery.get();
    final unassignedItems = unassignedRows.map((row) {
      final item = row.readTable(db.orderItems);
      final order = row.readTable(db.orders);
      final customer = row.readTable(db.customers);
      return UnassignedGarmentItem(
        orderItem: item,
        orderNumber: order.orderNumber,
        orderId: order.id,
        customerName: customer.name,
        deliveryDate: order.deliveryDate,
      );
    }).toList();

    return KarigarWorkloadReport(
      workerWorkloads: workerWorkloads,
      unassignedItems: unassignedItems,
      totalActiveWorkers: totalActiveWorkers,
      totalActiveAssignments: totalActiveAssignments,
      totalUnassignedItems: unassignedItems.length,
      totalOverdueAssignments: totalOverdueAssignments,
    );
  }
}
