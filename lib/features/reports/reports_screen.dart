import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/summary_card.dart';
import '../customers/customer_detail_screen.dart';
import '../karigars/karigar_detail_screen.dart';
import '../karigars/karigar_models.dart';
import '../orders/order_detail_screen.dart';
import '../orders/order_formatters.dart';
import 'report_models.dart';
import 'report_providers.dart';

/// Business reports and operational analytics.
class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      initialIndex: initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reports & Analytics'),
          centerTitle: false,
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(
                icon: Icon(Icons.schedule_outlined, size: 20),
                text: 'Due & Overdue',
              ),
              Tab(
                icon: Icon(Icons.account_balance_wallet_outlined, size: 20),
                text: 'Customer Balances',
              ),
              Tab(
                icon: Icon(Icons.payments_outlined, size: 20),
                text: 'Collections & Refunds',
              ),
              Tab(
                icon: Icon(Icons.handyman_outlined, size: 20),
                text: 'Karigar Workload',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _DueOrdersTab(),
            _CustomerBalancesTab(),
            _CollectionsTab(),
            _KarigarWorkloadTab(),
          ],
        ),
      ),
    );
  }
}

// ── Tab 1: Orders Due & Overdue ──────────────────────────────────────────────

class _DueOrdersTab extends ConsumerWidget {
  const _DueOrdersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(dueOrdersReportProvider);
    final theme = Theme.of(context);

    return reportAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load report',
          subtitle: e.toString(),
          action: OutlinedButton(
            onPressed: () => ref.invalidate(dueOrdersReportProvider),
            child: const Text('Retry'),
          ),
        ),
      ),
      data: (report) {
        if (report.totalDueCount == 0) {
          return const EmptyState(
            icon: Icons.check_circle_outline,
            title: 'All caught up!',
            subtitle: 'No overdue or pending orders due right now.',
          );
        }

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Top Summary Cards
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 600;
                return GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: isWide ? 2.0 : 1.15,
                  children: [
                    SummaryCard(
                      title: 'Overdue',
                      value: '${report.overdueOrders.length}',
                      icon: Icons.warning_amber_rounded,
                      iconColor: AppColors.error,
                      iconBackgroundColor: AppColors.errorBg,
                    ),
                    SummaryCard(
                      title: 'Due Today',
                      value: '${report.dueTodayOrders.length}',
                      icon: Icons.today_rounded,
                      iconColor: AppColors.warning,
                      iconBackgroundColor: AppColors.warningBg,
                    ),
                    SummaryCard(
                      title: 'Upcoming',
                      value: '${report.upcomingOrders.length}',
                      icon: Icons.event_available_rounded,
                      iconColor: AppColors.info,
                      iconBackgroundColor: AppColors.infoBg,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Overdue Section
            if (report.overdueOrders.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Overdue (${report.overdueOrders.length})',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      formatPaisa(report.totalOverduePaisa),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
              ...report.overdueOrders.map((item) => _DueOrderCard(item: item)),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Due Today Section
            if (report.dueTodayOrders.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Due Today (${report.dueTodayOrders.length})',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      formatPaisa(report.totalDueTodayPaisa),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
              ...report.dueTodayOrders.map((item) => _DueOrderCard(item: item)),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Upcoming Section
            if (report.upcomingOrders.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Deliveries (${report.upcomingOrders.length})',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      formatPaisa(report.totalUpcomingPaisa),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
              ),
              ...report.upcomingOrders.map((item) => _DueOrderCard(item: item)),
            ],
          ],
        );
      },
    );
  }
}

class _DueOrderCard extends StatelessWidget {
  const _DueOrderCard({required this.item});

  final DueOrderReportItem item;

