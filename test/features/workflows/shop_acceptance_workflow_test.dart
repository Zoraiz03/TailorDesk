import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor/core/database/app_database.dart';
import 'package:tailor/features/customers/data/customers_dao.dart';
import 'package:tailor/features/documents/order_document_service.dart';
import 'package:tailor/features/karigars/data/karigars_dao.dart';
import 'package:tailor/features/karigars/karigar_models.dart';
import 'package:tailor/features/measurements/data/measurements_dao.dart';
import 'package:tailor/features/measurements/measurement_models.dart';
import 'package:tailor/features/measurements/measurement_templates.dart';
import 'package:tailor/features/orders/data/orders_dao.dart';
import 'package:tailor/features/orders/order_models.dart';
import 'package:tailor/features/reports/data/reports_dao.dart';
import 'package:tailor/features/reports/report_models.dart';
import 'package:tailor/features/settings/backup/backup_service.dart';
import 'package:tailor/features/settings/shop_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('realistic tailor shop end-to-end workflow verification', () async {
    // ── Setup isolated database on disk for backup/restore verification ──
    final tempDir = await Directory.systemTemp.createTemp(
      'tailordesk_acceptance_workflow_',
    );
    final dbFile = File('${tempDir.path}/tailor_db.sqlite');
    var db = AppDatabase(NativeDatabase(dbFile));
    addTearDown(() async {
      await db.close();
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    var customersDao = CustomersDao(db);
    var measurementsDao = MeasurementsDao(db);
    var ordersDao = OrdersDao(db);
    var karigarsDao = KarigarsDao(db);
    var reportsDao = ReportsDao(db);
    final backupService = BackupService(databasePath: () async => dbFile.path);

    // ── Step 1: Create a customer ─────────────────────────────────────────
    final customerId = await customersDao.createCustomer(
      name: 'Chaudhry Tariq',
      phone: '03009876543',
      address: 'Mall Road, Lahore',
      notes: 'VIP customer',
    );
    expect(customerId, isPositive);

    // ── Step 2: Create measurements for two garment types ─────────────────
    // Garment 1: Shalwar Qameez
    final sqProfileId = await measurementsDao.createProfile(
      MeasurementDraft(
        customerId: customerId,
        garmentType: GarmentType.shalwarQameez,
        profileName: 'Eid Shalwar Qameez',
        unit: MeasurementUnit.inches,
        basis: MeasurementBasis.body,
        values: const {
          'kameez_length': 40,
          'shoulder': 18.5,
          'sleeve': 24.5,
          'collar': 16,
          'chest': 42,
          'waist': 38,
          'hip': 44,
          'shalwar_length': 39,
          'ankle_opening': 8.5,
        },
        fitPreference: FitPreference.regular,
        styleInstructions: 'Ban collar, front pocket',
      ),
    );
    final sqRevision = (await measurementsDao.getProfile(
      sqProfileId,
    ))!.latestRevision;

    // Garment 2: Waistcoat
    final wcProfileId = await measurementsDao.createProfile(
      MeasurementDraft(
        customerId: customerId,
        garmentType: GarmentType.waistcoat,
        profileName: 'Festive Waistcoat',
        unit: MeasurementUnit.inches,
        basis: MeasurementBasis.body,
        values: const {
          'length': 27,
          'shoulder': 17.5,
          'chest': 42,
          'waist': 39,
        },
        fitPreference: FitPreference.slim,
        styleInstructions: 'Mandarin collar, 5 brass buttons',
      ),
    );
    final wcRevision = (await measurementsDao.getProfile(
      wcProfileId,
    ))!.latestRevision;

    // ── Step 3 & 4: Book an order containing both garments with advance ────
    final orderId = await ordersDao.createOrder(
      NewOrderDraft(
        submissionKey: 'workflow-order-001',
        customerId: customerId,
        bookingDate: DateTime(2026, 10, 12),
        deliveryDate: DateTime(2026, 10, 20),
        lines: [
          OrderLineDraft(
            measurementRevisionId: sqRevision.id,
            quantity: 1,
            stitchingPricePaisa: 250000, // PKR 2,500
            clothChargePaisa: 150000, // PKR 1,500
            styleInstructions: 'Ban collar, front pocket',
          ),
          OrderLineDraft(
            measurementRevisionId: wcRevision.id,
            quantity: 1,
            stitchingPricePaisa: 180000, // PKR 1,800
            additionalChargePaisa: 20000, // PKR 200
            additionalChargeDescription: 'Brass buttons',
          ),
        ],
        advancePaisa: 200000, // Advance: PKR 2,000
        advanceMethod: PaymentMethod.cash,
      ),
    );

    var order = (await ordersDao.getOrder(orderId))!;
    expect(order.items, hasLength(2));
    // Line 1: 2,500 + 1,500 = 4,000 PKR = 400,000 paisa
    // Line 2: 1,800 + 200 = 2,000 PKR = 200,000 paisa
    // Total: 6,000 PKR = 600,000 paisa
    // Net paid: 2,000 PKR = 200,000 paisa
    // Balance: 4,000 PKR = 400,000 paisa
    expect(order.totalPaisa, 600000);
    expect(order.netPaidPaisa, 200000);
    expect(order.balancePaisa, 400000);
    expect(order.progress, OrderProgress.booked);

    final sqItem = order.items.firstWhere(
      (i) => i.garmentType == GarmentType.shalwarQameez.storageKey,
    );
    final wcItem = order.items.firstWhere(
      (i) => i.garmentType == GarmentType.waistcoat.storageKey,
    );

    // ── Step 5: Assign work to two karigars ────────────────────────────────
    final karigarA = await karigarsDao.createKarigar(
      name: 'Master Rasheed',
      skills: 'shalwar_qameez',
    );
    final karigarB = await karigarsDao.createKarigar(
      name: 'Ustad Jamil',
      skills: 'waistcoat',
    );

    await karigarsDao.assignItem(
      orderItemId: sqItem.id,
      karigarId: karigarA,
      internalDeadline: DateTime(2026, 10, 18),
    );
    await karigarsDao.assignItem(
      orderItemId: wcItem.id,
      karigarId: karigarB,
      internalDeadline: DateTime(2026, 10, 19),
    );

    // ── Step 6: Reassign one item with a reason ───────────────────────────
    // Reassign waistcoat from karigarB to a third karigar or karigarA
    final karigarC = await karigarsDao.createKarigar(
      name: 'Master Aslam',
      skills: 'waistcoat,coat',
    );
    await karigarsDao.assignItem(
      orderItemId: wcItem.id,
      karigarId: karigarC,
      internalDeadline: DateTime(2026, 10, 19),
      reassignReason: 'Ustad Jamil on medical leave',
    );

    final wcHistory = await karigarsDao.getAssignments(orderItemId: wcItem.id);
    expect(wcHistory, hasLength(2));
    final previousAssignment = wcHistory.firstWhere((a) => !a.isActive);
    expect(previousAssignment.assignment.karigarId, karigarB);
    expect(
      previousAssignment.assignment.reassignReason,
      'Ustad Jamil on medical leave',
    );
    final activeWcAssignment = wcHistory.firstWhere((a) => a.isActive);
    expect(activeWcAssignment.assignment.karigarId, karigarC);

    // ── Step 7 & 8: Complete one item and deliver it (partial delivery) ─────
    final sqActiveAssignment = (await karigarsDao.getActiveAssignment(
      sqItem.id,
    ))!;
    await karigarsDao.startWork(sqActiveAssignment.id);
    await karigarsDao.completeWork(sqActiveAssignment.id);

    // Deliver Shalwar Qameez while balance is still outstanding!
    await ordersDao.updateItemStatus(sqItem.id, OrderItemStatus.delivered);

    order = (await ordersDao.getOrder(orderId))!;
    expect(order.progress, OrderProgress.partiallyDelivered);
    expect(order.balancePaisa, 400000); // PKR 4,000 still due!

    // ── Step 9 & 10: Complete other item, record remaining payment, deliver ─
    final wcActiveAssignment = (await karigarsDao.getActiveAssignment(
      wcItem.id,
    ))!;
    await karigarsDao.startWork(wcActiveAssignment.id);
    await karigarsDao.completeWork(wcActiveAssignment.id);

    // Record remaining payment of PKR 4,000 (400,000 paisa)
    await ordersDao.addLedgerEntry(
      orderId: orderId,
      amountPaisa: 400000,
      type: PaymentRecordType.payment,
      method: PaymentMethod.cash,
      date: DateTime(2026, 10, 20),
      notes: 'Final settlement on delivery',
    );

    // Deliver second item
    await ordersDao.updateItemStatus(wcItem.id, OrderItemStatus.delivered);

    order = (await ordersDao.getOrder(orderId))!;
    expect(order.balancePaisa, 0);
    expect(order.netPaidPaisa, 600000);
    expect(order.progress, OrderProgress.delivered);

    // ── Step 11: Generate receipts and work slips ─────────────────────────
    final docService = OrderDocumentService();
    final regularFont = await rootBundle.load(
      'assets/fonts/Roboto-Regular.ttf',
    );
    final mediumFont = await rootBundle.load('assets/fonts/Roboto-Medium.ttf');
    const shop = ShopDetails(
      name: 'Lahore Royal Tailors',
      phone: '042-35712345',
      address: 'Mall Road, Lahore',
      receiptFooter: 'Thank you for choosing Royal Tailors.',
    );

    // Generate Customer Receipt
    final receiptDoc = await docService.generateWithFonts(
      kind: OrderDocumentKind.customerReceipt,
      shop: shop,
      order: order,
      regularFont: regularFont,
      mediumFont: mediumFont,
    );
    expect(receiptDoc.bytes, isNotEmpty);
    expect(receiptDoc.auditText, contains('Order total PKR 6,000'));
    expect(receiptDoc.auditText, contains('Net paid PKR 6,000'));
    expect(receiptDoc.auditText, contains('Balance PKR 0'));
    expect(receiptDoc.auditText, contains('Chaudhry Tariq'));
    expect(receiptDoc.auditText, contains('Shalwar Qameez × 1'));
    expect(receiptDoc.auditText, contains('Waistcoat × 1'));

    // Generate Karigar Work Slip for Shalwar Qameez
    final sqAssignmentRecord = (await karigarsDao.getAssignments(
      orderItemId: sqItem.id,
    )).firstWhere((a) => a.karigar.id == karigarA);
    final karigarDoc = await docService.generateWithFonts(
      kind: OrderDocumentKind.karigarSlip,
      shop: shop,
      order: order,
      assignment: sqAssignmentRecord,
      regularFont: regularFont,
      mediumFont: mediumFont,
    );
    expect(karigarDoc.bytes, isNotEmpty);
    expect(karigarDoc.auditText, contains('KARIGAR WORK SLIP'));
    expect(karigarDoc.auditText, contains('Master Rasheed'));
    expect(karigarDoc.auditText, contains('Shalwar Qameez × 1'));
    expect(karigarDoc.auditText, contains('Kameez length 40.0 in'));
    // Must NOT contain financial information!
    expect(karigarDoc.auditText, isNot(contains('PKR')));
    expect(karigarDoc.auditText, isNot(contains('Order total')));
    expect(karigarDoc.auditText, isNot(contains('Balance')));
    expect(karigarDoc.auditText, isNot(contains('Net paid')));

    // ── Step 12 & 13: Change customer's latest measurements ────────────────
    // Update Shalwar Qameez measurements with totally new values
    await measurementsDao.createRevision(
      profileId: sqProfileId,
      draft: MeasurementDraft(
        customerId: customerId,
        garmentType: GarmentType.shalwarQameez,
        profileName: 'Eid Shalwar Qameez',
        unit: MeasurementUnit.inches,
        basis: MeasurementBasis.body,
        values: const {
          'kameez_length': 48, // Changed from 40 to 48
          'shoulder': 20, // Changed from 18.5 to 20
          'sleeve': 26,
          'collar': 17,
          'chest': 46,
          'waist': 42,
          'hip': 48,
          'shalwar_length': 42,
          'ankle_opening': 9,
        },
        fitPreference: FitPreference.loose,
        styleInstructions: 'Double cuff revision',
      ),
    );

    // Verify booked order's measurements REMAIN COMPLETELY UNCHANGED
    final freshOrder = (await ordersDao.getOrder(orderId))!;
    final freshSqItem = freshOrder.items.firstWhere(
      (i) => i.garmentType == GarmentType.shalwarQameez.storageKey,
    );
    expect(freshSqItem.measurementValuesJson, contains('40.0'));
    expect(freshSqItem.measurementValuesJson, isNot(contains('48.0')));
    expect(freshSqItem.styleInstructions, contains('Ban collar, front pocket'));
    expect(freshSqItem.fitPreference, 'regular');

    // ── Step 14: Verify refund and cancellation rules ─────────────────────
    // Cannot cancel a delivered order
    expect(
      () => ordersDao.cancelOrder(orderId),
      throwsA(isA<DeliveredOrderCancellationException>()),
    );

    // Test cancellation rule on a separate non-delivered order
    final testCancelOrderId = await ordersDao.createOrder(
      NewOrderDraft(
        submissionKey: 'test-cancellation-order',
        customerId: customerId,
        bookingDate: DateTime(2026, 10, 12),
        deliveryDate: DateTime(2026, 10, 25),
        lines: [
          OrderLineDraft(
            measurementRevisionId: sqRevision.id,
            quantity: 1,
            stitchingPricePaisa: 100000,
          ),
        ],
        advancePaisa: 50000, // Paid 500 advance
      ),
    );

    // Cancelling while net paid > 0 must throw RefundRequiredBeforeCancellationException
    expect(
      () => ordersDao.cancelOrder(testCancelOrderId),
      throwsA(isA<RefundRequiredBeforeCancellationException>()),
    );

    // Explicitly refund the advance
    await ordersDao.addLedgerEntry(
      orderId: testCancelOrderId,
      amountPaisa: 50000,
      type: PaymentRecordType.refund,
      method: PaymentMethod.cash,
      date: DateTime(2026, 10, 12),
      notes: 'Full refund before cancellation',
    );

    // Now cancellation succeeds
    await ordersDao.cancelOrder(testCancelOrderId);
    final cancelledOrder = (await ordersDao.getOrder(testCancelOrderId))!;
    expect(cancelledOrder.progress, OrderProgress.cancelled);

    // ── Step 15: Confirm dashboard and reports match recorded data ────────
    final dashboard = await ordersDao.watchDashboard().first;
    expect(dashboard.activeOrders, 0); // Delivered & cancelled orders excluded
    expect(dashboard.outstandingPaisa, 0);

    final dueReport = await reportsDao.getDueOrdersReport();
    expect(dueReport.totalDueCount, 0);

    final balanceReport = await reportsDao.getCustomerBalancesReport();
    expect(balanceReport.totalOutstandingPaisa, 0);

    final collectionsReport = await reportsDao.getCollectionsReport(
      period: CollectionsPeriod.allTime,
    );
    // Order 1: Advance 2,000 + Settlement 4,000 = 6,000 PKR
    // Order 2: Advance 500 - Refund 500 = 0 PKR
    // Gross: 6,500 PKR = 650,000 paisa
    // Refunds: 500 PKR = 50,000 paisa
    // Net Collections: 6,000 PKR = 600,000 paisa
    expect(collectionsReport.grossCollectionsPaisa, 650000);
    expect(collectionsReport.totalRefundsPaisa, 50000);
    expect(collectionsReport.netCollectionsPaisa, 600000);
    expect(collectionsReport.paymentCount, 3);
    expect(collectionsReport.refundCount, 1);

    final workloadReport = await reportsDao.getKarigarWorkloadReport();
    expect(workloadReport.totalActiveWorkers, 3);
    expect(workloadReport.totalUnassignedItems, 0);

    // ── Step 16: Export a backup ──────────────────────────────────────────
    final backupArchive = await backupService.createBackup(db);
    expect(backupArchive, isNotEmpty);
    final validation = await backupService.validate(backupArchive);
    expect(validation.sourceSchemaVersion, AppDatabase.currentSchemaVersion);

    // ── Step 17: Restore into an isolated database and compare records ────
    final restoreSafetyPath = await backupService.restore(db, backupArchive);
    expect(await File(restoreSafetyPath).exists(), isTrue);

    // Open restored database and compare records
    final restoredDb = AppDatabase(NativeDatabase(dbFile));
    db = restoredDb;
    final restoredCustomers = CustomersDao(restoredDb);
    final restoredOrders = OrdersDao(restoredDb);
    final restoredKarigars = KarigarsDao(restoredDb);
    final restoredMeasurements = MeasurementsDao(restoredDb);

    final restoredCustomer = await restoredCustomers.getById(customerId);
    expect(restoredCustomer, isNotNull);
    expect(restoredCustomer!.name, 'Chaudhry Tariq');

    final restoredOrder = (await restoredOrders.getOrder(orderId))!;
    expect(restoredOrder.order.orderNumber, order.order.orderNumber);
    expect(restoredOrder.totalPaisa, 600000);
    expect(restoredOrder.netPaidPaisa, 600000);
    expect(restoredOrder.balancePaisa, 0);
    expect(restoredOrder.items, hasLength(2));

    // Frozen measurements preserved in restored database
    final restoredSq = restoredOrder.items.firstWhere(
      (i) => i.garmentType == GarmentType.shalwarQameez.storageKey,
    );
    expect(restoredSq.measurementValuesJson, contains('40.0'));

    // Karigar assignment history preserved in restored database
    final restoredWcHistory = await restoredKarigars.getAssignments(
      orderItemId: wcItem.id,
    );
    expect(restoredWcHistory, hasLength(2));
    expect(
      restoredWcHistory
          .firstWhere((a) => a.status == AssignmentStatus.cancelled)
          .assignment
          .reassignReason,
      'Ustad Jamil on medical leave',
    );

    // Customer measurement revision history preserved
    final restoredProfiles = await restoredMeasurements
        .watchForCustomer(customerId)
        .first;
    expect(restoredProfiles, hasLength(2));
  });
}
