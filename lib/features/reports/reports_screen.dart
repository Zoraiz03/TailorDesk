import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';

/// Reports screen — Stage 1 empty state.
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports'), centerTitle: false),
      body: const EmptyState(
        icon: Icons.bar_chart_outlined,
        title: 'No reports available',
        subtitle:
            'Business reports and analytics will be generated from your order and payment data.',
      ),
    );
  }
}
