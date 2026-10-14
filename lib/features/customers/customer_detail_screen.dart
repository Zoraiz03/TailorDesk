import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/localization/localization_extensions.dart';
import 'customer_form_screen.dart';
import 'customer_providers.dart';
import '../measurements/customer_measurements_screen.dart';
import '../measurements/measurement_detail_screen.dart';
import '../measurements/measurement_form_screen.dart';
import '../measurements/measurement_profile_card.dart';
import '../measurements/measurement_providers.dart';
import '../orders/new_order_screen.dart';
import '../orders/order_detail_screen.dart';
import '../orders/order_formatters.dart';
import '../orders/order_providers.dart';

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, required this.customerId});

  final int customerId;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    if (await ref.read(customersDaoProvider).hasProtectedRecords(customerId)) {
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(context.l10n.customerDeleteBlocked),
          content: Text(context.l10n.customerDeleteBlocked),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.l10n.deleteBlockedOk),
            ),
          ],
        ),
      );
      return;
    }
    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.deleteCustomer),
        content: Text(context.l10n.deleteCustomerConfirm),
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
      await ref.read(customersDaoProvider).deleteCustomer(customerId);
      if (context.mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.updateFailed)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerProvider(customerId));

    return customer.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(context.l10n.customer)),
        body: EmptyState(
          icon: Icons.error_outline,
          title: context.l10n.couldNotLoad,
          subtitle: context.l10n.savedDataUnchanged,
          action: OutlinedButton.icon(
            onPressed: () => ref.invalidate(customerProvider(customerId)),
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.tryAgain),
          ),
        ),
      ),
      data: (value) {
        if (value == null) {
          return Scaffold(
            appBar: AppBar(title: Text(context.l10n.customer)),
            body: EmptyState(
              icon: Icons.person_off_outlined,
              title: context.l10n.customerNotFound,
              subtitle: context.l10n.customerNotFoundHelp,
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

class _CustomerDetails extends ConsumerWidget {
  const _CustomerDetails({required this.customer, required this.onDelete});

  final Customer customer;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurements = ref.watch(
      customerMeasurementProfilesProvider(customer.id),
    );
    final orders = ref.watch(customerOrdersProvider(customer.id));

    Future<void> addMeasurements() async {
      final saved = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => MeasurementFormScreen(customer: customer),
        ),
      );
      if (saved == true && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.measurementSaved)));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.customerDetails),
        actions: [
          IconButton(
            tooltip: context.l10n.editCustomer,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CustomerFormScreen(customer: customer),
              ),
            ),
            icon: const Icon(Icons.edit_outlined),
          ),
          PopupMenuButton<String>(
            tooltip: context.l10n.more,
            onSelected: (value) {
              if (value == 'delete') onDelete();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline, color: AppColors.error),
                    const SizedBox(width: AppSpacing.md),
                    Text(context.l10n.deleteCustomer),
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
              title: context.l10n.address,
              value: customer.address,
            ),
          if (customer.address.isNotEmpty && customer.notes.isNotEmpty)
            const SizedBox(height: AppSpacing.sm),
          if (customer.notes.isNotEmpty)
            _DetailCard(
              icon: Icons.notes_outlined,
              title: context.l10n.notes,
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'Orders',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NewOrderScreen(initialCustomer: customer),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: Text(context.l10n.newOrder),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          orders.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => Text(context.l10n.orderHistoryLoadFailed),
            data: (records) => records.isEmpty
                ? Card(
                    child: Padding(
                      padding: AppSpacing.cardPadding,
                      child: Text(context.l10n.noCustomerOrders),
                    ),
                  )
                : Column(
                    children: records
                        .take(3)
                        .map(
                          (record) => Card(
                            child: ListTile(
                              title: Text(record.order.orderNumber),
                              subtitle: Text(
                                '${record.progress.label} · Balance ${formatPaisa(record.balancePaisa)}',
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderDetailScreen(
                                    orderId: record.order.id,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Measurements',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CustomerMeasurementsScreen(
                      customer: customer,
                      historyMode: true,
                    ),
                  ),
                ),
                child: Text(context.l10n.viewHistory),
              ),
            ],
          ),
          measurements.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Text(context.l10n.couldNotLoadMeasurements),
              ),
            ),
            data: (records) => records.isEmpty
                ? Card(
                    child: Padding(
                      padding: AppSpacing.cardPadding,
                      child: Text(
                        'No measurement profiles yet.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  )
                : Column(
                    children: records
                        .map(
                          (record) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: MeasurementProfileCard(
                              record: record,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MeasurementDetailScreen(
                                    customer: customer,
                                    profileId: record.profile.id,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.icon(
            onPressed: addMeasurements,
            icon: const Icon(Icons.add),
            label: Text(context.l10n.addMeasurement),
          ),
          const SizedBox(height: AppSpacing.xxl),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CustomerFormScreen(customer: customer),
              ),
            ),
            icon: const Icon(Icons.edit_outlined),
            label: Text(context.l10n.editCustomerAction),
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
