import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/localization/localization_extensions.dart';
import 'customer_detail_screen.dart';
import 'customer_form_screen.dart';
import 'customer_providers.dart';

enum _CustomerSort { recentlyUpdated, name }

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  _CustomerSort _sort = _CustomerSort.recentlyUpdated;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openForm() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CustomerFormScreen()));
  }

  List<Customer> _visibleCustomers(List<Customer> customers) {
    final query = _query.trim().toLowerCase();
    final visible = customers.where((customer) {
      return query.isEmpty ||
          customer.name.toLowerCase().contains(query) ||
          customer.phone.toLowerCase().contains(query);
    }).toList();

    if (_sort == _CustomerSort.name) {
      visible.sort(
        (left, right) =>
            left.name.toLowerCase().compareTo(right.name.toLowerCase()),
      );
    } else {
      visible.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    }
    return visible;
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.customers),
        actions: [
          PopupMenuButton<_CustomerSort>(
            initialValue: _sort,
            tooltip: context.l10n.sortCustomers,
            icon: const Icon(Icons.sort),
            onSelected: (value) => setState(() => _sort = value),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _CustomerSort.recentlyUpdated,
                child: Text(context.l10n.recentlyUpdated),
              ),
              PopupMenuItem(
                value: _CustomerSort.name,
                child: Text(context.l10n.nameAZ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        icon: const Icon(Icons.person_add_outlined),
        label: Text(context.l10n.addCustomer),
      ),
      body: customers.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyState(
          icon: Icons.error_outline,
          title: context.l10n.couldNotLoadSettings,
          subtitle: context.l10n.savedDataUnchanged,
          action: OutlinedButton.icon(
            onPressed: () => ref.invalidate(customersProvider),
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
          ),
        ),
        data: (allCustomers) {
          if (allCustomers.isEmpty) {
            return EmptyState(
              icon: Icons.people_outline,
              title: context.l10n.noCustomers,
              subtitle: context.l10n.noCustomersHelp,
              action: FilledButton.icon(
                onPressed: _openForm,
                icon: const Icon(Icons.person_add_outlined, size: 20),
                label: Text(context.l10n.addCustomer),
              ),
            );
          }

          final visibleCustomers = _visibleCustomers(allCustomers);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: TextField(
                  key: const ValueKey('customer-search'),
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: context.l10n.searchCustomers,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: context.l10n.clearSearch,
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            icon: const Icon(Icons.close),
                          ),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: visibleCustomers.isEmpty
                    ? EmptyState(
                        icon: Icons.person_search_outlined,
                        title: context.l10n.noMatchingCustomers,
                        subtitle: context.l10n.differentSearch,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
                        itemCount: visibleCustomers.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) =>
                            _CustomerCard(customer: visibleCustomers[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CustomerDetailScreen(customerId: customer.id),
          ),
        ),
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                foregroundColor: AppColors.primary,
                child: Text(
                  customer.name.trim().isEmpty
                      ? '?'
                      : customer.name.trim()[0].toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      customer.phone,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
