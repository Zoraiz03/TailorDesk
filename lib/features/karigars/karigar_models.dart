import '../../core/database/app_database.dart';

// ── Karigar status ────────────────────────────────────────────────────────────

enum KarigarStatus {
  active('active', 'Active'),
  inactive('inactive', 'Inactive');

  const KarigarStatus(this.storageKey, this.label);
  final String storageKey;
  final String label;

  static KarigarStatus fromStorage(String value) => values.firstWhere(
    (s) => s.storageKey == value,
    orElse: () => KarigarStatus.active,
  );
}

// ── Assignment status ─────────────────────────────────────────────────────────

enum AssignmentStatus {
  assigned('assigned', 'Assigned'),
  inProgress('in_progress', 'In progress'),
  completed('completed', 'Completed'),
  cancelled('cancelled', 'Cancelled');

  const AssignmentStatus(this.storageKey, this.label);
  final String storageKey;
  final String label;

  static AssignmentStatus fromStorage(String value) => values.firstWhere(
    (s) => s.storageKey == value,
    orElse: () => AssignmentStatus.assigned,
  );
}

// ── Eligibility errors ────────────────────────────────────────────────────────

class AssignmentNotEligibleException implements Exception {
  const AssignmentNotEligibleException(this.reason);
  final String reason;
  @override
  String toString() => 'AssignmentNotEligibleException: $reason';
}

class InactiveKarigarException implements Exception {
  const InactiveKarigarException();
}

class KarigarHasActiveWorkException implements Exception {
  const KarigarHasActiveWorkException();
}

// ── Composite read models ─────────────────────────────────────────────────────

/// One assignment row joined with its karigar and order-item context.
class AssignmentRecord {
  const AssignmentRecord({
    required this.assignment,
    required this.karigar,
    required this.orderItem,
    required this.order,
    required this.customer,
  });

  final KarigarAssignment assignment;
  final Karigar karigar;
  final OrderItem orderItem;
  final Order order;
  final Customer customer;

  AssignmentStatus get status =>
      AssignmentStatus.fromStorage(assignment.status);

  bool get isActive =>
      status == AssignmentStatus.assigned ||
      status == AssignmentStatus.inProgress;
}

/// Karigar joined with their active workload counts.
class KarigarRecord {
  const KarigarRecord({
    required this.karigar,
    required this.assignedCount,
    required this.inProgressCount,
    required this.completedCount,
  });

  final Karigar karigar;

  /// Items in 'assigned' state.
  final int assignedCount;

  /// Items in 'in_progress' state.
  final int inProgressCount;

  /// Items in 'completed' state (any assignment, all time).
  final int completedCount;

  int get activeCount => assignedCount + inProgressCount;

  KarigarStatus get status => KarigarStatus.fromStorage(karigar.status);
}
