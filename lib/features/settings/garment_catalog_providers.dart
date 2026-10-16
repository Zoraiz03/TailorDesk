import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import 'garment_catalog.dart';

class GarmentCatalogRepository {
  GarmentCatalogRepository(this.database);

  final AppDatabase database;

  Stream<List<GarmentCatalogRecord>> watchCatalog({bool enabledOnly = false}) {
    return database
        .customSelect(
          'SELECT 1 AS token',
          readsFrom: {
            database.garmentCatalogEntries,
            database.measurementTemplateVersions,
            database.measurementTemplateFields,
          },
        )
        .watchSingle()
        .asyncMap((_) => getCatalog(enabledOnly: enabledOnly));
  }

  Future<List<GarmentCatalogRecord>> getCatalog({
    bool enabledOnly = false,
  }) async {
    final entriesQuery = database.select(database.garmentCatalogEntries)
      ..orderBy([(row) => OrderingTerm.asc(row.displayOrder)]);
    if (enabledOnly) {
      entriesQuery.where((row) => row.enabled.equals(true));
    }
    final entries = await entriesQuery.get();
    return Future.wait(entries.map(_recordFor));
  }

  Future<GarmentCatalogRecord?> getById(String garmentId) async {
    final entry = await (database.select(
      database.garmentCatalogEntries,
    )..where((row) => row.garmentId.equals(garmentId))).getSingleOrNull();
    return entry == null ? null : _recordFor(entry);
  }

  Future<GarmentCatalogRecord> _recordFor(GarmentCatalogEntry entry) async {
    final version =
        await (database.select(database.measurementTemplateVersions)
              ..where((row) => row.garmentId.equals(entry.garmentId))
              ..orderBy([(row) => OrderingTerm.desc(row.versionNumber)])
              ..limit(1))
            .getSingle();
    final rows =
        await (database.select(database.measurementTemplateFields)
              ..where((row) => row.templateVersionId.equals(version.id))
              ..orderBy([(row) => OrderingTerm.asc(row.displayOrder)]))
            .get();
    return GarmentCatalogRecord(
      entry: entry,
      templateVersion: version,
      fields: [
        for (final row in rows)
          GarmentTemplateField(
            id: row.fieldId,
            label: row.displayLabel,
            labelUrdu: row.displayLabelUrdu,
            order: row.displayOrder,
            required: row.isRequired,
            archived: row.isArchived,
          ),
      ],
    );
  }

