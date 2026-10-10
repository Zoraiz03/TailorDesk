import 'package:flutter/material.dart';

import '../features/karigars/karigars_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/settings/backup_restore_screen.dart';
import '../features/settings/settings_screen.dart';
import '../core/theme/app_colors.dart';

/// The "More" tab showing access to secondary features.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More'), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _MoreTile(
            icon: Icons.engineering_outlined,
            label: 'Karigars',
            subtitle: 'Manage tailors and workers',
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const KarigarsScreen())),
          ),
          _MoreTile(
            icon: Icons.bar_chart_outlined,
            label: 'Reports',
            subtitle: 'Business analytics and summaries',
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ReportsScreen())),
          ),
          _MoreTile(
            icon: Icons.backup_outlined,
            label: 'Backup & Restore',
            subtitle: 'Export and import your data',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BackupRestoreScreen()),
            ),
          ),
          _MoreTile(
            icon: Icons.settings_outlined,
            label: 'Settings',
            subtitle: 'App preferences and configuration',
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _MoreTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(label, style: theme.textTheme.titleSmall),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
      trailing: const Icon(Icons.chevron_right, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      onTap: onTap,
    );
  }
}
