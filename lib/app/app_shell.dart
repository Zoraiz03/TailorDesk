import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_screen.dart';
import '../features/orders/orders_screen.dart';
import '../features/customers/customers_screen.dart';
import 'more_screen.dart';

/// Responsive app shell: BottomNavigationBar on phones,
/// NavigationRail on tablets (width >= 600).
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const _destinations = <_Destination>[
    _Destination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    _Destination(
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      label: 'Orders',
    ),
    _Destination(
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      label: 'Customers',
    ),
    _Destination(
      icon: Icons.more_horiz,
      selectedIcon: Icons.more_horiz,
      label: 'More',
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

  @override
  Widget build(BuildContext context) {
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
              destinations: _destinations
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
            Expanded(child: _body()),
          ],
        ),
      );
    }

    return Scaffold(
      body: _body(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: _destinations
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
