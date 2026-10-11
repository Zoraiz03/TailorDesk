import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import 'data/measurements_dao.dart';
import 'measurement_models.dart';

final measurementsDaoProvider = Provider<MeasurementsDao>((ref) {
  return MeasurementsDao(ref.watch(databaseProvider));
});

final customerMeasurementProfilesProvider =
    StreamProvider.family<List<MeasurementProfileRecord>, int>((
      ref,
      customerId,
    ) {
      return ref.watch(measurementsDaoProvider).watchForCustomer(customerId);
    });

final customerMeasurementRevisionsProvider =
    StreamProvider.family<List<MeasurementProfileRecord>, int>((
      ref,
      customerId,
    ) {
      return ref
          .watch(measurementsDaoProvider)
          .watchRevisionsForCustomer(customerId);
    });

final measurementProfileProvider =
    StreamProvider.family<MeasurementProfileRecord?, int>((ref, profileId) {
      return ref.watch(measurementsDaoProvider).watchProfile(profileId);
    });

final measurementHistoryProvider =
    StreamProvider.family<List<MeasurementRevision>, int>((ref, profileId) {
      return ref.watch(measurementsDaoProvider).watchHistory(profileId);
    });
