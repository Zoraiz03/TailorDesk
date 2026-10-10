import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/database_provider.dart';
import 'data/customers_dao.dart';

final customersDaoProvider = Provider<CustomersDao>((ref) {
  return CustomersDao(ref.watch(databaseProvider));
});

final customersProvider = StreamProvider<List<Customer>>((ref) {
  return ref.watch(customersDaoProvider).watchAll();
});

final customerProvider = StreamProvider.family<Customer?, int>((ref, id) {
  return ref.watch(customersDaoProvider).watchById(id);
});
