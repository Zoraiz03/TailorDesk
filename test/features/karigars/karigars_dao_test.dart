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
  late AppDatabase database;
  late KarigarsDao karigars;
  late OrdersDao orders;
  late int itemId;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    karigars = KarigarsDao(database);
    orders = OrdersDao(database);
    final customerId = await CustomersDao(
      database,
    ).createCustomer(name: 'Customer', phone: '03000000000');
    final measurements = MeasurementsDao(database);
    final profileId = await measurements.createProfile(
      MeasurementDraft(
        customerId: customerId,
        garmentType: GarmentType.shirt,
        profileName: 'Standard',
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
      ),
    );
    final revision = (await measurements.getProfile(profileId))!.latestRevision;
    final orderId = await orders.createOrder(
      NewOrderDraft(
        submissionKey: 'karigar-test',
        customerId: customerId,
        bookingDate: DateTime(2026, 10, 10),
        deliveryDate: DateTime(2026, 10, 20),
        lines: [
          OrderLineDraft(
            measurementRevisionId: revision.id,
            quantity: 1,
            stitchingPricePaisa: 100000,
          ),
        ],
      ),
    );
    itemId = (await orders.getOrder(orderId))!.items.single.id;
  });

  tearDown(() => database.close());

  test(
    'creates, updates, deactivates, reactivates, and deletes a karigar',
    () async {
      final id = await karigars.createKarigar(
        name: '  Ali  ',
        skills: 'Shirt, Trouser',
      );
      expect((await karigars.getKarigarRecord(id))!.karigar.name, 'Ali');

      await karigars.updateKarigar(id: id, name: 'Ali Khan', phone: '0300');
      expect((await karigars.getKarigarRecord(id))!.karigar.phone, '0300');

      await karigars.deactivateKarigar(id);
      expect(
        (await karigars.getKarigarRecord(id))!.status,
        KarigarStatus.inactive,
      );
      await karigars.reactivateKarigar(id);
      await karigars.deleteKarigar(id);
      expect(await karigars.getKarigarRecord(id), isNull);
    },
  );

  test(
    'assignment lifecycle updates both assignment and garment status',
    () async {
      final id = await karigars.createKarigar(name: 'Ali');
      await karigars.assignItem(
        orderItemId: itemId,
        karigarId: id,
        internalDeadline: DateTime(2026, 10, 18),
        workInstructions: 'Match the pattern',
      );
      var active = await karigars.getActiveAssignment(itemId);
      expect(active!.status, 'assigned');
      expect(await karigars.unassignedItemCount(), 0);

      await karigars.startWork(active.id);
      expect((await orders.getOrder(1))!.items.single.status, 'in_progress');
      active = await karigars.getActiveAssignment(itemId);
      expect(active!.startedAt, isNotNull);

      await karigars.completeWork(active.id);
      expect(await karigars.getActiveAssignment(itemId), isNull);
      expect((await orders.getOrder(1))!.items.single.status, 'ready');
      final history = await karigars.watchAssignmentsForItem(itemId).first;
      expect(history.single.status, AssignmentStatus.completed);
    },
  );

  test(
    'reassignment preserves history and requires an active karigar',
    () async {
      final first = await karigars.createKarigar(name: 'Ali');
      final second = await karigars.createKarigar(name: 'Bilal');
      await karigars.assignItem(orderItemId: itemId, karigarId: first);
      await karigars.assignItem(
        orderItemId: itemId,
        karigarId: second,
        reassignReason: 'Workload balancing',
      );

      final history = await karigars.watchAssignmentsForItem(itemId).first;
      expect(history, hasLength(2));
      expect(
        history.where((entry) => entry.isActive).single.karigar.id,
        second,
      );
      expect(
        history
            .where((entry) => !entry.isActive)
            .single
            .assignment
            .reassignReason,
        'Workload balancing',
      );

      await expectLater(
        karigars.deactivateKarigar(second),
        throwsA(isA<KarigarHasActiveWorkException>()),
      );
      await karigars.deactivateKarigar(first);
      await expectLater(
        karigars.assignItem(orderItemId: itemId, karigarId: first),
        throwsA(isA<InactiveKarigarException>()),
      );
      await expectLater(
        karigars.deleteKarigar(first),
        throwsA(isA<KarigarHasActiveWorkException>()),
      );
    },
  );

  test('alteration preserves completed history and reopens work', () async {
    final id = await karigars.createKarigar(name: 'Ali');
    await karigars.assignItem(orderItemId: itemId, karigarId: id);
    var active = (await karigars.getActiveAssignment(itemId))!;
    await karigars.startWork(active.id);
    active = (await karigars.getActiveAssignment(itemId))!;
    await karigars.completeWork(active.id);

    final completed =
        (await karigars.watchAssignmentsForItem(itemId).first).single;
    await karigars.returnForAlteration(
      assignmentId: completed.assignment.id,
      reason: 'Sleeve too long',
    );

    final history = await karigars.watchAssignmentsForItem(itemId).first;
    expect(history, hasLength(2));
    expect(history.first.status, AssignmentStatus.inProgress);
    expect(history.last.assignment.reassignReason, contains('Sleeve too long'));
    expect((await orders.getOrder(1))!.items.single.status, 'in_progress');
  });

  test('cancelling an order closes its active assignment', () async {
    final id = await karigars.createKarigar(name: 'Ali');
    await karigars.assignItem(orderItemId: itemId, karigarId: id);
    await orders.cancelOrder(1);

    expect(await karigars.getActiveAssignment(itemId), isNull);
    final history = await karigars.watchAssignmentsForItem(itemId).first;
    expect(history.single.status, AssignmentStatus.cancelled);
    expect(history.single.assignment.reassignReason, 'Order cancelled');
  });
}
