import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../karigar_models.dart';

part 'karigars_dao.g.dart';

@DriftAccessor(
  tables: [Karigars, KarigarAssignments, OrderItems, Orders, Customers],
)
class KarigarsDao extends DatabaseAccessor<AppDatabase>
    with _$KarigarsDaoMixin {
  KarigarsDao(super.attachedDatabase);

  // ── Karigar CRUD ──────────────────────────────────────────────────────────

  Future<int> createKarigar({
    required String name,
    String phone = '',
    String address = '',
    String skills = '',
    String notes = '',
  }) {
    attachedDatabase.requireBusinessWrite();
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) throw ArgumentError('Name is required');
    final now = DateTime.now();
    return into(karigars).insert(
      KarigarsCompanion.insert(
        name: trimmedName,
        phone: Value(phone.trim()),
        address: Value(address.trim()),
        skills: Value(skills.trim()),
        notes: Value(notes.trim()),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> updateKarigar({
    required int id,
    required String name,
    String phone = '',
    String address = '',
    String skills = '',
    String notes = '',
  }) {
    attachedDatabase.requireBusinessWrite();
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) throw ArgumentError('Name is required');
    return (update(karigars)..where((row) => row.id.equals(id))).write(
      KarigarsCompanion(
        name: Value(trimmedName),
        phone: Value(phone.trim()),
        address: Value(address.trim()),
        skills: Value(skills.trim()),
        notes: Value(notes.trim()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Deactivates a karigar. Workers with assignment history cannot be deleted.
  Future<void> deactivateKarigar(int id) async {
    attachedDatabase.requireBusinessWrite();
    final active =
        await (select(karigarAssignments)..where(
              (row) =>
                  row.karigarId.equals(id) &
                  row.status.isIn([
                    AssignmentStatus.assigned.storageKey,
                    AssignmentStatus.inProgress.storageKey,
                  ]),
            ))
            .get();
    if (active.isNotEmpty) throw const KarigarHasActiveWorkException();
    await (update(karigars)..where((row) => row.id.equals(id))).write(
      KarigarsCompanion(
        status: const Value('inactive'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Reactivates a previously deactivated karigar.
  Future<void> reactivateKarigar(int id) {
    attachedDatabase.requireBusinessWrite();
    return (update(karigars)..where((row) => row.id.equals(id))).write(
      KarigarsCompanion(
        status: const Value('active'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Permanently deletes only if the karigar has NO assignment history.
  Future<void> deleteKarigar(int id) async {
    attachedDatabase.requireBusinessWrite();
    final count =
        await (selectOnly(karigarAssignments)
              ..addColumns([karigarAssignments.id])
              ..where(karigarAssignments.karigarId.equals(id)))
            .get();
    if (count.isNotEmpty) {
      throw const KarigarHasActiveWorkException();
    }
    await (delete(karigars)..where((row) => row.id.equals(id))).go();
  }

  Stream<List<KarigarRecord>> watchAll({bool? activeOnly}) {
    return customSelect(
      'SELECT 1 AS change_token',
      readsFrom: {karigars, karigarAssignments},
    ).watchSingle().asyncMap((_) => _getRecords(activeOnly: activeOnly));
  }

  Future<KarigarRecord?> getKarigarRecord(int id) async {
    final records = await _getRecords(id: id);
    return records.isEmpty ? null : records.first;
  }

  Stream<KarigarRecord?> watchKarigar(int id) {
    return customSelect(
      'SELECT ? AS karigar_id',
      variables: [Variable.withInt(id)],
      readsFrom: {karigars, karigarAssignments},
    ).watchSingle().asyncMap((_) => getKarigarRecord(id));
  }

  Future<List<KarigarRecord>> _getRecords({int? id, bool? activeOnly}) async {
    final query = select(karigars);
    if (id != null) query.where((row) => row.id.equals(id));
    if (activeOnly == true) {
      query.where((row) => row.status.equals('active'));
    }
    query.orderBy([(row) => OrderingTerm.asc(row.name)]);
    final rows = await query.get();
    final result = <KarigarRecord>[];
    for (final k in rows) {
      result.add(await _buildRecord(k));
    }
    return result;
  }

  Future<KarigarRecord> _buildRecord(Karigar k) async {
    final counts =
        await (selectOnly(karigarAssignments)
              ..addColumns([
                karigarAssignments.status,
                karigarAssignments.id.count(),
              ])
              ..where(karigarAssignments.karigarId.equals(k.id))
              ..groupBy([karigarAssignments.status]))
            .get();

    int assigned = 0, inProgress = 0, completed = 0;
    for (final row in counts) {
      final status = row.read(karigarAssignments.status) ?? '';
      final count = row.read(karigarAssignments.id.count()) ?? 0;
      if (status == AssignmentStatus.assigned.storageKey) assigned = count;
      if (status == AssignmentStatus.inProgress.storageKey) inProgress = count;
      if (status == AssignmentStatus.completed.storageKey) completed = count;
    }
    return KarigarRecord(
      karigar: k,
      assignedCount: assigned,
      inProgressCount: inProgress,
      completedCount: completed,
    );
  }

  // ── Assignment queries ────────────────────────────────────────────────────

  Stream<List<AssignmentRecord>> watchAssignmentsForKarigar(int karigarId) {
    return customSelect(
      'SELECT ? AS karigar_id',
      variables: [Variable.withInt(karigarId)],
      readsFrom: {karigarAssignments, orderItems, orders, customers, karigars},
    ).watchSingle().asyncMap((_) => _getAssignments(karigarId: karigarId));
  }

  Stream<List<AssignmentRecord>> watchAssignmentsForItem(int orderItemId) {
    return customSelect(
      'SELECT ? AS item_id',
      variables: [Variable.withInt(orderItemId)],
      readsFrom: {karigarAssignments, orderItems, orders, customers, karigars},
    ).watchSingle().asyncMap((_) => _getAssignments(orderItemId: orderItemId));
  }

  Future<List<AssignmentRecord>> getAssignments({
    int? karigarId,
    int? orderItemId,
  }) => _getAssignments(karigarId: karigarId, orderItemId: orderItemId);

  Future<List<AssignmentRecord>> _getAssignments({
    int? karigarId,
    int? orderItemId,
  }) async {
    final q = select(karigarAssignments).join([
      innerJoin(
        orderItems,
        orderItems.id.equalsExp(karigarAssignments.orderItemId),
      ),
      innerJoin(orders, orders.id.equalsExp(orderItems.orderId)),
      innerJoin(customers, customers.id.equalsExp(orders.customerId)),
      innerJoin(karigars, karigars.id.equalsExp(karigarAssignments.karigarId)),
    ]);
    if (karigarId != null) {
      q.where(karigarAssignments.karigarId.equals(karigarId));
    }
    if (orderItemId != null) {
      q.where(karigarAssignments.orderItemId.equals(orderItemId));
    }
    q.orderBy([
      OrderingTerm.desc(karigarAssignments.assignedAt),
      OrderingTerm.desc(karigarAssignments.id),
    ]);
    final rows = await q.get();
    return rows
        .map(
          (row) => AssignmentRecord(
            assignment: row.readTable(karigarAssignments),
            karigar: row.readTable(karigars),
            orderItem: row.readTable(orderItems),
            order: row.readTable(orders),
            customer: row.readTable(customers),
          ),
        )
        .toList();
  }

  Future<KarigarAssignment?> getActiveAssignment(int orderItemId) async {
    return (select(karigarAssignments)
          ..where(
            (row) =>
                row.orderItemId.equals(orderItemId) &
                row.status.isIn([
                  AssignmentStatus.assigned.storageKey,
                  AssignmentStatus.inProgress.storageKey,
                ]),
          )
          ..orderBy([(row) => OrderingTerm.desc(row.assignedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  // ── Assignment transitions (all via WorkflowService) ─────────────────────

  /// Assigns an order item to a karigar.
  ///
  /// Cancels any prior active assignment (inserting a cancellation row),
  /// then inserts a new 'assigned' row.
  Future<void> assignItem({
    required int orderItemId,
    required int karigarId,
    DateTime? internalDeadline,
    String workInstructions = '',
    String reassignReason = '',
  }) {
    attachedDatabase.requireBusinessWrite();
    return transaction(() async {
      // Validate karigar is active.
      final k = await (select(
        karigars,
      )..where((row) => row.id.equals(karigarId))).getSingleOrNull();
      if (k == null) throw StateError('Karigar not found');
      if (k.status == KarigarStatus.inactive.storageKey) {
        throw const InactiveKarigarException();
      }

      // Validate item is assignable.
      final item = await (select(
        orderItems,
      )..where((row) => row.id.equals(orderItemId))).getSingleOrNull();
      if (item == null) throw StateError('Order item not found');

      // Check the parent order is not cancelled or delivered.
      final order = await (select(
        orders,
      )..where((row) => row.id.equals(item.orderId))).getSingle();
      if (order.cancelledAt != null) {
        throw const AssignmentNotEligibleException(
          'Cannot assign a cancelled order',
        );
      }
      if (item.status == 'cancelled' || item.status == 'delivered') {
        throw AssignmentNotEligibleException(
          'Cannot assign item with status: ${item.status}',
        );
      }

      // Warn (via exception) if internal deadline exceeds order delivery.
      if (internalDeadline != null &&
          internalDeadline.isAfter(order.deliveryDate)) {
        // Not a hard block — caller may choose to ignore; we do not throw.
        // A separate [AssignmentDeadlineWarning] is surfaced in UI instead.
      }

      final now = DateTime.now();

      // Cancel any existing active assignment.
      await (update(karigarAssignments)..where(
            (row) =>
                row.orderItemId.equals(orderItemId) &
                row.status.isIn([
                  AssignmentStatus.assigned.storageKey,
                  AssignmentStatus.inProgress.storageKey,
                ]),
          ))
          .write(
            KarigarAssignmentsCompanion(
              status: const Value('cancelled'),
              reassignReason: Value(
                reassignReason.isNotEmpty
                    ? reassignReason
                    : 'Reassigned to another worker',
              ),
              updatedAt: Value(now),
            ),
          );

      // Insert new assignment row.
      await into(karigarAssignments).insert(
        KarigarAssignmentsCompanion.insert(
          orderItemId: orderItemId,
          karigarId: karigarId,
          internalDeadline: Value(internalDeadline),
          workInstructions: Value(workInstructions.trim()),
          assignedAt: now,
          updatedAt: Value(now),
        ),
      );
    });
  }

  /// Marks the active assignment as started; item moves to 'in_progress'.
  Future<void> startWork(int assignmentId) {
    attachedDatabase.requireBusinessWrite();
    return transaction(() async {
      final a = await (select(
        karigarAssignments,
      )..where((row) => row.id.equals(assignmentId))).getSingleOrNull();
      if (a == null) throw StateError('Assignment not found');
      if (a.status != AssignmentStatus.assigned.storageKey) {
        throw AssignmentNotEligibleException(
          'Cannot start work from status: ${a.status}',
        );
      }
      final now = DateTime.now();
      await (update(
        karigarAssignments,
      )..where((row) => row.id.equals(assignmentId))).write(
        KarigarAssignmentsCompanion(
          status: const Value('in_progress'),
          startedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      await _setItemStatus(a.orderItemId, 'in_progress', now);
    });
  }

  /// Marks the active assignment as completed; item moves to 'ready'.
  Future<void> completeWork(int assignmentId) {
    attachedDatabase.requireBusinessWrite();
    return transaction(() async {
      final a = await (select(
        karigarAssignments,
      )..where((row) => row.id.equals(assignmentId))).getSingleOrNull();
      if (a == null) throw StateError('Assignment not found');
      if (a.status != AssignmentStatus.inProgress.storageKey) {
        throw AssignmentNotEligibleException(
          'Cannot complete work from status: ${a.status}',
        );
      }
      final now = DateTime.now();
      await (update(
        karigarAssignments,
      )..where((row) => row.id.equals(assignmentId))).write(
        KarigarAssignmentsCompanion(
          status: const Value('completed'),
          completedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      await _setItemStatus(a.orderItemId, 'ready', now);
    });
  }

  /// Returns completed work for alteration; item moves back to 'in_progress'.
  Future<void> returnForAlteration({
    required int assignmentId,
    required String reason,
  }) {
    attachedDatabase.requireBusinessWrite();
    if (reason.trim().isEmpty) throw ArgumentError('Reason is required');
    return transaction(() async {
      final a = await (select(
        karigarAssignments,
      )..where((row) => row.id.equals(assignmentId))).getSingleOrNull();
      if (a == null) throw StateError('Assignment not found');
      if (a.status != AssignmentStatus.completed.storageKey) {
        throw AssignmentNotEligibleException(
          'Cannot return for alteration from status: ${a.status}',
        );
      }
      final now = DateTime.now();
      // Mark the completed assignment as cancelled (alteration).
      await (update(
        karigarAssignments,
      )..where((row) => row.id.equals(assignmentId))).write(
        KarigarAssignmentsCompanion(
          status: const Value('cancelled'),
          reassignReason: Value('Returned for alteration: ${reason.trim()}'),
          updatedAt: Value(now),
        ),
      );
      // Insert a fresh assignment back to the same karigar for the alteration.
      await into(karigarAssignments).insert(
        KarigarAssignmentsCompanion.insert(
          orderItemId: a.orderItemId,
          karigarId: a.karigarId,
          internalDeadline: Value(a.internalDeadline),
          workInstructions: Value(a.workInstructions),
          status: const Value('in_progress'),
          assignedAt: now,
          startedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      await _setItemStatus(a.orderItemId, 'in_progress', now);
    });
  }

  /// Cancels the active assignment for an item (used when the order is cancelled).
  Future<void> cancelActiveAssignment(int orderItemId, {String reason = ''}) {
    attachedDatabase.requireBusinessWrite();
    return (update(karigarAssignments)..where(
          (row) =>
              row.orderItemId.equals(orderItemId) &
              row.status.isIn([
                AssignmentStatus.assigned.storageKey,
                AssignmentStatus.inProgress.storageKey,
              ]),
        ))
        .write(
          KarigarAssignmentsCompanion(
            status: const Value('cancelled'),
            reassignReason: Value(reason.isEmpty ? 'Order cancelled' : reason),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  // ── Dashboard queries ─────────────────────────────────────────────────────

  /// Count of order items that have no active karigar assignment and are not
  /// cancelled or delivered.
  Future<int> unassignedItemCount() async {
    final assigned =
        await (selectOnly(karigarAssignments)
              ..addColumns([karigarAssignments.orderItemId])
              ..where(
                karigarAssignments.status.isIn([
                  AssignmentStatus.assigned.storageKey,
                  AssignmentStatus.inProgress.storageKey,
                ]),
              ))
            .get();

    final assignedIds = assigned
        .map((r) => r.read(karigarAssignments.orderItemId)!)
        .toSet();

    final active =
        await (select(orderItems)..where(
              (row) =>
                  row.status.isNotIn(['cancelled', 'delivered', 'ready']) &
                  row.id.isNotIn(assignedIds.isEmpty ? [-1] : assignedIds),
            ))
            .get();

    return active.length;
  }

  /// Count of active assignments whose internal deadline has passed.
  Future<int> overdueAssignmentCount() async {
    final now = DateTime.now();
    final rows =
        await (select(karigarAssignments)..where(
              (row) =>
                  row.status.isIn([
                    AssignmentStatus.assigned.storageKey,
                    AssignmentStatus.inProgress.storageKey,
                  ]) &
                  row.internalDeadline.isSmallerThanValue(now),
            ))
            .get();
    return rows.length;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<void> _setItemStatus(
    int orderItemId,
    String status,
    DateTime now,
  ) async {
    await (update(
      orderItems,
    )..where((row) => row.id.equals(orderItemId))).write(
      OrderItemsCompanion(status: Value(status), updatedAt: Value(now)),
    );
  }
}
