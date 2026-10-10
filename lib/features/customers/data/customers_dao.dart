import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

part 'customers_dao.g.dart';

@DriftAccessor(tables: [Customers])
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

  Future<int> createCustomer({
    required String name,
    required String phone,
    String address = '',
    String notes = '',
  }) {
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
    return (delete(
      customers,
    )..where((customer) => customer.id.equals(id))).go();
  }
}
