import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/localization/localization_extensions.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import 'new_order_screen.dart';
import 'order_detail_screen.dart';
import 'order_formatters.dart';
import 'order_models.dart';
import 'order_providers.dart';

enum _OrderFilter { all, active, overdue, outstanding }

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  String _query = '';
  _OrderFilter _filter = _OrderFilter.all;

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.orders)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewOrderScreen()),
        ),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.newOrder),
      ),
      body: orders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => EmptyState(
          icon: Icons.error_outline,
          title: context.l10n.couldNotLoad,
          subtitle: context.l10n.savedDataUnchanged,
        ),
        data: (records) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final query = _query.trim().toLowerCase();
          final filtered = records.where((record) {
            final searchable =
                '${record.order.orderNumber} ${record.customer.name} ${record.customer.phone}'
                    .toLowerCase();
            if (query.isNotEmpty && !searchable.contains(query)) return false;
            return switch (_filter) {
              _OrderFilter.all => true,
              _OrderFilter.active =>
                record.progress != OrderProgress.cancelled &&
                    record.progress != OrderProgress.delivered,
              _OrderFilter.overdue =>
                record.progress != OrderProgress.cancelled &&
                    record.progress != OrderProgress.delivered &&
                    record.order.deliveryDate.isBefore(today),
              _OrderFilter.outstanding =>
                record.balancePaisa > 0 &&
                    record.progress != OrderProgress.cancelled,
            };
          }).toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: TextField(
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: context.l10n.searchOrders,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SegmentedButton<_OrderFilter>(
                  segments: [
                    ButtonSegment(
                      value: _OrderFilter.all,
                      label: Text(context.l10n.all),
                    ),
                    ButtonSegment(
                      value: _OrderFilter.active,
                      label: Text(context.l10n.active),
                    ),
                    ButtonSegment(
                      value: _OrderFilter.overdue,
                      label: Text(context.l10n.overdue),
                    ),
                    ButtonSegment(
                      value: _OrderFilter.outstanding,
                      label: Text(context.l10n.outstanding),
                    ),
                  ],
                  selected: {_filter},
                  onSelectionChanged: (value) =>
                      setState(() => _filter = value.first),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? EmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: records.isEmpty
                            ? context.l10n.noOrders
                            : context.l10n.notFound,
                        subtitle: records.isEmpty
                            ? context.l10n.noOrdersHelp
                            : context.l10n.differentSearch,
                        action: records.isEmpty
                            ? FilledButton.icon(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const NewOrderScreen(),
                                  ),
                                ),
                                icon: const Icon(Icons.add),
                                label: Text(context.l10n.newOrder),
                              )
                            : null,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (_, index) {
                          final record = filtered[index];
                          final garmentCount = record.items.fold<int>(
                            0,
                            (total, item) => total + item.quantity,
                          );
                          final overdue =
                              record.progress != OrderProgress.delivered &&
                              record.progress != OrderProgress.cancelled &&
                              record.order.deliveryDate.isBefore(today);
                          return Card(
                            child: ListTile(
                              minVerticalPadding: AppSpacing.md,
                              title: Text(
                                '${record.order.orderNumber} · ${record.customer.name}',
                              ),
                              subtitle: Text(
                                '${context.l10n.itemCount(garmentCount)} · ${context.l10n.deliveryDate} ${DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag()).format(record.order.deliveryDate)}\n'
                                '${localizedStatus(context.l10n, record.progress.name)} · ${record.paymentStatusLabel} · ${context.l10n.balance} ${formatPaisa(record.balancePaisa)}',
                              ),
                              isThreeLine: true,
                              trailing: overdue
                                  ? const Icon(
                                      Icons.warning_amber_rounded,
                                      color: AppColors.error,
                                    )
                                  : const Icon(Icons.chevron_right),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderDetailScreen(
                                    orderId: record.order.id,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
