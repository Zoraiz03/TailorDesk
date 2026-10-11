import '../../core/database/app_database.dart';

enum OrderItemStatus {
  booked('booked', 'Booked'),
  inProgress('in_progress', 'In progress'),
  ready('ready', 'Ready'),
  delivered('delivered', 'Delivered'),
  cancelled('cancelled', 'Cancelled');

  const OrderItemStatus(this.storageKey, this.label);
  final String storageKey;
  final String label;

  static OrderItemStatus fromStorage(String value) => values.firstWhere(
    (status) => status.storageKey == value,
    orElse: () => OrderItemStatus.booked,
  );
}

enum OrderProgress {
  booked('Booked'),
  inProgress('In progress'),
  ready('Ready'),
  partiallyDelivered('Partially delivered'),
  delivered('Delivered'),
  cancelled('Cancelled');

  const OrderProgress(this.label);
  final String label;
}

enum PaymentMethod {
  cash('cash', 'Cash'),
  manualBankTransfer('manual_bank_transfer', 'Manual bank transfer');

  const PaymentMethod(this.storageKey, this.label);
  final String storageKey;
  final String label;
}

enum PaymentRecordType {
  payment('payment', 'Payment'),
  refund('refund', 'Refund');

  const PaymentRecordType(this.storageKey, this.label);
  final String storageKey;
  final String label;
}

class OrderLineDraft {
  const OrderLineDraft({
    required this.measurementRevisionId,
    required this.quantity,
    required this.stitchingPricePaisa,
    this.clothChargePaisa = 0,
    this.additionalChargePaisa = 0,
    this.additionalChargeDescription = '',
    this.styleInstructions = '',
  });

  final int measurementRevisionId;
  final int quantity;
  final int stitchingPricePaisa;
  final int clothChargePaisa;
  final int additionalChargePaisa;
  final String additionalChargeDescription;
  final String styleInstructions;

  int get totalPaisa =>
      (quantity * stitchingPricePaisa) +
      clothChargePaisa +
      additionalChargePaisa;

  void validate() {
    if (quantity <= 0) throw ArgumentError('Quantity must be positive');
    if (stitchingPricePaisa < 0 ||
        clothChargePaisa < 0 ||
        additionalChargePaisa < 0) {
      throw ArgumentError('Charges cannot be negative');
    }
    if (additionalChargePaisa > 0 &&
        additionalChargeDescription.trim().isEmpty) {
      throw ArgumentError('Describe the additional charge');
    }
  }
}

class NewOrderDraft {
  const NewOrderDraft({
    required this.submissionKey,
    required this.customerId,
    required this.bookingDate,
    required this.deliveryDate,
    required this.lines,
    this.notes = '',
    this.advancePaisa = 0,
    this.advanceMethod = PaymentMethod.cash,
    this.advanceNotes = '',
  });

  final String submissionKey;
  final int customerId;
  final DateTime bookingDate;
  final DateTime deliveryDate;
  final List<OrderLineDraft> lines;
  final String notes;
  final int advancePaisa;
  final PaymentMethod advanceMethod;
  final String advanceNotes;

  int get totalPaisa => lines.fold(0, (total, line) => total + line.totalPaisa);

  void validate() {
    if (submissionKey.trim().isEmpty) {
      throw ArgumentError('Submission key is required');
    }
    if (lines.isEmpty) throw ArgumentError('Add at least one garment');
    if (deliveryDate.isBefore(
      DateTime(bookingDate.year, bookingDate.month, bookingDate.day),
    )) {
      throw ArgumentError('Delivery date cannot be before booking date');
    }
    for (final line in lines) {
      line.validate();
    }
    if (advancePaisa < 0) throw ArgumentError('Advance cannot be negative');
    if (advancePaisa > totalPaisa) {
      throw ArgumentError('Advance cannot exceed the order total');
    }
  }
}

class DuplicateOrderSubmissionException implements Exception {
  const DuplicateOrderSubmissionException();
}

class ExcessPaymentException implements Exception {
  const ExcessPaymentException();
}

class ExcessRefundException implements Exception {
  const ExcessRefundException();
}

class RefundRequiredBeforeCancellationException implements Exception {
  const RefundRequiredBeforeCancellationException(this.amountPaisa);
  final int amountPaisa;
}

class DeliveredOrderCancellationException implements Exception {
  const DeliveredOrderCancellationException();
}

class OrderRecord {
  const OrderRecord({
    required this.order,
    required this.customer,
    required this.items,
    required this.payments,
  });

  final Order order;
  final Customer customer;
  final List<OrderItem> items;
  final List<Payment> payments;

  List<OrderItem> get activeItems => items
      .where((item) => item.status != OrderItemStatus.cancelled.storageKey)
      .toList(growable: false);

  int get totalPaisa => activeItems.fold(
    0,
    (total, item) =>
        total +
        (item.quantity * item.stitchingPricePaisa) +
        item.clothChargePaisa +
        item.additionalChargePaisa,
  );

  int get netPaidPaisa => payments.fold(
    0,
    (total, payment) =>
        payment.recordType == PaymentRecordType.refund.storageKey
        ? total - payment.amountPaisa
        : total + payment.amountPaisa,
  );

  int get balancePaisa => totalPaisa - netPaidPaisa;

  String get paymentStatusLabel {
    if (netPaidPaisa <= 0) return 'Unpaid';
    if (balancePaisa <= 0) return 'Paid';
    return 'Partially paid';
  }

  OrderProgress get progress {
    if (order.cancelledAt != null || activeItems.isEmpty) {
      return OrderProgress.cancelled;
    }
    final statuses = activeItems.map(
      (item) => OrderItemStatus.fromStorage(item.status),
    );
    final delivered = statuses
        .where((status) => status == OrderItemStatus.delivered)
        .length;
    if (delivered == activeItems.length) return OrderProgress.delivered;
    if (delivered > 0) return OrderProgress.partiallyDelivered;
    if (statuses.every((status) => status == OrderItemStatus.ready)) {
      return OrderProgress.ready;
    }
    if (statuses.any(
      (status) =>
          status == OrderItemStatus.inProgress ||
          status == OrderItemStatus.ready,
    )) {
      return OrderProgress.inProgress;
    }
    return OrderProgress.booked;
  }
}

class DashboardMetrics {
  const DashboardMetrics({
    required this.activeOrders,
    required this.dueToday,
    required this.overdue,
    required this.outstandingPaisa,
    required this.upcoming,
    this.unassignedItems = 0,
    this.overdueAssignments = 0,
  });

  final int activeOrders;
  final int dueToday;
  final int overdue;
  final int outstandingPaisa;
  final List<OrderRecord> upcoming;

  /// Order items that have no active karigar assignment and are not
  /// cancelled, delivered, or ready.
  final int unassignedItems;

  /// Active karigar assignments whose internal deadline has passed.
  final int overdueAssignments;
}
