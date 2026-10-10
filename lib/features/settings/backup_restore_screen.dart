import 'package:flutter/material.dart';

import '../../core/widgets/empty_state.dart';

/// Backup & Restore screen — Stage 1 empty state.
class BackupRestoreScreen extends StatelessWidget {
  const BackupRestoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore'), centerTitle: false),
      body: const EmptyState(
        icon: Icons.backup_outlined,
        title: 'Backup & restore',
        subtitle:
            'Export your data to a file and restore it when needed. '
            'This feature will be available once business data modules are complete.',
      ),
    );
  }
}
