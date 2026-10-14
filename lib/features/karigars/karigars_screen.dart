import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/localization/localization_extensions.dart';
import '../../core/widgets/status_badge.dart';
import 'karigar_form_screen.dart';
import 'karigar_detail_screen.dart';
import 'karigar_models.dart';
import 'karigar_providers.dart';

class KarigarsScreen extends ConsumerStatefulWidget {
  const KarigarsScreen({super.key});

  @override
  ConsumerState<KarigarsScreen> createState() => _KarigarsScreenState();
}

class _KarigarsScreenState extends ConsumerState<KarigarsScreen> {
  final _search = TextEditingController();
  String _query = '';
  bool _showActiveOnly = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final karigarsAsync = _showActiveOnly
        ? ref.watch(activeKarigarsProvider)
        : ref.watch(karigarsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.karigars),
        centerTitle: false,
        actions: [
          FilterChip(
            label: Text(context.l10n.activeOnly),
            selected: _showActiveOnly,
            onSelected: (v) => setState(() => _showActiveOnly = v),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: context.l10n.searchKarigars,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _search.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: karigarsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => EmptyState(
                icon: Icons.error_outline,
                title: context.l10n.couldNotLoad,
                subtitle: context.l10n.savedDataUnchanged,
              ),
              data: (list) {
                final filtered = _filter(list);
                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.engineering_outlined,
                    title: _query.isNotEmpty
                        ? 'No match for "$_query"'
                        : 'No karigars yet',
                    subtitle: _query.isNotEmpty
                        ? 'Try a different search term.'
                        : 'Add your tailors and workers to assign order items and track their workload.',
                    action: _query.isEmpty
                        ? FilledButton.icon(
                            onPressed: _addKarigar,
                            icon: const Icon(
                              Icons.person_add_outlined,
                              size: 20,
                            ),
                            label: Text(context.l10n.addKarigar),
                          )
                        : null,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (_, index) =>
                      _KarigarTile(record: filtered[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addKarigar,
        icon: const Icon(Icons.person_add_outlined),
        label: Text(context.l10n.addKarigar),
      ),
    );
  }

  List<KarigarRecord> _filter(List<KarigarRecord> list) {
    if (_query.isEmpty) return list;
    final q = _query.toLowerCase();
    return list
        .where(
          (r) =>
              r.karigar.name.toLowerCase().contains(q) ||
              r.karigar.phone.toLowerCase().contains(q) ||
              r.karigar.skills.toLowerCase().contains(q),
        )
        .toList();
  }

  void _addKarigar() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const KarigarFormScreen()),
  );
}

class _KarigarTile extends StatelessWidget {
  const _KarigarTile({required this.record});
  final KarigarRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = record.status == KarigarStatus.active;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KarigarDetailScreen(karigarId: record.karigar.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    record.karigar.name.isNotEmpty
                        ? record.karigar.name[0].toUpperCase()
                        : '?',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: active
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name and skills
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            record.karigar.name,
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                        if (!active)
                          const StatusBadge(
                            label: 'Inactive',
                            color: AppColors.textSecondary,
                          ),
                      ],
                    ),
                    if (record.karigar.skills.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        record.karigar.skills,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Workload
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (record.activeCount > 0)
                    Text(
                      '${record.activeCount} active',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  if (record.completedCount > 0)
                    Text(
                      '${record.completedCount} done',
                      style: theme.textTheme.labelSmall,
                    ),
                ],
              ),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
