import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/localization/localization_extensions.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/summary_card.dart';
import '../customers/customer_form_screen.dart';
import '../karigars/karigars_screen.dart';
import '../measurements/measurements_screen.dart';
import '../orders/new_order_screen.dart';
import '../orders/order_detail_screen.dart';
import '../orders/order_formatters.dart';
import '../orders/order_providers.dart';
import '../reports/reports_screen.dart';
import '../settings/shop_settings_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(dashboardMetricsProvider);
    final shopDetails = ref.watch(shopDetailsProvider);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.content_cut, color: Colors.white),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shopDetails.value?.name ?? 'TailorDesk',
                            style: theme.textTheme.titleLarge,
                          ),
                          Text(
                            DateFormat.yMMMMEEEEd(
                              Localizations.localeOf(context).toLanguageTag(),
                            ).format(DateTime.now()),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NewOrderScreen()),
                  ),
                  icon: const Icon(Icons.add),
                  label: Text(context.l10n.newOrder),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: SectionHeader(title: context.l10n.overview),
              ),
            ),
            metrics.when(
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => SliverToBoxAdapter(
                child: EmptyState(
                  icon: Icons.error_outline,
                  title: context.l10n.couldNotLoad,
                  subtitle: context.l10n.savedDataUnchanged,
                  action: OutlinedButton.icon(
                    onPressed: () => ref.invalidate(dashboardMetricsProvider),
                    icon: const Icon(Icons.refresh),
                    label: Text(context.l10n.tryAgain),
                  ),
                ),
              ),
              data: (value) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) => SliverGrid.count(
                    crossAxisCount: constraints.crossAxisExtent >= 900 ? 4 : 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: constraints.crossAxisExtent >= 900
                        ? 1.8
                        : 1.45,
                    children: [
                      SummaryCard(
                        title: context.l10n.activeOrders,
                        value: '${value.activeOrders}',
                        icon: Icons.receipt_long,
                      ),
                      SummaryCard(
                        title: context.l10n.dueToday,
                        value: '${value.dueToday}',
                        icon: Icons.today,
                        iconColor: AppColors.info,
                        iconBackgroundColor: AppColors.infoBg,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ReportsScreen(initialTabIndex: 0),
                          ),
                        ),
                      ),
                      SummaryCard(
                        title: context.l10n.overdue,
                        value: '${value.overdue}',
                        icon: Icons.warning_amber_rounded,
                        iconColor: AppColors.error,
                        iconBackgroundColor: AppColors.errorBg,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ReportsScreen(initialTabIndex: 0),
                          ),
                        ),
                      ),
                      SummaryCard(
                        title: context.l10n.outstanding,
                        value: formatPaisa(value.outstandingPaisa),
                        icon: Icons.account_balance_wallet_outlined,
                        iconColor: AppColors.gold,
                        iconBackgroundColor: AppColors.goldLight,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ReportsScreen(initialTabIndex: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: SectionHeader(title: context.l10n.workshop),
              ),
            ),
            metrics.when(
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (_, __) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
              data: (value) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.45,
                  children: [
                    SummaryCard(
                      title: context.l10n.unassignedItems,
                      value: '${value.unassignedItems}',
                      icon: Icons.assignment_ind_outlined,
                      iconColor: AppColors.warning,
                      iconBackgroundColor: AppColors.warningBg,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ReportsScreen(initialTabIndex: 3),
                        ),
                      ),
                    ),
                    SummaryCard(
                      title: context.l10n.karigarOverdue,
                      value: '${value.overdueAssignments}',
                      icon: Icons.engineering_outlined,
                      iconColor: AppColors.error,
                      iconBackgroundColor: AppColors.errorBg,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ReportsScreen(initialTabIndex: 3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: SectionHeader(title: context.l10n.upcomingDeliveries),
              ),
            ),
            metrics.when(
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (_, __) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
              data: (value) => value.upcoming.isEmpty
                  ? SliverToBoxAdapter(
                      child: EmptyState(
                        icon: Icons.event_available_outlined,
                        title: context.l10n.noUpcomingDeliveries,
                        subtitle: context.l10n.activeOrdersAppearHere,
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList.builder(
                        itemCount: value.upcoming.length,
                        itemBuilder: (_, index) {
                          final record = value.upcoming[index];
                          return Card(
                            child: ListTile(
                              title: Text(record.customer.name),
                              subtitle: Text(
                                '${record.order.orderNumber} · ${localizedStatus(context.l10n, record.progress.name)}',
                              ),
                              trailing: Text(
                                DateFormat.MMMd().format(
                                  record.order.deliveryDate,
                                ),
                              ),
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
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: SectionHeader(title: context.l10n.quickActions),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.person_add_outlined,
                        label: context.l10n.addCustomer,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CustomerFormScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.straighten_outlined,
                        label: context.l10n.measurements,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MeasurementsScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.engineering_outlined,
                        label: context.l10n.karigars,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const KarigarsScreen(),
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
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(label),
          ],
        ),
      ),
    ),
  );
}
