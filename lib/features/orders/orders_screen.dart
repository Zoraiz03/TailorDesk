import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
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
      appBar: AppBar(title: const Text('Orders')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewOrderScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('New Order'),
      ),
      body: orders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load orders',
          subtitle: 'Your saved data has not been changed.',
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
                  decoration: const InputDecoration(
                    hintText: 'Search order, customer, or phone',
                    prefixIcon: Icon(Icons.search),
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
                  segments: const [
                    ButtonSegment(value: _OrderFilter.all, label: Text('All')),
                    ButtonSegment(
                      value: _OrderFilter.active,
                      label: Text('Active'),
                    ),
                    ButtonSegment(
                      value: _OrderFilter.overdue,
                      label: Text('Overdue'),
                    ),
                    ButtonSegment(
                      value: _OrderFilter.outstanding,
                      label: Text('Outstanding'),
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
                            ? 'No orders yet'
                            : 'No matching orders',
                        subtitle: records.isEmpty
                            ? 'Create an order to start tracking garments, delivery, and payments.'
                            : 'Try another search or filter.',
                        action: records.isEmpty
                            ? FilledButton.icon(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const NewOrderScreen(),
                                  ),
                                ),
                                icon: const Icon(Icons.add),
                                label: const Text('New Order'),
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
                                '$garmentCount garment${garmentCount == 1 ? '' : 's'} · Due ${DateFormat.yMMMd().format(record.order.deliveryDate)}\n'
                                '${record.progress.label} · ${record.paymentStatusLabel} · Balance ${formatPaisa(record.balancePaisa)}',
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
