import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import 'measurement_form_screen.dart';
import 'measurement_models.dart';
import 'measurement_providers.dart';
import 'measurement_templates.dart';

class MeasurementDetailScreen extends ConsumerWidget {
  const MeasurementDetailScreen({
    super.key,
    required this.customer,
    required this.profileId,
  });

  final Customer customer;
  final int profileId;

  Future<void> _edit(
    BuildContext context,
    MeasurementProfileRecord record,
  ) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            MeasurementFormScreen(customer: customer, existing: record),
      ),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New measurement revision saved.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(measurementProfileProvider(profileId));
    return profile.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Measurements')),
        body: const EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load measurements',
          subtitle: 'Your saved data has not been changed.',
        ),
      ),
      data: (record) {
        if (record == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Measurements')),
            body: const EmptyState(
              icon: Icons.straighten_outlined,
              title: 'Profile not found',
              subtitle: 'This measurement profile is no longer available.',
            ),
          );
        }
        return _MeasurementDetails(
          customer: customer,
          record: record,
          onEdit: () => _edit(context, record),
        );
      },
    );
  }
}

class _MeasurementDetails extends ConsumerWidget {
  const _MeasurementDetails({
    required this.customer,
    required this.record,
    required this.onEdit,
  });

  final Customer customer;
  final MeasurementProfileRecord record;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revision = record.latestRevision;
    final garment = GarmentType.fromStorage(revision.garmentType);
    final unit = MeasurementUnit.fromStorage(revision.unit);
    final basis = MeasurementBasis.fromStorage(revision.measurementBasis);
    final fit = FitPreference.fromStorage(revision.fitPreference);
    final template = garmentMeasurementTemplates[garment]!;
    final history = ref.watch(measurementHistoryProvider(record.profile.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(revision.profileName),
        actions: [
          IconButton(
            tooltip: 'Create new revision',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
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
                  Text(
                    garment.label,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${customer.name} · ${unit.label}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      _InfoChip(label: basis.label),
                      _InfoChip(label: '${fit.label} fit'),
                      _InfoChip(label: 'Revision ${revision.revisionNumber}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Measurement values',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                children: template.fields
                    .where((field) => record.values.containsKey(field.key))
                    .map(
                      (field) => _ValueRow(
                        label: field.label,
                        value: '${record.values[field.key]} ${unit.suffix}',
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          if (revision.styleInstructions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            _TextSection(
              title: 'Style instructions',
              text: revision.styleInstructions,
            ),
          ],
          if (revision.notes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _TextSection(title: 'Notes', text: revision.notes),
          ],
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Revision history',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Revision'),
              ),
            ],
          ),
          history.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => const Text('Could not load revision history.'),
            data: (revisions) => Card(
              child: Column(
                children: revisions
                    .map(
                      (item) => ListTile(
                        leading: CircleAvatar(
                          child: Text('${item.revisionNumber}'),
                        ),
                        title: Text('Revision ${item.revisionNumber}'),
                        subtitle: Text(
                          DateFormat(
                            'd MMM yyyy, h:mm a',
                          ).format(item.createdAt),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showRevision(context, item),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  void _showRevision(BuildContext context, MeasurementRevision revision) {
    final garment = GarmentType.fromStorage(revision.garmentType);
    final unit = MeasurementUnit.fromStorage(revision.unit);
    final values = decodeMeasurementValues(revision.valuesJson);
    final template = garmentMeasurementTemplates[garment]!;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: AppSpacing.pagePadding,
          children: [
            Text(
              'Revision ${revision.revisionNumber}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text('${garment.label} · ${revision.profileName} · ${unit.label}'),
            const SizedBox(height: AppSpacing.lg),
            ...template.fields
                .where((field) => values.containsKey(field.key))
                .map(
                  (field) => _ValueRow(
                    label: field.label,
                    value: '${values[field.key]} ${unit.suffix}',
                  ),
                ),
            if (revision.styleInstructions.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text('Style: ${revision.styleInstructions}'),
            ],
            if (revision.notes.isNotEmpty) Text('Notes: ${revision.notes}'),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: AppColors.primary),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final useVerticalLayout = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: useVerticalLayout
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                const SizedBox(height: AppSpacing.xs),
                Text(value, style: Theme.of(context).textTheme.labelLarge),
              ],
            )
          : Row(
              children: [
                Expanded(child: Text(label)),
                Text(value, style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
    );
  }
}

class _TextSection extends StatelessWidget {
  const _TextSection({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(text),
          ],
        ),
      ),
    );
  }
}
