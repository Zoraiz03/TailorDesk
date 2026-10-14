import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';
import 'data/reports_dao.dart';
import 'report_models.dart';

final reportsDaoProvider = Provider<ReportsDao>((ref) {
  return ReportsDao(ref.watch(databaseProvider));
});

final dueOrdersReportProvider = StreamProvider<DueOrdersReport>((ref) {
  return ref.watch(reportsDaoProvider).watchDueOrdersReport();
});

final customerBalancesReportProvider = StreamProvider<CustomerBalancesReport>((
  ref,
) {
  return ref.watch(reportsDaoProvider).watchCustomerBalancesReport();
});

class CollectionsPeriodNotifier extends Notifier<CollectionsPeriod> {
  @override
  CollectionsPeriod build() => CollectionsPeriod.thisMonth;

  void setPeriod(CollectionsPeriod period) => state = period;
}

final selectedCollectionsPeriodProvider =
    NotifierProvider<CollectionsPeriodNotifier, CollectionsPeriod>(
      CollectionsPeriodNotifier.new,
    );

class CustomRangeNotifier extends Notifier<DateTimeRange?> {
  @override
  DateTimeRange? build() => null;

  void setRange(DateTimeRange? range) => state = range;
}

final customCollectionsRangeProvider =
    NotifierProvider<CustomRangeNotifier, DateTimeRange?>(
      CustomRangeNotifier.new,
    );

final collectionsReportProvider = StreamProvider<CollectionsReport>((ref) {
  final dao = ref.watch(reportsDaoProvider);
  final period = ref.watch(selectedCollectionsPeriodProvider);
  final customRange = ref.watch(customCollectionsRangeProvider);
  return dao.watchCollectionsReport(period: period, customRange: customRange);
});

final karigarWorkloadReportProvider = StreamProvider<KarigarWorkloadReport>((
  ref,
) {
  return ref.watch(reportsDaoProvider).watchKarigarWorkloadReport();
});
