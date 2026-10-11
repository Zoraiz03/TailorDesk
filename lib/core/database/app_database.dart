import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().withLength(min: 1, max: 100).unique()();
  TextColumn get value => text().withDefault(const Constant(''))();
}

/// People whose orders and measurements are managed by the shop.
class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().withLength(min: 1, max: 30)();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
}

/// Stable identity for a customer's named garment measurement profile.
class MeasurementProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId =>
      integer().references(Customers, #id, onDelete: KeyAction.restrict)();
  TextColumn get garmentType => text().withLength(min: 1, max: 50)();
  TextColumn get profileName => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
}

/// Immutable snapshot of a measurement profile at a point in time.
///
/// A future order can safely reference [id] without later profile edits
/// changing the measurements used for that order.
class MeasurementRevisions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(
    MeasurementProfiles,
    #id,
    onDelete: KeyAction.restrict,
  )();
  IntColumn get revisionNumber => integer()();
  TextColumn get garmentType => text().withLength(min: 1, max: 50)();
  TextColumn get profileName => text().withLength(min: 1, max: 100)();
  TextColumn get unit => text().withLength(min: 1, max: 20)();
  TextColumn get measurementBasis => text().withLength(min: 1, max: 30)();
  TextColumn get valuesJson => text()();
  TextColumn get fitPreference => text().withLength(min: 1, max: 20)();
  TextColumn get styleInstructions => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {profileId, revisionNumber},
  ];
}

/// A customer booking. Financial totals are derived from its active lines and
/// payment ledger; they are deliberately not stored as mutable cached values.
class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get orderNumber => text().withLength(min: 1, max: 40).unique()();
  TextColumn get submissionKey =>
      text().withLength(min: 1, max: 100).unique()();
  IntColumn get customerId =>
      integer().references(Customers, #id, onDelete: KeyAction.restrict)();
  DateTimeColumn get bookingDate => dateTime()();
  DateTimeColumn get deliveryDate => dateTime()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get cancelledAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
}

/// One garment line. The measurement columns are an immutable copy of the
/// selected revision so later measurement edits cannot alter a booked order.
class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId =>
      integer().references(Orders, #id, onDelete: KeyAction.restrict)();
  IntColumn get measurementRevisionId => integer().references(
    MeasurementRevisions,
    #id,
    onDelete: KeyAction.restrict,
  )();
  TextColumn get garmentType => text().withLength(min: 1, max: 50)();
  IntColumn get quantity => integer()();
  TextColumn get measurementProfileName =>
      text().withLength(min: 1, max: 100)();
  TextColumn get measurementUnit => text().withLength(min: 1, max: 20)();
  TextColumn get measurementBasis => text().withLength(min: 1, max: 30)();
  TextColumn get measurementValuesJson => text()();
  TextColumn get fitPreference => text().withLength(min: 1, max: 20)();
  TextColumn get measurementNotes => text().withDefault(const Constant(''))();
  TextColumn get styleInstructions => text().withDefault(const Constant(''))();
  IntColumn get stitchingPricePaisa => integer()();
  IntColumn get clothChargePaisa => integer().withDefault(const Constant(0))();
  IntColumn get additionalChargePaisa =>
      integer().withDefault(const Constant(0))();
  TextColumn get additionalChargeDescription =>
      text().withDefault(const Constant(''))();
  TextColumn get status => text()
      .withLength(min: 1, max: 30)
      .withDefault(const Constant('booked'))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
}

/// Append-only order payment/refund ledger. Amounts are positive integer paisa;
/// [recordType] determines whether an entry adds to or subtracts from net paid.
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId =>
      integer().references(Orders, #id, onDelete: KeyAction.restrict)();
  IntColumn get amountPaisa => integer()();
  DateTimeColumn get paymentDate => dateTime()();
  TextColumn get method => text().withLength(min: 1, max: 30)();
  TextColumn get recordType => text().withLength(min: 1, max: 20)();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
}

/// A worker who can be assigned garment items.
///
/// Workers with assignment history are deactivated rather than deleted so
/// history is preserved. Inactive workers cannot receive new assignments.
class Karigars extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();

  /// Comma-separated garment skills, e.g. "shirt,trouser".
  TextColumn get skills => text().withDefault(const Constant(''))();

  /// 'active' or 'inactive'.
  TextColumn get status => text()
      .withLength(min: 1, max: 20)
      .withDefault(const Constant('active'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
}

/// Append-only assignment history for one order item.
///
/// A row is inserted for every assignment and reassignment, so the full
/// work history is preserved. The current active assignment for an item
/// is the row with [status] != 'cancelled' that has the latest [assignedAt].
class KarigarAssignments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderItemId =>
      integer().references(OrderItems, #id, onDelete: KeyAction.restrict)();
  IntColumn get karigarId =>
      integer().references(Karigars, #id, onDelete: KeyAction.restrict)();

  /// Internal shop deadline for this assignment (may differ from order delivery).
  DateTimeColumn get internalDeadline => dateTime().nullable()();
  TextColumn get workInstructions => text().withDefault(const Constant(''))();

  /// 'assigned', 'in_progress', 'completed', or 'cancelled'.
  TextColumn get status => text()
      .withLength(min: 1, max: 30)
      .withDefault(const Constant('assigned'))();

  /// Free-text reason recorded on reassignment or alteration return.
  TextColumn get reassignReason => text().withDefault(const Constant(''))();
  DateTimeColumn get assignedAt => dateTime()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
}

/// Central Drift database.
///
/// Run `dart run build_runner build` to generate `app_database.g.dart`.
@DriftDatabase(
  tables: [
    AppSettings,
    Customers,
    MeasurementProfiles,
    MeasurementRevisions,
    Orders,
    OrderItems,
    Payments,
    Karigars,
    KarigarAssignments,
  ],
)
class AppDatabase extends _$AppDatabase {
  static const currentSchemaVersion = 5;

  AppDatabase(super.e);

  /// Open the default on-device database.
  AppDatabase.defaults()
    : super(
        driftDatabase(
          name: 'tailor_db',
          native: const DriftNativeOptions(shareAcrossIsolates: true),
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(customers);
        }
        if (from < 3) {
          await m.createTable(measurementProfiles);
          await m.createTable(measurementRevisions);
        }
        if (from < 4) {
          await m.createTable(orders);
          await m.createTable(orderItems);
          await m.createTable(payments);
        }
        if (from < 5) {
          await m.createTable(karigars);
          await m.createTable(karigarAssignments);
        }
      },
    );
  }
}
