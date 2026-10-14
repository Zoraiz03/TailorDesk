import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/localization/localization_extensions.dart';
import '../customers/customer_form_screen.dart';
import '../customers/customer_providers.dart';
import 'customer_measurements_screen.dart';

class MeasurementsScreen extends ConsumerWidget {
  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.measurements)),
      body: customers.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyState(
          icon: Icons.error_outline,
          title: context.l10n.couldNotLoadCustomers,
          subtitle: context.l10n.savedDataUnchanged,
          action: OutlinedButton.icon(
            onPressed: () => ref.invalidate(customersProvider),
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.tryAgain),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.people_outline,
              title: context.l10n.addCustomerFirst,
              subtitle: context.l10n.measurementCustomerHelp,
              action: FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CustomerFormScreen()),
                ),
                icon: const Icon(Icons.person_add_outlined),
                label: Text(context.l10n.addCustomerAction),
              ),
            );
          }
          return ListView.separated(
            padding: AppSpacing.pagePadding,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final customer = items[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(customer.name),
                  subtitle: Text(customer.phone),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          CustomerMeasurementsScreen(customer: customer),
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
