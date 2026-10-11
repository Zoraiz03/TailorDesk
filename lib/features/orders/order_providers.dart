import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';
import 'data/orders_dao.dart';
import 'order_models.dart';

final ordersDaoProvider = Provider<OrdersDao>((ref) {
  return OrdersDao(ref.watch(databaseProvider));
});

final ordersProvider = StreamProvider<List<OrderRecord>>((ref) {
  return ref.watch(ordersDaoProvider).watchAll();
});

final orderProvider = StreamProvider.family<OrderRecord?, int>((ref, orderId) {
  return ref.watch(ordersDaoProvider).watchOrder(orderId);
});

final customerOrdersProvider = StreamProvider.family<List<OrderRecord>, int>((
  ref,
  customerId,
) {
  return ref.watch(ordersDaoProvider).watchForCustomer(customerId);
});

final dashboardMetricsProvider = StreamProvider<DashboardMetrics>((ref) {
  return ref.watch(ordersDaoProvider).watchDashboard();
});
