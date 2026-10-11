import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';
import 'data/karigars_dao.dart';
import 'karigar_models.dart';

final karigarsDaoProvider = Provider<KarigarsDao>((ref) {
  return KarigarsDao(ref.watch(databaseProvider));
});

final karigarsProvider = StreamProvider<List<KarigarRecord>>((ref) {
  return ref.watch(karigarsDaoProvider).watchAll();
});

final activeKarigarsProvider = StreamProvider<List<KarigarRecord>>((ref) {
  return ref.watch(karigarsDaoProvider).watchAll(activeOnly: true);
});

final karigarProvider = StreamProvider.family<KarigarRecord?, int>((ref, id) {
  return ref.watch(karigarsDaoProvider).watchKarigar(id);
});

final itemAssignmentsProvider =
    StreamProvider.family<List<AssignmentRecord>, int>((ref, orderItemId) {
      return ref
          .watch(karigarsDaoProvider)
          .watchAssignmentsForItem(orderItemId);
    });

final karigarAssignmentsProvider =
    StreamProvider.family<List<AssignmentRecord>, int>((ref, karigarId) {
      return ref
          .watch(karigarsDaoProvider)
          .watchAssignmentsForKarigar(karigarId);
    });
