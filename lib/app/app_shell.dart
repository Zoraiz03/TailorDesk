import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_screen.dart';
import '../features/orders/orders_screen.dart';
import '../features/customers/customers_screen.dart';
import 'more_screen.dart';
import '../core/localization/localization_extensions.dart';

/// Responsive app shell: BottomNavigationBar on phones,
/// NavigationRail on tablets (width >= 600).
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  List<_Destination> _destinations(BuildContext context) => <_Destination>[
    _Destination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: context.l10n.home,
    ),
    _Destination(
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      label: context.l10n.orders,
    ),
    _Destination(
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      label: context.l10n.customers,
    ),
    _Destination(
      icon: Icons.more_horiz,
      selectedIcon: Icons.more_horiz,
      label: context.l10n.more,
    ),
  ];

  Widget _body() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const OrdersScreen();
      case 2:
        return const CustomersScreen();
      case 3:
        return const MoreScreen();
      default:
        return const DashboardScreen();
    }
  }

  Widget _content() => _body();

  @override
  Widget build(BuildContext context) {
    final destinations = _destinations(context);
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;

    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) =>
                  setState(() => _selectedIndex = index),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 12),
                child: Icon(
                  Icons.content_cut,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ),
              destinations: destinations
                  .map(
                    (d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: _content()),
          ],
        ),
      );
    }

    return Scaffold(
      body: _content(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: destinations
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Destination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _Destination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
