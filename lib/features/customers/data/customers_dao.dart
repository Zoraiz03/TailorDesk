import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

part 'customers_dao.g.dart';

class CustomerHasMeasurementsException implements Exception {
  const CustomerHasMeasurementsException();
}

@DriftAccessor(tables: [Customers, MeasurementProfiles, Orders])
class CustomersDao extends DatabaseAccessor<AppDatabase>
    with _$CustomersDaoMixin {
  CustomersDao(super.attachedDatabase);

  Stream<List<Customer>> watchAll() {
    return (select(customers)..orderBy([
          (customer) => OrderingTerm.desc(customer.updatedAt),
          (customer) => OrderingTerm.asc(customer.name),
        ]))
        .watch();
  }

  Stream<Customer?> watchById(int id) {
    return (select(
      customers,
    )..where((customer) => customer.id.equals(id))).watchSingleOrNull();
  }

  Future<Customer?> getById(int id) {
    return (select(
      customers,
    )..where((customer) => customer.id.equals(id))).getSingleOrNull();
  }

  Future<bool> hasMeasurementProfiles(int customerId) async {
    final profile =
        await (select(measurementProfiles)
              ..where((row) => row.customerId.equals(customerId))
              ..limit(1))
            .getSingleOrNull();
    return profile != null;
  }

  Future<bool> hasProtectedRecords(int customerId) async {
    if (await hasMeasurementProfiles(customerId)) return true;
    final order =
        await (select(orders)
              ..where((row) => row.customerId.equals(customerId))
              ..limit(1))
            .getSingleOrNull();
    return order != null;
  }

  Future<int> createCustomer({
    required String name,
    required String phone,
    String address = '',
    String notes = '',
  }) {
    attachedDatabase.requireBusinessWrite();
    final now = DateTime.now();
    return into(customers).insert(
      CustomersCompanion.insert(
        name: name.trim(),
        phone: phone.trim(),
        address: Value(address.trim()),
        notes: Value(notes.trim()),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<int> updateCustomer({
    required int id,
    required String name,
    required String phone,
    String address = '',
    String notes = '',
  }) {
    attachedDatabase.requireBusinessWrite();
    return (update(
      customers,
    )..where((customer) => customer.id.equals(id))).write(
      CustomersCompanion(
        name: Value(name.trim()),
        phone: Value(phone.trim()),
        address: Value(address.trim()),
        notes: Value(notes.trim()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteCustomer(int id) {
    attachedDatabase.requireBusinessWrite();
    return transaction(() async {
      final linkedProfile =
          await (select(measurementProfiles)
                ..where((profile) => profile.customerId.equals(id))
                ..limit(1))
              .getSingleOrNull();
      if (linkedProfile != null) {
        throw const CustomerHasMeasurementsException();
      }
      final linkedOrder =
          await (select(orders)
                ..where((order) => order.customerId.equals(id))
                ..limit(1))
              .getSingleOrNull();
      if (linkedOrder != null) {
        throw const CustomerHasMeasurementsException();
      }
      return (delete(
        customers,
      )..where((customer) => customer.id.equals(id))).go();
    });
  }
}
