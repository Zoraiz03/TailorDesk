import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';
import 'new_order_placeholder_screen.dart';

/// Orders listing screen — Stage 1 empty state.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders'), centerTitle: false),
      body: EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No orders yet',
        subtitle:
            'Orders will appear here once you start creating them. Tap the button below to create your first order.',
        action: FilledButton.icon(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const NewOrderPlaceholderScreen(),
            ),
          ),
          icon: const Icon(Icons.add, size: 20),
          label: const Text('New Order'),
        ),
      ),
    );
  }
}