  @override
  Widget build(BuildContext context) {
    final order = item.orderRecord;
    final theme = Theme.of(context);
    final dateStr = DateFormat('d MMM yyyy').format(order.order.deliveryDate);

    final statusWidget = item.isOverdue
        ? StatusBadge(
            label: '${item.daysOverdue}d overdue',
            color: AppColors.error,
            backgroundColor: AppColors.errorBg,
          )
        : item.isDueToday
        ? const StatusBadge(
            label: 'Due Today',
            color: AppColors.warning,
            backgroundColor: AppColors.warningBg,
          )
        : StatusBadge(
            label: 'In ${item.daysRemaining}d',
            color: AppColors.info,
            backgroundColor: AppColors.infoBg,
          );

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailScreen(orderId: order.order.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      order.customer.name,
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  statusWidget,
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${order.order.orderNumber} · Promised $dateStr',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${order.activeItems.length} garment(s) · ${order.progress.label}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    order.balancePaisa > 0
                        ? 'Due: ${formatPaisa(order.balancePaisa)}'
                        : 'Fully Paid',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: order.balancePaisa > 0
                          ? AppColors.error
                          : AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tab 2: Customer Balances ─────────────────────────────────────────────────

class _CustomerBalancesTab extends ConsumerWidget {
  const _CustomerBalancesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancesAsync = ref.watch(customerBalancesReportProvider);

    return balancesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load balances',
          subtitle: e.toString(),
          action: OutlinedButton(
            onPressed: () => ref.invalidate(customerBalancesReportProvider),
            child: const Text('Retry'),
          ),
        ),
      ),
      data: (report) {
        if (report.items.isEmpty) {
          return const EmptyState(
            icon: Icons.done_all_rounded,
            title: 'No outstanding balances',
            subtitle: 'All customer accounts are completely paid up!',
          );
        }

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Top Summary Cards
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total Outstanding',
                    value: formatPaisa(report.totalOutstandingPaisa),
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: AppColors.error,
                    iconBackgroundColor: AppColors.errorBg,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SummaryCard(
                    title: 'Customers with Due',
                    value: '${report.customerCountWithBalance}',
                    icon: Icons.people_outline_rounded,
                    iconColor: AppColors.warning,
                    iconBackgroundColor: AppColors.warningBg,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            SectionHeader(title: 'Customer Balances (${report.items.length})'),
            const SizedBox(height: AppSpacing.xs),

            ...report.items.map((item) => _CustomerBalanceCard(item: item)),
          ],
        );
      },
    );
  }
}

class _CustomerBalanceCard extends StatelessWidget {
  const _CustomerBalanceCard({required this.item});

