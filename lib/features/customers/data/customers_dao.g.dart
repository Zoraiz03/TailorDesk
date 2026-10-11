// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_dao.dart';

// ignore_for_file: type=lint
mixin _$CustomersDaoMixin on DatabaseAccessor<AppDatabase> {
  $CustomersTable get customers => attachedDatabase.customers;
  $MeasurementProfilesTable get measurementProfiles =>
      attachedDatabase.measurementProfiles;
  $OrdersTable get orders => attachedDatabase.orders;
  CustomersDaoManager get managers => CustomersDaoManager(this);
}

class CustomersDaoManager {
  final _$CustomersDaoMixin _db;
  CustomersDaoManager(this._db);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db.attachedDatabase, _db.customers);
  $$MeasurementProfilesTableTableManager get measurementProfiles =>
      $$MeasurementProfilesTableTableManager(
        _db.attachedDatabase,
        _db.measurementProfiles,
      );
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db.attachedDatabase, _db.orders);
}
