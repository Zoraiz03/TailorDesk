import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import 'measurement_detail_screen.dart';
import 'measurement_form_screen.dart';
import 'measurement_profile_card.dart';
import 'measurement_providers.dart';

class CustomerMeasurementsScreen extends ConsumerWidget {
  const CustomerMeasurementsScreen({
    super.key,
    required this.customer,
    this.historyMode = false,
  });

  final Customer customer;
  final bool historyMode;

  Future<void> _add(BuildContext context) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => MeasurementFormScreen(customer: customer),
      ),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Measurements saved.')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(
      customerMeasurementProfilesProvider(customer.id),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(historyMode ? 'Measurement History' : 'Measurements'),
      ),
      floatingActionButton: historyMode
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _add(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Measurements'),
            ),
      body: profiles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load measurements',
          subtitle: 'Your saved data has not been changed.',
          action: OutlinedButton.icon(
            onPressed: () => ref.invalidate(
              customerMeasurementProfilesProvider(customer.id),
            ),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ),
        data: (records) {
          if (records.isEmpty) {
            return EmptyState(
              icon: Icons.straighten_outlined,
              title: historyMode
                  ? 'No measurement history'
                  : 'No measurements yet',
              subtitle: historyMode
                  ? 'Saved profile revisions will appear here.'
                  : 'Add a garment measurement profile for ${customer.name}.',
              action: historyMode
                  ? null
                  : FilledButton.icon(
                      onPressed: () => _add(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Measurements'),
                    ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final record = records[index];
              return MeasurementProfileCard(
                record: record,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MeasurementDetailScreen(
                      customer: customer,
                      profileId: record.profile.id,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