  final CustomerBalanceReportItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerDetailScreen(customerId: item.customer.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.customer.name,
                          style: theme.textTheme.titleMedium,
                        ),
                        if (item.customer.phone.isNotEmpty)
                          Text(
                            item.customer.phone,
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatPaisa(item.totalBalancePaisa),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                      Text(
                        '${item.unpaidOrdersCount} unpaid order(s)',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 16),
              // Orders breakdown
              ...item.ordersWithBalance.map((order) {
                final dateStr = DateFormat(
                  'd MMM',
                ).format(order.order.deliveryDate);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${order.order.orderNumber} (Promised $dateStr)',
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        formatPaisa(order.balancePaisa),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tab 3: Collections & Refunds Over a Period ───────────────────────────────

class _CollectionsTab extends ConsumerWidget {
  const _CollectionsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(selectedCollectionsPeriodProvider);
    final customRange = ref.watch(customCollectionsRangeProvider);
    final reportAsync = ref.watch(collectionsReportProvider);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // Period Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: CollectionsPeriod.values.map((p) {
              final isSelected = p == period;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(p.label),
                  selected: isSelected,
                  onSelected: (selected) async {
                    if (selected) {
                      if (p == CollectionsPeriod.custom) {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          initialDateRange:
                              customRange ??
                              DateTimeRange(
                                start: DateTime.now().subtract(
                                  const Duration(days: 7),
                                ),
                                end: DateTime.now(),
                              ),
                        );
                        if (picked != null) {
                          ref
                              .read(customCollectionsRangeProvider.notifier)
                              .setRange(picked);
                          ref
                              .read(selectedCollectionsPeriodProvider.notifier)
                              .setPeriod(p);
                        }
                      } else {
                        ref
                            .read(selectedCollectionsPeriodProvider.notifier)
                            .setPeriod(p);
                      }
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
        if (period == CollectionsPeriod.custom && customRange != null) ...[
          const SizedBox(height: 6),
          Text(
            'Custom Range: ${DateFormat('d MMM yyyy').format(customRange.start)} – ${DateFormat('d MMM yyyy').format(customRange.end)}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),

        reportAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Center(
            child: EmptyState(
              icon: Icons.error_outline,
              title: 'Could not load collections',
              subtitle: e.toString(),
            ),
          ),
          data: (report) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Financial Metrics Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.45,
                  children: [
                    SummaryCard(
                      title: 'Gross Collections',
                      value: formatPaisa(report.grossCollectionsPaisa),
                      icon: Icons.arrow_downward_rounded,
                      iconColor: AppColors.primary,
                      iconBackgroundColor: AppColors.primaryLight,
                    ),
                    SummaryCard(
                      title: 'Total Refunds',
                      value: formatPaisa(report.totalRefundsPaisa),
                      icon: Icons.arrow_upward_rounded,
                      iconColor: AppColors.error,
                      iconBackgroundColor: AppColors.errorBg,
                    ),
                    SummaryCard(
                      title: 'Net Collections',
                      value: formatPaisa(report.netCollectionsPaisa),
                      icon: Icons.account_balance_rounded,
                      iconColor: AppColors.primary,
                    ),
                    SummaryCard(
                      title: 'Transactions',
                      value: '${report.paymentCount + report.refundCount}',
                      icon: Icons.receipt_long_outlined,
                      iconColor: AppColors.gold,
                      iconBackgroundColor: AppColors.goldLight,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Cash vs Bank Breakdown Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method Breakdown',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.money,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 6),
                                Text('Cash Collected'),
                              ],
                            ),
                            Text(
                              formatPaisa(report.cashCollectionsPaisa),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.account_balance,
                                  size: 18,
                                  color: AppColors.info,
                                ),
                                SizedBox(width: 6),
                                Text('Bank Transfer (Manual)'),
                              ],
                            ),
                            Text(
                              formatPaisa(report.bankTransferCollectionsPaisa),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (report.totalRefundsPaisa > 0) ...[
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Refunds (Cash / Bank)',
                                style: TextStyle(color: AppColors.error),
                              ),
                              Text(
                                '${formatPaisa(report.cashRefundsPaisa)} / ${formatPaisa(report.bankTransferRefundsPaisa)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Transaction Ledger
                SectionHeader(
                  title: 'Ledger Entries (${report.ledgerEntries.length})',
                ),
                const SizedBox(height: AppSpacing.xs),

                if (report.ledgerEntries.isEmpty)
                  const EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No transactions in this period',
                    subtitle:
                        'No payments or refunds recorded for the selected range.',
                  )
                else
                  ...report.ledgerEntries.map(
                    (entry) => _PaymentLedgerCard(entry: entry),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PaymentLedgerCard extends StatelessWidget {
  const _PaymentLedgerCard({required this.entry});

  final PaymentLedgerReportItem entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRefund = entry.isRefund;
    final dateStr = DateFormat(
      'd MMM yyyy, h:mm a',
    ).format(entry.payment.paymentDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailScreen(orderId: entry.orderId),
          ),
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isRefund ? AppColors.errorBg : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isRefund ? Icons.arrow_upward : Icons.arrow_downward,
            color: isRefund ? AppColors.error : AppColors.primary,
            size: 20,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                entry.customerName,
                style: theme.textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '${isRefund ? '-' : '+'}${formatPaisa(entry.payment.amountPaisa)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isRefund ? AppColors.error : AppColors.primary,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              '${entry.orderNumber} · ${entry.isBankTransfer ? 'Bank Transfer (Unverified)' : 'Cash'}',
              style: theme.textTheme.bodySmall,
            ),
            Text(dateStr, style: theme.textTheme.bodySmall),
            if (entry.payment.notes.isNotEmpty)
              Text(
                'Note: ${entry.payment.notes}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Tab 4: Karigar Workload & Pending Assignments ────────────────────────────

class _KarigarWorkloadTab extends ConsumerWidget {
  const _KarigarWorkloadTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workloadAsync = ref.watch(karigarWorkloadReportProvider);
    final theme = Theme.of(context);

    return workloadAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load workload',
          subtitle: e.toString(),
          action: OutlinedButton(
            onPressed: () => ref.invalidate(karigarWorkloadReportProvider),
            child: const Text('Retry'),
          ),
        ),
      ),
      data: (report) {
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Workshop Overview Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.45,
              children: [
                SummaryCard(
                  title: 'Active Workers',
                  value: '${report.totalActiveWorkers}',
                  icon: Icons.people_alt_outlined,
                  iconColor: AppColors.primary,
                ),
                SummaryCard(
                  title: 'Active Work Items',
                  value: '${report.totalActiveAssignments}',
                  icon: Icons.hourglass_top_rounded,
                  iconColor: AppColors.info,
                  iconBackgroundColor: AppColors.infoBg,
                ),
                SummaryCard(
                  title: 'Unassigned Items',
                  value: '${report.totalUnassignedItems}',
                  icon: Icons.assignment_late_outlined,
                  iconColor: report.totalUnassignedItems > 0
                      ? AppColors.warning
                      : AppColors.primary,
                  iconBackgroundColor: report.totalUnassignedItems > 0
                      ? AppColors.warningBg
                      : AppColors.primaryLight,
                ),
                SummaryCard(
                  title: 'Overdue Deadlines',
                  value: '${report.totalOverdueAssignments}',
                  icon: Icons.alarm_off_outlined,
                  iconColor: report.totalOverdueAssignments > 0
                      ? AppColors.error
                      : AppColors.primary,
                  iconBackgroundColor: report.totalOverdueAssignments > 0
                      ? AppColors.errorBg
                      : AppColors.primaryLight,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Unassigned Garment Items Section
            if (report.unassignedItems.isNotEmpty) ...[
              Card(
                color: AppColors.warningBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  side: const BorderSide(color: AppColors.warning),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${report.unassignedItems.length} Garment Item(s) Need Karigar Assignment',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...report.unassignedItems.map(
                        (item) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            '${item.orderItem.garmentType} (Qty: ${item.orderItem.quantity})',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${item.orderNumber} · Customer: ${item.customerName} · Promised: ${DateFormat('d MMM').format(item.deliveryDate)}',
                          ),
                          trailing: FilledButton.tonal(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    OrderDetailScreen(orderId: item.orderId),
                              ),
                            ),
                            child: const Text('Assign'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Karigar Workload List
            SectionHeader(
              title: 'Worker Workloads (${report.workerWorkloads.length})',
            ),
            const SizedBox(height: AppSpacing.xs),

            if (report.workerWorkloads.isEmpty)
              const EmptyState(
                icon: Icons.engineering_outlined,
                title: 'No karigars registered',
                subtitle:
                    'Add workers from More → Karigars to track workloads.',
              )
            else
              ...report.workerWorkloads.map(
                (item) => _KarigarWorkloadCard(item: item),
              ),
          ],
        );
      },
    );
  }
}

class _KarigarWorkloadCard extends StatelessWidget {
  const _KarigarWorkloadCard({required this.item});

  final KarigarWorkloadItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isInactive = item.karigar.status == 'inactive';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KarigarDetailScreen(karigarId: item.karigar.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          item.karigar.name,
                          style: theme.textTheme.titleMedium,
                        ),
                        if (isInactive) ...[
                          const SizedBox(width: 8),
                          const StatusBadge(
                            label: 'Inactive',
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ],
                    ),
                  ),
                  StatusBadge(
                    label: '${item.activeCount} active items',
                    color: item.activeCount > 0
                        ? AppColors.info
                        : AppColors.success,
                    backgroundColor: item.activeCount > 0
                        ? AppColors.infoBg
                        : AppColors.successBg,
                  ),
                ],
              ),
              if (item.karigar.skills.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Skills: ${item.karigar.skills}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 10),
              // Workload breakdown metrics row
              Row(
                children: [
                  _MetricPill(
                    label: 'Assigned',
                    count: item.assignedCount,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  _MetricPill(
                    label: 'In Progress',
                    count: item.inProgressCount,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 8),
                  _MetricPill(
                    label: 'Completed',
                    count: item.completedCount,
                    color: AppColors.success,
                  ),
                  if (item.overdueDeadlinesCount > 0) ...[
                    const SizedBox(width: 8),
                    _MetricPill(
                      label: 'Overdue',
                      count: item.overdueDeadlinesCount,
                      color: AppColors.error,
                    ),
                  ],
                ],
              ),
              if (item.activeAssignments.isNotEmpty) ...[
                const Divider(height: 18),
                Text(
                  'Current Active Work:',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                ...item.activeAssignments.map((assignment) {
                  final deadline = assignment.assignment.internalDeadline;
                  final deadlineStr = deadline != null
                      ? ' · Target: ${DateFormat('d MMM').format(deadline)}'
                      : '';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 6,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${assignment.orderItem.garmentType} (x${assignment.orderItem.quantity}) · ${assignment.order.orderNumber}$deadlineStr',
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        StatusBadge(
                          label: assignment.status.label,
                          color:
                              assignment.status == AssignmentStatus.inProgress
                              ? AppColors.info
                              : AppColors.warning,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
