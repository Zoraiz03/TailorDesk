import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../customers/customer_form_screen.dart';
import '../customers/customer_providers.dart';
import 'customer_measurements_screen.dart';

class MeasurementsScreen extends ConsumerWidget {
  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Measurements')),
      body: customers.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load customers',
          subtitle: 'Your saved data has not been changed.',
          action: OutlinedButton.icon(
            onPressed: () => ref.invalidate(customersProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: Icons.people_outline,
              title: 'Add a customer first',
              subtitle: 'Measurement profiles are always linked to a customer.',
              action: FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CustomerFormScreen()),
                ),
                icon: const Icon(Icons.person_add_outlined),
                label: const Text('Add Customer'),
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
