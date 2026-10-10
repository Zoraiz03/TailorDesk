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

/// Central Drift database.
///
/// Run `dart run build_runner build` to generate `app_database.g.dart`.
@DriftDatabase(tables: [AppSettings, Customers])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Open the default on-device database.
  AppDatabase.defaults()
    : super(
        driftDatabase(
          name: 'tailor_db',
          native: const DriftNativeOptions(shareAcrossIsolates: true),
        ),
      );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(customers);
        }
      },
    );
  }
}
