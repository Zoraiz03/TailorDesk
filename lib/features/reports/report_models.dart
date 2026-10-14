import '../../core/database/app_database.dart';
import '../karigars/karigar_models.dart';
import '../orders/order_models.dart';

/// Single item in the Due & Overdue orders report.
class DueOrderReportItem {
  const DueOrderReportItem({
    required this.orderRecord,
    required this.daysDifference,
  });

  final OrderRecord orderRecord;

  /// Negative if past delivery date (overdue), 0 if delivery date is today, positive if upcoming.
  final int daysDifference;

  bool get isOverdue => daysDifference < 0;
  bool get isDueToday => daysDifference == 0;
  int get daysOverdue => daysDifference < 0 ? -daysDifference : 0;
  int get daysRemaining => daysDifference > 0 ? daysDifference : 0;
}

/// Report containing overdue, due today, and upcoming orders.
class DueOrdersReport {
  const DueOrdersReport({
    required this.overdueOrders,
    required this.dueTodayOrders,
    required this.upcomingOrders,
  });

  final List<DueOrderReportItem> overdueOrders;
  final List<DueOrderReportItem> dueTodayOrders;
  final List<DueOrderReportItem> upcomingOrders;

  int get totalDueCount =>
      overdueOrders.length + dueTodayOrders.length + upcomingOrders.length;

  int get totalOverduePaisa =>
      overdueOrders.fold(0, (sum, item) => sum + item.orderRecord.balancePaisa);

  int get totalDueTodayPaisa => dueTodayOrders.fold(
    0,
    (sum, item) => sum + item.orderRecord.balancePaisa,
  );

  int get totalUpcomingPaisa => upcomingOrders.fold(
    0,
    (sum, item) => sum + item.orderRecord.balancePaisa,
  );
}

/// Single customer's balance summary.
class CustomerBalanceReportItem {
  const CustomerBalanceReportItem({
    required this.customer,
    required this.unpaidOrdersCount,
    required this.totalBalancePaisa,
    required this.totalBilledPaisa,
    required this.totalPaidPaisa,
    required this.ordersWithBalance,
  });

  final Customer customer;
  final int unpaidOrdersCount;
  final int totalBalancePaisa;
  final int totalBilledPaisa;
  final int totalPaidPaisa;
  final List<OrderRecord> ordersWithBalance;
}

/// Report containing all customers with outstanding balances.
class CustomerBalancesReport {
  const CustomerBalancesReport({
    required this.items,
    required this.totalOutstandingPaisa,
  });

  final List<CustomerBalanceReportItem> items;
  final int totalOutstandingPaisa;

  int get customerCountWithBalance => items.length;
}

/// Time period filter for collections and refunds.
enum CollectionsPeriod {
  today('Today'),
  thisWeek('Last 7 Days'),
  thisMonth('Last 30 Days'),
  allTime('All Time'),
  custom('Custom Range');

  const CollectionsPeriod(this.label);
  final String label;
}

/// Single transaction in the payment collections and refunds ledger.
class PaymentLedgerReportItem {
  const PaymentLedgerReportItem({
    required this.payment,
    required this.orderNumber,
    required this.orderId,
    required this.customerName,
    required this.customerId,
  });

  final Payment payment;
  final String orderNumber;
  final int orderId;
  final String customerName;
  final int customerId;

  bool get isRefund =>
      payment.recordType == PaymentRecordType.refund.storageKey;
  bool get isPayment => !isRefund;
  bool get isBankTransfer =>
      payment.method == PaymentMethod.manualBankTransfer.storageKey;
}

/// Report of payment collections and refunds over a given period.
class CollectionsReport {
  const CollectionsReport({
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.grossCollectionsPaisa,
    required this.totalRefundsPaisa,
    required this.cashCollectionsPaisa,
    required this.bankTransferCollectionsPaisa,
    required this.cashRefundsPaisa,
    required this.bankTransferRefundsPaisa,
    required this.paymentCount,
    required this.refundCount,
    required this.ledgerEntries,
  });

  final CollectionsPeriod period;
  final DateTime? startDate;
  final DateTime? endDate;
  final int grossCollectionsPaisa;
  final int totalRefundsPaisa;
  final int cashCollectionsPaisa;
  final int bankTransferCollectionsPaisa;
  final int cashRefundsPaisa;
  final int bankTransferRefundsPaisa;
  final int paymentCount;
  final int refundCount;
  final List<PaymentLedgerReportItem> ledgerEntries;

  /// Net collections = Gross Payments - Total Refunds.
  /// Deliberately labelled "Net Collections", NOT profit.
  int get netCollectionsPaisa => grossCollectionsPaisa - totalRefundsPaisa;
}

/// Workload summary for a single karigar.
class KarigarWorkloadItem {
  const KarigarWorkloadItem({
    required this.karigar,
    required this.assignedCount,
    required this.inProgressCount,
    required this.completedCount,
    required this.overdueDeadlinesCount,
    required this.activeAssignments,
  });

  final Karigar karigar;
  final int assignedCount;
  final int inProgressCount;
  final int completedCount;
  final int overdueDeadlinesCount;
  final List<AssignmentRecord> activeAssignments;

  int get activeCount => assignedCount + inProgressCount;
}

/// An order garment line in an active order that has no active assignment.
class UnassignedGarmentItem {
  const UnassignedGarmentItem({
    required this.orderItem,
    required this.orderNumber,
    required this.orderId,
    required this.customerName,
    required this.deliveryDate,
  });

  final OrderItem orderItem;
  final String orderNumber;
  final int orderId;
  final String customerName;
  final DateTime deliveryDate;
}

/// Workshop karigar workload and pending assignments report.
class KarigarWorkloadReport {
  const KarigarWorkloadReport({
    required this.workerWorkloads,
    required this.unassignedItems,
    required this.totalActiveWorkers,
    required this.totalActiveAssignments,
    required this.totalUnassignedItems,
    required this.totalOverdueAssignments,
  });

  final List<KarigarWorkloadItem> workerWorkloads;
  final List<UnassignedGarmentItem> unassignedItems;
  final int totalActiveWorkers;
  final int totalActiveAssignments;
  final int totalUnassignedItems;
  final int totalOverdueAssignments;
}
