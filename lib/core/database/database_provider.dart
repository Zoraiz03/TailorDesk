import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

/// Global provider for the Drift database instance.
///
/// Uses the default constructor that opens the on-device SQLite file.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.defaults();
  ref.onDispose(() => db.close());
  return db;
});
