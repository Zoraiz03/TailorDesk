// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'karigars_dao.dart';

// ignore_for_file: type=lint
mixin _$KarigarsDaoMixin on DatabaseAccessor<AppDatabase> {
  $KarigarsTable get karigars => attachedDatabase.karigars;
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
  $KarigarAssignmentsTable get karigarAssignments =>
      attachedDatabase.karigarAssignments;
  KarigarsDaoManager get managers => KarigarsDaoManager(this);
}

class KarigarsDaoManager {
  final _$KarigarsDaoMixin _db;
  KarigarsDaoManager(this._db);
  $$KarigarsTableTableManager get karigars =>
      $$KarigarsTableTableManager(_db.attachedDatabase, _db.karigars);
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
  $$KarigarAssignmentsTableTableManager get karigarAssignments =>
      $$KarigarAssignmentsTableTableManager(
        _db.attachedDatabase,
        _db.karigarAssignments,
      );
}