  Future<void> updateEntry({
    required String garmentId,
    bool? enabled,
    int? displayOrder,
    int? defaultPricePaisa,
    String? displayName,
    String? displayNameUrdu,
    bool updateUrduName = false,
  }) async {
    if (defaultPricePaisa != null && defaultPricePaisa < 0) {
      throw ArgumentError('Default price cannot be negative');
    }
    await (database.update(
      database.garmentCatalogEntries,
    )..where((row) => row.garmentId.equals(garmentId))).write(
      GarmentCatalogEntriesCompanion(
        enabled: enabled == null ? const Value.absent() : Value(enabled),
        displayOrder: displayOrder == null
            ? const Value.absent()
            : Value(displayOrder),
        defaultStitchingPricePaisa: defaultPricePaisa == null
            ? const Value.absent()
            : Value(defaultPricePaisa),
        displayName: displayName == null
            ? const Value.absent()
            : Value(displayName.trim()),
        displayNameUrdu: updateUrduName
            ? Value(
                displayNameUrdu?.trim().isEmpty == true
                    ? null
                    : displayNameUrdu?.trim(),
              )
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> reorder(List<String> garmentIds) async {
    await database.transaction(() async {
      for (final indexed in garmentIds.indexed) {
        await updateEntry(garmentId: indexed.$2, displayOrder: indexed.$1);
      }
    });
  }

  Future<String> createCustomTemplate({
    required String name,
    String? nameUrdu,
    required String convention,
    required List<GarmentTemplateField> fields,
    int defaultPricePaisa = 0,
  }) async {
    _validate(name: name, convention: convention, fields: fields);
    final normalized = name
        .trim()
        .toLowerCase()
        .replaceAll(RegExp('[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final id = 'custom_${normalized}_${DateTime.now().microsecondsSinceEpoch}';
    await database.transaction(() async {
      final currentEntries = await database
          .select(database.garmentCatalogEntries)
          .get();
      final order = currentEntries.fold<int>(
        -1,
        (maximum, row) =>
            row.displayOrder > maximum ? row.displayOrder : maximum,
      );
      await database
          .into(database.garmentCatalogEntries)
          .insert(
            GarmentCatalogEntriesCompanion.insert(
              garmentId: id,
              displayName: name.trim(),
              displayNameUrdu: Value(
                nameUrdu?.trim().isEmpty == true ? null : nameUrdu?.trim(),
              ),
              displayOrder: order + 1,
              defaultStitchingPricePaisa: Value(defaultPricePaisa),
              isCustom: const Value(true),
            ),
          );
      await _insertVersion(id, 1, convention, fields);
    });
    return id;
  }

  Future<int> reviseTemplate({
    required String garmentId,
    String? name,
    String? nameUrdu,
    required String convention,
    required List<GarmentTemplateField> fields,
  }) async {
    final current = await getById(garmentId);
    if (current == null) throw StateError('Garment not found');
    final revisedName = name ?? current.entry.displayName;
    _validate(name: revisedName, convention: convention, fields: fields);
    final priorById = {for (final field in current.fields) field.id: field};
    final revisedById = {for (final field in fields) field.id: field};
    final complete = [...fields];
    for (final prior in priorById.values) {
      if (!revisedById.containsKey(prior.id)) {
        complete.add(
          GarmentTemplateField(
            id: prior.id,
            label: prior.label,
            labelUrdu: prior.labelUrdu,
            order: complete.length,
            required: false,
            archived: true,
          ),
        );
      }
    }
    final version = current.templateVersion.versionNumber + 1;
    await database.transaction(() async {
      if (current.entry.isCustom) {
        await updateEntry(
          garmentId: garmentId,
          displayName: revisedName,
          displayNameUrdu: nameUrdu,
          updateUrduName: true,
        );
      }
      await _insertVersion(garmentId, version, convention, complete);
    });
    return version;
  }

  Future<void> _insertVersion(
    String garmentId,
    int version,
    String convention,
    List<GarmentTemplateField> fields,
  ) async {
    final versionId = await database
        .into(database.measurementTemplateVersions)
        .insert(
          MeasurementTemplateVersionsCompanion.insert(
            garmentId: garmentId,
            versionNumber: version,
            measurementConvention: convention,
          ),
        );
    for (final indexed in fields.indexed) {
      final field = indexed.$2;
      await database
          .into(database.measurementTemplateFields)
          .insert(
            MeasurementTemplateFieldsCompanion.insert(
              templateVersionId: versionId,
              fieldId: field.id.trim(),
              displayLabel: field.label.trim(),
              displayLabelUrdu: Value(
                field.labelUrdu?.trim().isEmpty == true
                    ? null
                    : field.labelUrdu?.trim(),
              ),
              displayOrder: indexed.$1,
              isRequired: field.required,
              isArchived: Value(field.archived),
            ),
          );
    }
  }

  void _validate({
    required String name,
    required String convention,
    required List<GarmentTemplateField> fields,
  }) {
    if (name.trim().isEmpty) throw ArgumentError('Garment name is required');
    if (!{'body', 'finished_garment'}.contains(convention)) {
      throw ArgumentError('Invalid measurement convention');
    }
    final active = fields.where((field) => !field.archived).toList();
    if (active.isEmpty) throw ArgumentError('Add at least one field');
    final ids = <String>{};
    for (final field in active) {
      if (field.id.trim().isEmpty || field.label.trim().isEmpty) {
        throw ArgumentError('Field ID and label are required');
      }
      if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(field.id.trim())) {
        throw ArgumentError(
          'Field IDs must use lowercase letters and underscores',
        );
      }
      if (!ids.add(field.id.trim())) {
        throw ArgumentError('Field IDs must be unique');
      }
    }
  }
}

final garmentCatalogRepositoryProvider = Provider<GarmentCatalogRepository>((
  ref,
) {
  return GarmentCatalogRepository(ref.watch(databaseProvider));
});

final garmentCatalogProvider = FutureProvider<List<GarmentCatalogRecord>>((
  ref,
) {
  return ref.watch(garmentCatalogRepositoryProvider).getCatalog();
});

final enabledGarmentCatalogProvider =
    FutureProvider<List<GarmentCatalogRecord>>((ref) {
      return ref
          .watch(garmentCatalogRepositoryProvider)
          .getCatalog(enabledOnly: true);
    });
