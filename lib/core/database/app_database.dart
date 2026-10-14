import 'dart:convert';

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
  TextColumn get garmentLabelEnglish =>
      text().withDefault(const Constant(''))();
  TextColumn get garmentLabelUrdu => text().withDefault(const Constant(''))();
  TextColumn get profileName => text().withLength(min: 1, max: 100)();
  TextColumn get unit => text().withLength(min: 1, max: 20)();
  TextColumn get measurementBasis => text().withLength(min: 1, max: 30)();
  TextColumn get valuesJson => text()();
  IntColumn get templateVersionId => integer().nullable().references(
    MeasurementTemplateVersions,
    #id,
    onDelete: KeyAction.restrict,
  )();
  TextColumn get fieldDefinitionsJson =>
      text().withDefault(const Constant(''))();
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
  TextColumn get garmentLabelEnglish =>
      text().withDefault(const Constant(''))();
  TextColumn get garmentLabelUrdu => text().withDefault(const Constant(''))();
  IntColumn get quantity => integer()();
  TextColumn get measurementProfileName =>
      text().withLength(min: 1, max: 100)();
  TextColumn get measurementUnit => text().withLength(min: 1, max: 20)();
  TextColumn get measurementBasis => text().withLength(min: 1, max: 30)();
  TextColumn get measurementValuesJson => text()();
  TextColumn get measurementFieldDefinitionsJson =>
      text().withDefault(const Constant(''))();
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

/// Shop-controlled garment list. Built-in and custom garments use stable text
/// identifiers so persisted records never depend on Dart enum indexes.
class GarmentCatalogEntries extends Table {
  TextColumn get garmentId => text().withLength(min: 1, max: 80)();
  TextColumn get displayName => text().withLength(min: 1, max: 100)();
  TextColumn get displayNameUrdu =>
      text().withLength(min: 1, max: 100).nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get displayOrder => integer()();
  IntColumn get defaultStitchingPricePaisa =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column<Object>> get primaryKey => {garmentId};
}

/// Immutable template header. Editing a template creates a new version.
class MeasurementTemplateVersions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get garmentId => text().references(
    GarmentCatalogEntries,
    #garmentId,
    onDelete: KeyAction.restrict,
  )();
  IntColumn get versionNumber => integer()();
  TextColumn get measurementConvention => text().withLength(min: 1, max: 30)();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {garmentId, versionNumber},
  ];
}

/// Field definitions belonging to one immutable template version. Fields are
/// archived in later versions rather than removed from historical snapshots.
class MeasurementTemplateFields extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get templateVersionId => integer().references(
    MeasurementTemplateVersions,
    #id,
    onDelete: KeyAction.restrict,
  )();
  TextColumn get fieldId => text().withLength(min: 1, max: 80)();
  TextColumn get displayLabel => text().withLength(min: 1, max: 100)();
  TextColumn get displayLabelUrdu =>
      text().withLength(min: 1, max: 100).nullable()();
  IntColumn get displayOrder => integer()();
  BoolColumn get isRequired => boolean()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {templateVersionId, fieldId},
  ];
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
    GarmentCatalogEntries,
    MeasurementTemplateVersions,
    MeasurementTemplateFields,
  ],
)
class AppDatabase extends _$AppDatabase {
  static const currentSchemaVersion = 7;

  AppDatabase(super.e, {bool businessWritesAllowed = true})
    : _businessWritesAllowed = businessWritesAllowed;

  bool _businessWritesAllowed;

  bool get businessWritesAllowed => _businessWritesAllowed;

  void setBusinessWritesAllowed(bool value) {
    _businessWritesAllowed = value;
  }

  void requireBusinessWrite() {
    // Business writes are always allowed.
  }

