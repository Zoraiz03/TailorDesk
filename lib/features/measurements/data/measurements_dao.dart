import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../measurement_models.dart';

part 'measurements_dao.g.dart';

@DriftAccessor(tables: [MeasurementProfiles, MeasurementRevisions])
class MeasurementsDao extends DatabaseAccessor<AppDatabase>
    with _$MeasurementsDaoMixin {
  MeasurementsDao(super.attachedDatabase);

  Stream<List<MeasurementProfileRecord>> watchForCustomer(int customerId) {
    final query = select(measurementProfiles).join([
      innerJoin(
        measurementRevisions,
        measurementRevisions.profileId.equalsExp(measurementProfiles.id),
      ),
    ])..where(measurementProfiles.customerId.equals(customerId));

    return query.watch().map((rows) {
      final latestByProfile = <int, MeasurementProfileRecord>{};
      for (final row in rows) {
        final profile = row.readTable(measurementProfiles);
        final revision = row.readTable(measurementRevisions);
        final current = latestByProfile[profile.id];
        if (current == null ||
            revision.revisionNumber > current.latestRevision.revisionNumber) {
          latestByProfile[profile.id] = MeasurementProfileRecord(
            profile: profile,
            latestRevision: revision,
          );
        }
      }
      final records = latestByProfile.values.toList()
        ..sort(
          (left, right) =>
              right.profile.updatedAt.compareTo(left.profile.updatedAt),
        );
      return records;
    });
  }

  /// Every immutable revision available for order snapshot selection.
  Stream<List<MeasurementProfileRecord>> watchRevisionsForCustomer(
    int customerId,
  ) {
    final query =
        select(measurementProfiles).join([
            innerJoin(
              measurementRevisions,
              measurementRevisions.profileId.equalsExp(measurementProfiles.id),
            ),
          ])
          ..where(measurementProfiles.customerId.equals(customerId))
          ..orderBy([
            OrderingTerm.asc(measurementProfiles.garmentType),
            OrderingTerm.asc(measurementProfiles.profileName),
            OrderingTerm.desc(measurementRevisions.revisionNumber),
          ]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => MeasurementProfileRecord(
              profile: row.readTable(measurementProfiles),
              latestRevision: row.readTable(measurementRevisions),
            ),
          )
          .toList(),
    );
  }

  Stream<MeasurementProfileRecord?> watchProfile(int profileId) {
    final query = select(measurementProfiles).join([
      innerJoin(
        measurementRevisions,
        measurementRevisions.profileId.equalsExp(measurementProfiles.id),
      ),
    ])..where(measurementProfiles.id.equals(profileId));

    return query.watch().map((rows) {
      if (rows.isEmpty) return null;
      final profile = rows.first.readTable(measurementProfiles);
      final revisions =
          rows.map((row) => row.readTable(measurementRevisions)).toList()..sort(
            (left, right) =>
                right.revisionNumber.compareTo(left.revisionNumber),
          );
      return MeasurementProfileRecord(
        profile: profile,
        latestRevision: revisions.first,
      );
    });
  }

  Stream<List<MeasurementRevision>> watchHistory(int profileId) {
    return (select(measurementRevisions)
          ..where((revision) => revision.profileId.equals(profileId))
          ..orderBy([(revision) => OrderingTerm.desc(revision.revisionNumber)]))
        .watch();
  }

  Future<MeasurementProfileRecord?> getProfile(int profileId) async {
    final profile = await (select(
      measurementProfiles,
    )..where((row) => row.id.equals(profileId))).getSingleOrNull();
    if (profile == null) return null;
    final revision =
        await (select(measurementRevisions)
              ..where((row) => row.profileId.equals(profileId))
              ..orderBy([(row) => OrderingTerm.desc(row.revisionNumber)])
              ..limit(1))
            .getSingle();
    return MeasurementProfileRecord(profile: profile, latestRevision: revision);
  }

  Future<int> createProfile(MeasurementDraft draft) {
    draft.validate();
    return transaction(() async {
      final now = DateTime.now();
      final profileId = await into(measurementProfiles).insert(
        MeasurementProfilesCompanion.insert(
          customerId: draft.customerId,
          garmentType: draft.garmentId,
          profileName: draft.profileName.trim(),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      await into(measurementRevisions).insert(
        _revisionCompanion(
          profileId: profileId,
          revisionNumber: 1,
          draft: draft,
          createdAt: now,
        ),
      );
      return profileId;
    });
  }

  Future<int> createRevision({
    required int profileId,
    required MeasurementDraft draft,
  }) {
    draft.validate();
    return transaction(() async {
      final profile = await (select(
        measurementProfiles,
      )..where((row) => row.id.equals(profileId))).getSingleOrNull();
      if (profile == null) throw StateError('Measurement profile not found');
      if (profile.customerId != draft.customerId) {
        throw ArgumentError('A profile cannot be moved to another customer');
      }

      final latest =
          await (select(measurementRevisions)
                ..where((row) => row.profileId.equals(profileId))
                ..orderBy([(row) => OrderingTerm.desc(row.revisionNumber)])
                ..limit(1))
              .getSingle();
      if (latest.garmentType != draft.garmentId ||
          latest.unit != draft.unit.storageKey ||
          latest.measurementBasis != draft.basis.storageKey) {
        throw ArgumentError(
          'Create a separate profile to change garment, unit, or measurement basis',
        );
      }
      final revisionNumber = latest.revisionNumber + 1;
      final now = DateTime.now();

      await into(measurementRevisions).insert(
        _revisionCompanion(
          profileId: profileId,
          revisionNumber: revisionNumber,
          draft: draft,
          createdAt: now,
        ),
      );
      await (update(
        measurementProfiles,
      )..where((row) => row.id.equals(profileId))).write(
        MeasurementProfilesCompanion(
          garmentType: Value(draft.garmentId),
          profileName: Value(draft.profileName.trim()),
          updatedAt: Value(now),
        ),
      );
      return revisionNumber;
    });
  }

  MeasurementRevisionsCompanion _revisionCompanion({
    required int profileId,
    required int revisionNumber,
    required MeasurementDraft draft,
    required DateTime createdAt,
  }) {
    return MeasurementRevisionsCompanion.insert(
      profileId: profileId,
      revisionNumber: revisionNumber,
      garmentType: draft.garmentId,
      garmentLabelEnglish: Value(draft.garmentLabelEnglish.trim()),
      garmentLabelUrdu: Value(draft.garmentLabelUrdu.trim()),
      profileName: draft.profileName.trim(),
      unit: draft.unit.storageKey,
      measurementBasis: draft.basis.storageKey,
      valuesJson: draft.encodeValues(),
      templateVersionId: Value(draft.templateVersionId),
      fieldDefinitionsJson: Value(draft.encodeFieldDefinitions()),
      fitPreference: draft.fitPreference.storageKey,
      styleInstructions: Value(draft.styleInstructions.trim()),
      notes: Value(draft.notes.trim()),
      createdAt: Value(createdAt),
    );
  }
}
