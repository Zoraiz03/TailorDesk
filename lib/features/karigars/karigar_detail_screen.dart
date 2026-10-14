import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/localization/localization_extensions.dart';
import '../../core/widgets/status_badge.dart';
import '../orders/order_detail_screen.dart';
import '../orders/order_providers.dart';
import '../documents/document_preview_screen.dart';
import '../documents/order_document_service.dart';
import 'karigar_form_screen.dart';
import 'karigar_models.dart';
import 'karigar_providers.dart';

class KarigarDetailScreen extends ConsumerWidget {
  const KarigarDetailScreen({super.key, required this.karigarId});

  final int karigarId;

  Future<void> _setActive(
    BuildContext context,
    WidgetRef ref,
    KarigarRecord record,
  ) async {
    final active = record.status == KarigarStatus.active;
    if (active && record.activeCount > 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.deactivateBlocked)));
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(active ? 'Deactivate karigar?' : 'Reactivate karigar?'),
        content: Text(
          active
              ? 'Their history is kept, but they cannot receive new work.'
              : 'They will be available for new assignments again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(active ? 'Deactivate' : 'Reactivate'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final dao = ref.read(karigarsDaoProvider);
    if (active) {
      await dao.deactivateKarigar(karigarId);
    } else {
      await dao.reactivateKarigar(karigarId);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.deleteKarigarQuestion),
        content: const Text(
          'A karigar can only be deleted when they have no assignment history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(karigarsDaoProvider).deleteKarigar(karigarId);
      if (context.mounted) Navigator.pop(context);
    } on KarigarHasActiveWorkException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Assignment history must be preserved. Deactivate this karigar instead.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordAsync = ref.watch(karigarProvider(karigarId));
    final assignments = ref.watch(karigarAssignmentsProvider(karigarId));
    return recordAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => Scaffold(
        appBar: AppBar(title: Text(context.l10n.karigarSlip)),
        body: EmptyState(
          icon: Icons.error_outline,
          title: context.l10n.couldNotLoad,
          subtitle: context.l10n.savedDataUnchanged,
        ),
      ),
      data: (record) {
        if (record == null) {
          return Scaffold(
            appBar: AppBar(title: Text(context.l10n.karigars)),
            body: EmptyState(
              icon: Icons.person_off_outlined,
              title: context.l10n.karigarNotFound,
              subtitle: context.l10n.karigarNotFoundHelp,
            ),
          );
        }
        final karigar = record.karigar;
        final active = record.status == KarigarStatus.active;
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.karigars),
            actions: [
              IconButton(
                tooltip: context.l10n.editKarigar,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KarigarFormScreen(karigar: karigar),
                  ),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'active') _setActive(context, ref, record);
                  if (value == 'delete') _delete(context, ref);
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'active',
                    child: Text(active ? 'Deactivate' : 'Reactivate'),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(context.l10n.delete),
                  ),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: AppSpacing.pagePadding,
            children: [
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              karigar.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          StatusBadge(
                            label: active ? 'Active' : 'Inactive',
                            color: active
                                ? AppColors.success
                                : AppColors.textSecondary,
                          ),
                        ],
                      ),
                      if (karigar.phone.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        SelectableText(karigar.phone),
                      ],
                      if (karigar.address.isNotEmpty) Text(karigar.address),
                      if (karigar.skills.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(context.l10n.skillsPrefix(karigar.skills)),
                      ],
                      if (karigar.notes.isNotEmpty)
                        Text(context.l10n.notesPrefix(karigar.notes)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _CountCard(
                      label: 'Assigned',
                      value: record.assignedCount,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _CountCard(
                      label: 'In progress',
                      value: record.inProgressCount,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _CountCard(
                      label: 'Completed',
                      value: record.completedCount,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Work history',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              assignments.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => Text(context.l10n.couldNotLoad),
                data: (items) => items.isEmpty
                    ? EmptyState(
                        icon: Icons.assignment_outlined,
                        title: context.l10n.noAssignments,
                        subtitle: context.l10n.assignmentsAppearHere,
                      )
                    : Column(
                        children: items
                            .map((item) => _AssignmentTile(record: item))
                            .toList(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CountCard extends StatelessWidget {
  const _CountCard({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        children: [
          Text('$value', style: Theme.of(context).textTheme.titleLarge),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    ),
  );
}

class _AssignmentTile extends ConsumerWidget {
  const _AssignmentTile({required this.record});
  final AssignmentRecord record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deadline = record.assignment.internalDeadline;
    final overdue =
        record.isActive &&
        deadline != null &&
        deadline.isBefore(DateTime.now());
    return Card(
      child: ListTile(
        minVerticalPadding: AppSpacing.md,
        title: Text(
          '${record.orderItem.garmentType} × ${record.orderItem.quantity}',
        ),
        subtitle: Text(
          '${record.customer.name} · ${record.order.orderNumber}\n'
          '${deadline == null ? 'No internal deadline' : 'Deadline ${DateFormat.yMMMd().format(deadline)}'}',
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          tooltip: context.l10n.assignmentActions,
          onSelected: (value) async {
            if (value == 'order') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailScreen(orderId: record.order.id),
                ),
              );
              return;
            }
            final order = await ref
                .read(ordersDaoProvider)
                .getOrder(record.order.id);
            if (order == null || !context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DocumentPreviewScreen(
                  kind: OrderDocumentKind.karigarSlip,
                  order: order,
                  assignment: record,
                ),
              ),
            );
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              enabled: false,
              child: StatusBadge(
                label: overdue ? 'Overdue' : record.status.label,
                color: overdue
                    ? AppColors.error
                    : record.isActive
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
            PopupMenuItem(
              value: 'slip',
              child: Text(context.l10n.previewWorkSlip),
            ),
            PopupMenuItem(value: 'order', child: Text(context.l10n.viewOrder)),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailScreen(orderId: record.order.id),
          ),
        ),
      ),
    );
  }
}