  /// Open the default on-device database.
  AppDatabase.defaults()
    : _businessWritesAllowed = true,
      super(
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
        await _seedStage9Configuration(existingInstallation: false);
        await _seedUrduLabels();
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
        if (from < 6) {
          await m.createTable(garmentCatalogEntries);
          await m.createTable(measurementTemplateVersions);
          await m.createTable(measurementTemplateFields);
          if (from >= 3) {
            await m.addColumn(
              measurementRevisions,
              measurementRevisions.templateVersionId,
            );
            await m.addColumn(
              measurementRevisions,
              measurementRevisions.fieldDefinitionsJson,
            );
          }
          if (from >= 4) {
            await m.addColumn(
              orderItems,
              orderItems.measurementFieldDefinitionsJson,
            );
          }
          await _seedStage9Configuration(existingInstallation: true);
        }
        if (from < 7) {
          if (from >= 6) {
            await m.addColumn(
              garmentCatalogEntries,
              garmentCatalogEntries.displayNameUrdu,
            );
            await m.addColumn(
              measurementTemplateFields,
              measurementTemplateFields.displayLabelUrdu,
            );
          }
          if (from >= 3) {
            await m.addColumn(
              measurementRevisions,
              measurementRevisions.garmentLabelEnglish,
            );
            await m.addColumn(
              measurementRevisions,
              measurementRevisions.garmentLabelUrdu,
            );
          }
          if (from >= 4) {
            await m.addColumn(orderItems, orderItems.garmentLabelEnglish);
            await m.addColumn(orderItems, orderItems.garmentLabelUrdu);
          }
          await _seedUrduLabels();
        }
      },
    );
  }

  Future<void> _seedStage9Configuration({
    required bool existingInstallation,
  }) async {
    const templates = <String, (String, List<(String, String, bool)>)>{
      'shalwar_qameez': (
        'Shalwar Qameez',
        [
          ('kameez_length', 'Kameez length', true),
          ('shoulder', 'Shoulder', true),
          ('sleeve', 'Sleeve', true),
          ('collar', 'Collar', false),
          ('chest', 'Chest', true),
          ('waist', 'Waist', true),
          ('hip', 'Hip', true),
          ('shalwar_length', 'Shalwar length', true),
          ('ankle_opening', 'Ankle opening', false),
        ],
      ),
      'coat': (
        'Coat',
        [
          ('length', 'Length', true),
          ('shoulder', 'Shoulder', true),
          ('sleeve', 'Sleeve', true),
          ('chest', 'Chest', true),
          ('waist', 'Waist', true),
          ('hip', 'Hip', false),
        ],
      ),
      'trouser': (
        'Trouser/Pant',
        [
          ('waist', 'Waist', true),
          ('hip', 'Hip', true),
          ('outseam', 'Outseam', true),
          ('inseam', 'Inseam', false),
          ('thigh', 'Thigh', false),
          ('knee', 'Knee', false),
          ('ankle_opening', 'Ankle opening', false),
        ],
      ),
      'shirt': (
        'Shirt',
        [
          ('length', 'Length', true),
          ('shoulder', 'Shoulder', true),
          ('sleeve', 'Sleeve', true),
          ('collar', 'Collar', false),
          ('chest', 'Chest', true),
          ('waist', 'Waist', true),
          ('cuff', 'Cuff', false),
        ],
      ),
      'waistcoat': (
        'Waistcoat',
        [
          ('length', 'Length', true),
          ('shoulder', 'Shoulder', true),
          ('chest', 'Chest', true),
          ('waist', 'Waist', true),
          ('hip', 'Hip', false),
        ],
      ),
      'jacket': (
        'Jacket',
        [
          ('length', 'Length', true),
          ('shoulder', 'Shoulder', true),
          ('sleeve', 'Sleeve', true),
          ('chest', 'Chest', true),
          ('waist', 'Waist', true),
          ('hip', 'Hip', false),
        ],
      ),
      'kurta': (
        'Kurta',
        [
          ('length', 'Length', true),
          ('shoulder', 'Shoulder', true),
          ('sleeve', 'Sleeve', true),
          ('chest', 'Chest', true),
          ('waist', 'Waist', true),
        ],
      ),
      'sherwani': (
        'Sherwani',
        [
          ('length', 'Length', true),
          ('shoulder', 'Shoulder', true),
          ('sleeve', 'Sleeve', true),
          ('chest', 'Chest', true),
          ('waist', 'Waist', true),
          ('hip', 'Hip', false),
        ],
      ),
    };
    var order = 0;
    for (final entry in templates.entries) {
      await into(garmentCatalogEntries).insert(
        GarmentCatalogEntriesCompanion.insert(
          garmentId: entry.key,
          displayName: entry.value.$1,
          displayOrder: order++,
        ),
        mode: InsertMode.insertOrIgnore,
      );
      final existing =
          await (select(measurementTemplateVersions)
                ..where((row) => row.garmentId.equals(entry.key))
                ..limit(1))
              .getSingleOrNull();
      if (existing != null) continue;
      final versionId = await into(measurementTemplateVersions).insert(
        MeasurementTemplateVersionsCompanion.insert(
          garmentId: entry.key,
          versionNumber: 1,
          measurementConvention: 'body',
        ),
      );
      for (final indexed in entry.value.$2.indexed) {
        final field = indexed.$2;
        await into(measurementTemplateFields).insert(
          MeasurementTemplateFieldsCompanion.insert(
            templateVersionId: versionId,
            fieldId: field.$1,
            displayLabel: field.$2,
            displayOrder: indexed.$1,
            isRequired: field.$3,
          ),
        );
      }
      if (existingInstallation) {
        final definitions = jsonEncode([
          for (final indexed in entry.value.$2.indexed)
            <String, Object>{
              'id': indexed.$2.$1,
              'label': indexed.$2.$2,
              'order': indexed.$1,
              'required': indexed.$2.$3,
              'archived': false,
            },
        ]);
        await customStatement(
          'UPDATE measurement_revisions '
          'SET field_definitions_json = ? '
          "WHERE garment_type = ? AND field_definitions_json = ''",
          [definitions, entry.key],
        );
        await customStatement(
          'UPDATE order_items '
          'SET measurement_field_definitions_json = ? '
          "WHERE garment_type = ? AND measurement_field_definitions_json = ''",
          [definitions, entry.key],
        );
      }
    }
    if (existingInstallation) {
      await into(appSettings).insert(
        AppSettingsCompanion.insert(
          key: 'setup_completed',
          value: const Value('true'),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  Future<void> _seedUrduLabels() async {
    const garments = <String, String>{
      'shalwar_qameez': 'شلوار قمیض',
      'coat': 'کوٹ',
      'trouser': 'پتلون',
      'shirt': 'شرٹ',
      'waistcoat': 'واسکٹ',
      'jacket': 'جیکٹ',
      'kurta': 'کرتا',
      'sherwani': 'شیروانی',
    };
    const fields = <String, String>{
      'kameez_length': 'قمیض لمبائی',
      'length': 'لمبائی',
      'shoulder': 'تیرا',
      'sleeve': 'آستین',
      'collar': 'کالر',
      'chest': 'چھاتی',
      'waist': 'کمر',
      'hip': 'کولہا',
      'shalwar_length': 'شلوار لمبائی',
      'ankle_opening': 'پائنچہ',
      'outseam': 'بیرونی لمبائی',
      'inseam': 'اندرونی لمبائی',
      'thigh': 'ران',
      'knee': 'گھٹنا',
      'cuff': 'کف',
    };
    for (final entry in garments.entries) {
      await customStatement(
        'UPDATE garment_catalog_entries SET display_name_urdu = ? '
        'WHERE garment_id = ? AND display_name_urdu IS NULL',
        [entry.value, entry.key],
      );
    }
    for (final entry in fields.entries) {
      await customStatement(
        'UPDATE measurement_template_fields SET display_label_urdu = ? '
        'WHERE field_id = ? AND display_label_urdu IS NULL',
        [entry.value, entry.key],
      );
    }
  }
}

class ActivationRequiredException implements Exception {
  const ActivationRequiredException();

  @override
  String toString() =>
      'A valid license for this installation is required to change business data.';
}
