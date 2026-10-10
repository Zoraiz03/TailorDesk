import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import 'customer_form_screen.dart';
import 'customer_providers.dart';

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, required this.customerId});

  final int customerId;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete customer?'),
        content: const Text(
          'This removes the customer from this device. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(customersDaoProvider).deleteCustomer(customerId);
      if (context.mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete customer. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerProvider(customerId));

    return customer.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Customer')),
        body: EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load customer',
          subtitle: 'Please try again. Your saved data has not been changed.',
          action: OutlinedButton.icon(
            onPressed: () => ref.invalidate(customerProvider(customerId)),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ),
      ),
      data: (value) {
        if (value == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Customer')),
            body: const EmptyState(
              icon: Icons.person_off_outlined,
              title: 'Customer not found',
              subtitle: 'This customer may have been deleted.',
            ),
          );
        }
        return _CustomerDetails(
          customer: value,
          onDelete: () => _delete(context, ref),
        );
      },
    );
  }
}

class _CustomerDetails extends StatelessWidget {
  const _CustomerDetails({required this.customer, required this.onDelete});

  final Customer customer;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
        actions: [
          IconButton(
            tooltip: 'Edit customer',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CustomerFormScreen(customer: customer),
              ),
            ),
            icon: const Icon(Icons.edit_outlined),
          ),
          PopupMenuButton<String>(
            tooltip: 'More customer actions',
            onSelected: (value) {
              if (value == 'delete') onDelete();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: AppColors.error),
                    SizedBox(width: AppSpacing.md),
                    Text('Delete customer'),
                  ],
                ),
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
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: AppColors.primary,
                    child: Text(
                      customer.name.trim()[0].toUpperCase(),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    customer.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SelectableText(
                    customer.phone,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (customer.address.isNotEmpty)
            _DetailCard(
              icon: Icons.location_on_outlined,
              title: 'Address',
              value: customer.address,
            ),
          if (customer.address.isNotEmpty && customer.notes.isNotEmpty)
            const SizedBox(height: AppSpacing.sm),
          if (customer.notes.isNotEmpty)
            _DetailCard(
              icon: Icons.notes_outlined,
              title: 'Notes',
              value: customer.notes,
            ),
          if (customer.address.isEmpty && customer.notes.isEmpty)
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Text(
                  'No address or notes added.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.xxl),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CustomerFormScreen(customer: customer),
              ),
            ),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit Customer'),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(value, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
