import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/status_badge.dart';
import 'karigar_models.dart';
import 'karigar_providers.dart';

class OrderItemAssignmentCard extends ConsumerWidget {
  const OrderItemAssignmentCard({
    super.key,
    required this.item,
    required this.orderDeliveryDate,
    required this.enabled,
  });

  final OrderItem item;
  final DateTime orderDeliveryDate;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignments = ref.watch(itemAssignmentsProvider(item.id));
    return assignments.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: LinearProgressIndicator(),
      ),
      error: (_, __) => const ListTile(
        leading: Icon(Icons.error_outline),
        title: Text('Could not load assignment'),
      ),
      data: (history) {
        AssignmentRecord? active;
        for (final record in history) {
          if (record.isActive) {
            active = record;
            break;
          }
        }
        final completed = history
            .where((record) => record.status == AssignmentStatus.completed)
            .firstOrNull;
        return Container(
          margin: const EdgeInsets.only(top: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.engineering_outlined, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Karigar assignment',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Spacer(),
                  if (active != null)
                    StatusBadge(
                      label: active.status.label,
                      color: active.status == AssignmentStatus.inProgress
                          ? AppColors.info
                          : AppColors.primary,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (active == null)
                const Text('No active karigar assignment.')
              else ...[
                Text(
                  active.karigar.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (active.assignment.internalDeadline case final deadline?)
                  Text(
                    'Internal deadline: ${DateFormat.yMMMd().format(deadline)}',
                    style: TextStyle(
                      color: deadline.isBefore(DateTime.now())
                          ? AppColors.error
                          : AppColors.textSecondary,
                    ),
                  ),
                if (active.assignment.workInstructions.isNotEmpty)
                  Text('Instructions: ${active.assignment.workInstructions}'),
              ],
              if (enabled &&
                  item.status != 'delivered' &&
                  item.status != 'cancelled') ...[
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (_) => _AssignDialog(
                          ref: ref,
                          item: item,
                          orderDeliveryDate: orderDeliveryDate,
                          current: active,
                        ),
                      ),
                      icon: Icon(
                        active == null
                            ? Icons.person_add_outlined
                            : Icons.swap_horiz,
                      ),
                      label: Text(active == null ? 'Assign' : 'Reassign'),
                    ),
                    if (active?.status == AssignmentStatus.assigned)
                      FilledButton(
                        onPressed: () => _run(
                          context,
                          () => ref
                              .read(karigarsDaoProvider)
                              .startWork(active!.assignment.id),
                        ),
                        child: const Text('Start work'),
                      ),
                    if (active?.status == AssignmentStatus.inProgress)
                      FilledButton(
                        onPressed: () => _run(
                          context,
                          () => ref
                              .read(karigarsDaoProvider)
                              .completeWork(active!.assignment.id),
                        ),
                        child: const Text('Mark ready'),
                      ),
                    if (active == null &&
                        completed != null &&
                        item.status == 'ready')
                      TextButton(
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (_) => _AlterationDialog(
                            ref: ref,
                            assignment: completed,
                          ),
                        ),
                        child: const Text('Return for alteration'),
                      ),
                  ],
                ),
              ],
              if (history.length > 1) ...[
                const Divider(height: AppSpacing.xxl),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text('Assignment history (${history.length})'),
                  children: history.map((record) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: Text(
                        '${record.karigar.name} · ${record.status.label}',
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd().add_jm().format(
                          record.assignment.assignedAt,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _run(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    try {
      await action();
    } on AssignmentNotEligibleException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.reason)));
      }
    }
  }
}

class _AssignDialog extends ConsumerStatefulWidget {
  const _AssignDialog({
    required this.ref,
    required this.item,
    required this.orderDeliveryDate,
    required this.current,
  });

  final WidgetRef ref;
  final OrderItem item;
  final DateTime orderDeliveryDate;
  final AssignmentRecord? current;

  @override
  ConsumerState<_AssignDialog> createState() => _AssignDialogState();
}

class _AssignDialogState extends ConsumerState<_AssignDialog> {
  final _instructions = TextEditingController();
  final _reason = TextEditingController();
  int? _karigarId;
  DateTime? _deadline;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _instructions.text = widget.current?.assignment.workInstructions ?? '';
    _deadline = widget.current?.assignment.internalDeadline;
  }

  @override
  void dispose() {
    _instructions.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_karigarId == null || _saving) return;
    if (widget.current != null && _reason.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a reason for reassignment.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await widget.ref
          .read(karigarsDaoProvider)
          .assignItem(
            orderItemId: widget.item.id,
            karigarId: _karigarId!,
            internalDeadline: _deadline,
            workInstructions: _instructions.text,
            reassignReason: _reason.text,
          );
      if (mounted) Navigator.pop(context);
    } on InactiveKarigarException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This karigar is inactive.')),
        );
      }
    } on AssignmentNotEligibleException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.reason)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final karigars = ref.watch(activeKarigarsProvider);
    return AlertDialog(
      title: Text(
        widget.current == null ? 'Assign karigar' : 'Reassign karigar',
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              karigars.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Could not load active karigars.'),
                data: (items) => DropdownButtonFormField<int>(
                  initialValue: _karigarId,
                  decoration: const InputDecoration(labelText: 'Karigar *'),
                  items: items
                      .map(
                        (record) => DropdownMenuItem(
                          value: record.karigar.id,
                          child: Text(
                            '${record.karigar.name} (${record.activeCount} active)',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _karigarId = value),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Internal deadline'),
                subtitle: Text(
                  _deadline == null
                      ? 'Not set'
                      : DateFormat.yMMMd().format(_deadline!),
                ),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _deadline ?? widget.orderDeliveryDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                    lastDate: DateTime(widget.orderDeliveryDate.year + 5),
                  );
                  if (picked != null && mounted) {
                    setState(() => _deadline = picked);
                  }
                },
              ),
              if (_deadline != null &&
                  _deadline!.isAfter(widget.orderDeliveryDate))
                const Text(
                  'This is after the customer delivery date.',
                  style: TextStyle(color: AppColors.warning),
                ),
              TextField(
                controller: _instructions,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Work instructions',
                ),
              ),
              if (widget.current != null) ...[
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _reason,
                  decoration: const InputDecoration(
                    labelText: 'Reassignment reason *',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _karigarId == null || _saving ? null : _save,
          child: Text(_saving ? 'Saving…' : 'Save'),
        ),
      ],
    );
  }
}

class _AlterationDialog extends StatefulWidget {
  const _AlterationDialog({required this.ref, required this.assignment});
  final WidgetRef ref;
  final AssignmentRecord assignment;

  @override
  State<_AlterationDialog> createState() => _AlterationDialogState();
}

class _AlterationDialogState extends State<_AlterationDialog> {
  final _reason = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Return for alteration'),
    content: TextField(
      controller: _reason,
      autofocus: true,
      minLines: 2,
      maxLines: 4,
      decoration: const InputDecoration(labelText: 'Alteration reason *'),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: _saving
            ? null
            : () async {
                if (_reason.text.trim().isEmpty) return;
                setState(() => _saving = true);
                try {
                  await widget.ref
                      .read(karigarsDaoProvider)
                      .returnForAlteration(
                        assignmentId: widget.assignment.assignment.id,
                        reason: _reason.text,
                      );
                  if (!mounted) return;
                  Navigator.of(this.context).pop();
                } finally {
                  if (mounted) setState(() => _saving = false);
                }
              },
        child: Text(_saving ? 'Saving…' : 'Return'),
      ),
    ],
  );
}
