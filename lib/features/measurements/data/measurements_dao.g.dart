// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurements_dao.dart';

// ignore_for_file: type=lint
mixin _$MeasurementsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CustomersTable get customers => attachedDatabase.customers;
  $MeasurementProfilesTable get measurementProfiles =>
      attachedDatabase.measurementProfiles;
  $MeasurementRevisionsTable get measurementRevisions =>
      attachedDatabase.measurementRevisions;
  MeasurementsDaoManager get managers => MeasurementsDaoManager(this);
}

class MeasurementsDaoManager {
  final _$MeasurementsDaoMixin _db;
  MeasurementsDaoManager(this._db);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db.attachedDatabase, _db.customers);
  $$MeasurementProfilesTableTableManager get measurementProfiles =>
      $$MeasurementProfilesTableTableManager(
        _db.attachedDatabase,
        _db.measurementProfiles,
      );
  $$MeasurementRevisionsTableTableManager get measurementRevisions =>
      $$MeasurementRevisionsTableTableManager(
        _db.attachedDatabase,
        _db.measurementRevisions,
      );
}
