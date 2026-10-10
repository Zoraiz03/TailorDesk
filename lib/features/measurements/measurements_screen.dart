import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';

/// Measurements screen — Stage 1 empty state.
class MeasurementsScreen extends StatelessWidget {
  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Measurements'), centerTitle: false),
      body: const EmptyState(
        icon: Icons.straighten_outlined,
        title: 'No measurements recorded',
        subtitle:
            'Measurement profiles will be linked to customers. Add a customer first, then record their measurements.',
      ),
    );
  }
}
