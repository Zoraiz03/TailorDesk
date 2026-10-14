// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_dao.dart';

// ignore_for_file: type=lint
mixin _$OrdersDaoMixin on DatabaseAccessor<AppDatabase> {
  $CustomersTable get customers => attachedDatabase.customers;
  $OrdersTable get orders => attachedDatabase.orders;
  $MeasurementProfilesTable get measurementProfiles =>
      attachedDatabase.measurementProfiles;
  $GarmentCatalogEntriesTable get garmentCatalogEntries =>
      attachedDatabase.garmentCatalogEntries;
  $MeasurementTemplateVersionsTable get measurementTemplateVersions =>
      attachedDatabase.measurementTemplateVersions;
  $MeasurementRevisionsTable get measurementRevisions =>
      attachedDatabase.measurementRevisions;
  $OrderItemsTable get orderItems => attachedDatabase.orderItems;
  $PaymentsTable get payments => attachedDatabase.payments;
  $KarigarsTable get karigars => attachedDatabase.karigars;
  $KarigarAssignmentsTable get karigarAssignments =>
      attachedDatabase.karigarAssignments;
  OrdersDaoManager get managers => OrdersDaoManager(this);
}

class OrdersDaoManager {
  final _$OrdersDaoMixin _db;
  OrdersDaoManager(this._db);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db.attachedDatabase, _db.customers);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db.attachedDatabase, _db.orders);
  $$MeasurementProfilesTableTableManager get measurementProfiles =>
      $$MeasurementProfilesTableTableManager(
        _db.attachedDatabase,
        _db.measurementProfiles,
      );
  $$GarmentCatalogEntriesTableTableManager get garmentCatalogEntries =>
      $$GarmentCatalogEntriesTableTableManager(
        _db.attachedDatabase,
        _db.garmentCatalogEntries,
      );
  $$MeasurementTemplateVersionsTableTableManager
  get measurementTemplateVersions =>
      $$MeasurementTemplateVersionsTableTableManager(
        _db.attachedDatabase,
        _db.measurementTemplateVersions,
      );
  $$MeasurementRevisionsTableTableManager get measurementRevisions =>
      $$MeasurementRevisionsTableTableManager(
        _db.attachedDatabase,
        _db.measurementRevisions,
      );
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db.attachedDatabase, _db.orderItems);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db.attachedDatabase, _db.payments);
  $$KarigarsTableTableManager get karigars =>
      $$KarigarsTableTableManager(_db.attachedDatabase, _db.karigars);
  $$KarigarAssignmentsTableTableManager get karigarAssignments =>
      $$KarigarAssignmentsTableTableManager(
        _db.attachedDatabase,
        _db.karigarAssignments,
      );
}
