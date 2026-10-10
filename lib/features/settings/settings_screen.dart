import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';

/// Settings screen — Stage 1 empty state.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: false),
      body: const EmptyState(
        icon: Icons.settings_outlined,
        title: 'Settings',
        subtitle:
            'App preferences, shop details, and configuration options will appear here.',
      ),
    );
  }
}
