import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/summary_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_badge.dart';
import '../customers/customer_form_screen.dart';
import '../measurements/measurements_screen.dart';
import '../orders/new_order_placeholder_screen.dart';

/// Dashboard home screen with shop overview, summary metrics,
/// upcoming deliveries, and quick actions.
///
/// All data shown is clearly labelled demo data for Stage 1.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, d MMMM yyyy');

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.content_cut,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Stitch & Style Studio',
                                style: theme.textTheme.titleLarge,
                              ),
                              Text(
                                dateFormat.format(now),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── New Order Button ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NewOrderPlaceholderScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('New Order'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                ),
              ),
            ),

            // ── Summary Cards ───────────────────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: SectionHeader(title: 'Overview'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.45,
                children: const [
                  SummaryCard(
                    title: 'Active Orders',
                    value: '12',
                    icon: Icons.receipt_long,
                    iconColor: AppColors.primary,
                  ),
                  SummaryCard(
                    title: 'Due Today',
                    value: '3',
                    icon: Icons.today,
                    iconColor: AppColors.info,
                    iconBackgroundColor: AppColors.infoBg,
                  ),
                  SummaryCard(
                    title: 'Overdue',
                    value: '2',
                    icon: Icons.warning_amber_rounded,
                    iconColor: AppColors.error,
                    iconBackgroundColor: AppColors.errorBg,
                  ),
                  SummaryCard(
                    title: 'Outstanding',
                    value: 'PKR 45,800',
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: AppColors.gold,
                    iconBackgroundColor: AppColors.goldLight,
                  ),
                ],
              ),
            ),

            // ── Upcoming Deliveries ─────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: SectionHeader(
                  title: 'Upcoming Deliveries',
                  actionLabel: 'View All',
                  onAction: () {},
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate(_demoDeliveries(context)),
              ),
            ),

            // ── Demo Data Notice ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.infoBg,
                    borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Showing demo data — records are not saved yet.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Quick Actions ───────────────────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: SectionHeader(title: 'Quick Actions'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.person_add_outlined,
                        label: 'Add Customer',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CustomerFormScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.straighten_outlined,
                        label: 'Measurements',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MeasurementsScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _demoDeliveries(BuildContext context) {
    final deliveries = [
      _DeliveryItem(
        customer: 'Ahmed Khan',
        garment: 'Shalwar Kameez (2 pcs)',
        dueDate: 'Today',
        status: StatusBadge.inProgress(),
      ),
      _DeliveryItem(
        customer: 'Bilal Hussain',
        garment: 'Sherwani',
        dueDate: 'Tomorrow',
        status: StatusBadge.ready(),
      ),
      _DeliveryItem(
        customer: 'Usman Tariq',
        garment: 'Waistcoat + Trouser',
        dueDate: '14 Oct',
        status: StatusBadge.pending(),
      ),
      _DeliveryItem(
        customer: 'Farhan Ali',
        garment: 'Kurta (3 pcs)',
        dueDate: '8 Oct',
        status: StatusBadge.overdue(),
      ),
    ];

    return deliveries
        .map(
          (d) => Padding(padding: const EdgeInsets.only(bottom: 8), child: d),
        )
        .toList();
  }
}

// ─── Private widgets ──────────────────────────────────────────────────────────

class _DeliveryItem extends StatelessWidget {
  final String customer;
  final String garment;
  final String dueDate;
  final StatusBadge status;

  const _DeliveryItem({
    required this.customer,
    required this.garment,
    required this.dueDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Customer initial
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  customer.isNotEmpty ? customer[0].toUpperCase() : '?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    garment,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Due + status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(dueDate, style: theme.textTheme.labelSmall),
                const SizedBox(height: 4),
                status,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
