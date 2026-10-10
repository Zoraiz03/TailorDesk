import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';

/// Karigars (tailors/workers) management screen — Stage 1 empty state.
class KarigarsScreen extends StatelessWidget {
  const KarigarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Karigars'), centerTitle: false),
      body: const EmptyState(
        icon: Icons.engineering_outlined,
        title: 'No karigars added',
        subtitle:
            'Add your tailors and workers here to assign orders and track their workload.',
      ),
    );
  }
}
