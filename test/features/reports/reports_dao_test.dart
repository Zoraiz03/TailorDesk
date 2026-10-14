import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/features/customers/data/customers_dao.dart';
import 'package:tailor/features/karigars/data/karigars_dao.dart';
import 'package:tailor/features/measurements/data/measurements_dao.dart';
import 'package:tailor/features/measurements/measurement_models.dart';
import 'package:tailor/features/measurements/measurement_templates.dart';
import 'package:tailor/features/orders/data/orders_dao.dart';
import 'package:tailor/features/orders/order_models.dart';
import 'package:tailor/features/reports/data/reports_dao.dart';
import 'package:tailor/features/reports/report_models.dart';

void main() {
  late AppDatabase db;
  late CustomersDao customersDao;
  late MeasurementsDao measurementsDao;
  late OrdersDao ordersDao;
  late KarigarsDao karigarsDao;
  late ReportsDao reportsDao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    customersDao = CustomersDao(db);
    measurementsDao = MeasurementsDao(db);
    ordersDao = OrdersDao(db);
    karigarsDao = KarigarsDao(db);
    reportsDao = ReportsDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('reports due, overdue, and upcoming orders correctly', () async {
    final customerId = await customersDao.createCustomer(
      name: 'Ahmed Khan',
      phone: '03001112233',
    );
    final profileId = await measurementsDao.createProfile(
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
    final rev = (await measurementsDao.getProfile(profileId))!.latestRevision;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Overdue order (3 days ago)
    await ordersDao.createOrder(
      NewOrderDraft(
        submissionKey: 'ord-overdue',
        customerId: customerId,
        bookingDate: today.subtract(const Duration(days: 10)),
        deliveryDate: today.subtract(const Duration(days: 3)),
        lines: [
          OrderLineDraft(
            measurementRevisionId: rev.id,
            quantity: 1,
            stitchingPricePaisa: 200000,
          ),
        ],
        advancePaisa: 50000,
      ),
    );

    // Due today order
    await ordersDao.createOrder(
      NewOrderDraft(
        submissionKey: 'ord-today',
        customerId: customerId,
        bookingDate: today.subtract(const Duration(days: 5)),
        deliveryDate: today,
        lines: [
          OrderLineDraft(
            measurementRevisionId: rev.id,
            quantity: 1,
            stitchingPricePaisa: 150000,
          ),
        ],
        advancePaisa: 0,
      ),
    );

    // Upcoming order (in 4 days)
    await ordersDao.createOrder(
      NewOrderDraft(
        submissionKey: 'ord-upcoming',
        customerId: customerId,
        bookingDate: today,
        deliveryDate: today.add(const Duration(days: 4)),
        lines: [
          OrderLineDraft(
            measurementRevisionId: rev.id,
            quantity: 1,
            stitchingPricePaisa: 100000,
          ),
        ],
        advancePaisa: 100000,
      ),
    );

    final report = await reportsDao.getDueOrdersReport();

    expect(report.overdueOrders, hasLength(1));
    expect(report.overdueOrders.first.daysDifference, -3);
    expect(report.overdueOrders.first.isOverdue, isTrue);
    expect(report.overdueOrders.first.orderRecord.balancePaisa, 150000);

    expect(report.dueTodayOrders, hasLength(1));
    expect(report.dueTodayOrders.first.isDueToday, isTrue);
    expect(report.dueTodayOrders.first.orderRecord.balancePaisa, 150000);

    expect(report.upcomingOrders, hasLength(1));
    expect(report.upcomingOrders.first.daysRemaining, 4);
    expect(report.upcomingOrders.first.orderRecord.balancePaisa, 0);

    expect(report.totalDueCount, 3);
  });

  test('reports outstanding customer balances accurately', () async {
    final c1 = await customersDao.createCustomer(
      name: 'Customer One',
      phone: '03001111111',
    );
    final c2 = await customersDao.createCustomer(
      name: 'Customer Two',
      phone: '03002222222',
    );

    final p1 = await measurementsDao.createProfile(
      MeasurementDraft(
        customerId: c1,
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
    final p2 = await measurementsDao.createProfile(
      MeasurementDraft(
        customerId: c2,
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

    final rev1 = (await measurementsDao.getProfile(p1))!.latestRevision;
    final rev2 = (await measurementsDao.getProfile(p2))!.latestRevision;

    // C1: Order total 300,000, paid 100,000 -> balance 200,000
    await ordersDao.createOrder(
      NewOrderDraft(
        submissionKey: 'ord-c1',
        customerId: c1,
        bookingDate: DateTime(2026, 10, 1),
        deliveryDate: DateTime(2026, 10, 15),
        lines: [
          OrderLineDraft(
            measurementRevisionId: rev1.id,
            quantity: 1,
            stitchingPricePaisa: 300000,
          ),
        ],
        advancePaisa: 100000,
      ),
    );

    // C2: Order total 500,000, paid 500,000 -> balance 0
    await ordersDao.createOrder(
      NewOrderDraft(
        submissionKey: 'ord-c2',
        customerId: c2,
        bookingDate: DateTime(2026, 10, 1),
        deliveryDate: DateTime(2026, 10, 15),
        lines: [
          OrderLineDraft(
            measurementRevisionId: rev2.id,
            quantity: 1,
            stitchingPricePaisa: 500000,
          ),
        ],
        advancePaisa: 500000,
      ),
    );

    final report = await reportsDao.getCustomerBalancesReport();

    // Only C1 has an outstanding balance
    expect(report.items, hasLength(1));
    expect(report.items.first.customer.id, c1);
    expect(report.items.first.totalBalancePaisa, 200000);
    expect(report.items.first.unpaidOrdersCount, 1);
    expect(report.totalOutstandingPaisa, 200000);
    expect(report.customerCountWithBalance, 1);
  });

  test(
    'aggregates payment collections and refunds without profit labeling',
    () async {
      final customerId = await customersDao.createCustomer(
        name: 'Ledger Customer',
        phone: '03009998877',
      );
      final profileId = await measurementsDao.createProfile(
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
      final rev = (await measurementsDao.getProfile(profileId))!.latestRevision;

      final now = DateTime.now();

      // Order with cash advance of 100,000
      final orderId = await ordersDao.createOrder(
        NewOrderDraft(
          submissionKey: 'ord-ledger',
          customerId: customerId,
          bookingDate: now,
          deliveryDate: now.add(const Duration(days: 7)),
          lines: [
            OrderLineDraft(
              measurementRevisionId: rev.id,
              quantity: 1,
              stitchingPricePaisa: 300000,
            ),
          ],
          advancePaisa: 100000,
          advanceMethod: PaymentMethod.cash,
        ),
      );

      // Bank transfer payment of 150,000
      await ordersDao.addLedgerEntry(
        orderId: orderId,
        amountPaisa: 150000,
        type: PaymentRecordType.payment,
        method: PaymentMethod.manualBankTransfer,
        date: now,
      );

      // Refund of 50,000
      await ordersDao.addLedgerEntry(
        orderId: orderId,
        amountPaisa: 50000,
        type: PaymentRecordType.refund,
        method: PaymentMethod.cash,
        date: now,
      );

      final report = await reportsDao.getCollectionsReport(
        period: CollectionsPeriod.allTime,
      );

      expect(report.grossCollectionsPaisa, 250000);
      expect(report.cashCollectionsPaisa, 100000);
      expect(report.bankTransferCollectionsPaisa, 150000);
      expect(report.totalRefundsPaisa, 50000);
      expect(report.cashRefundsPaisa, 50000);
      expect(report.netCollectionsPaisa, 200000); // 250,000 - 50,000
      expect(report.paymentCount, 2);
      expect(report.refundCount, 1);
      expect(report.ledgerEntries, hasLength(3));
    },
  );

  test('tracks karigar workload and unassigned garment items', () async {
    final customerId = await customersDao.createCustomer(
      name: 'Workshop Customer',
      phone: '03005554433',
    );
    final profileId = await measurementsDao.createProfile(
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
    final rev = (await measurementsDao.getProfile(profileId))!.latestRevision;

    final k1 = await karigarsDao.createKarigar(
      name: 'Karigar A',
      skills: 'Shirt',
    );
    final k2 = await karigarsDao.createKarigar(
      name: 'Karigar B',
      skills: 'Trouser',
    );

    final orderId = await ordersDao.createOrder(
      NewOrderDraft(
        submissionKey: 'ord-workshop',
        customerId: customerId,
        bookingDate: DateTime.now(),
        deliveryDate: DateTime.now().add(const Duration(days: 5)),
        lines: [
          OrderLineDraft(
            measurementRevisionId: rev.id,
            quantity: 1,
            stitchingPricePaisa: 150000,
          ),
          OrderLineDraft(
            measurementRevisionId: rev.id,
            quantity: 1,
            stitchingPricePaisa: 150000,
          ),
        ],
      ),
    );

    final order = (await ordersDao.getOrder(orderId))!;
    final item1 = order.items.first;
    final item2 = order.items.last;

    // Assign item1 to k1 with overdue deadline
    await karigarsDao.assignItem(
      orderItemId: item1.id,
      karigarId: k1,
      internalDeadline: DateTime.now().subtract(const Duration(days: 1)),
    );
    final assignment = (await karigarsDao.getActiveAssignment(item1.id))!;
    await karigarsDao.startWork(assignment.id);

    // item2 remains unassigned

    final report = await reportsDao.getKarigarWorkloadReport();

    expect(report.totalActiveWorkers, 2);
    expect(report.totalActiveAssignments, 1);
    expect(report.totalUnassignedItems, 1);
    expect(report.unassignedItems.first.orderItem.id, item2.id);
    expect(report.totalOverdueAssignments, 1);

    final k1Workload = report.workerWorkloads.firstWhere(
      (w) => w.karigar.id == k1,
    );
    expect(k1Workload.inProgressCount, 1);
    expect(k1Workload.overdueDeadlinesCount, 1);
    expect(k1Workload.activeAssignments, hasLength(1));

    final k2Workload = report.workerWorkloads.firstWhere(
      (w) => w.karigar.id == k2,
    );
    expect(k2Workload.activeCount, 0);
  });
}
