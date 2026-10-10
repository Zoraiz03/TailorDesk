import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A status badge chip with a coloured dot and label.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? backgroundColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.backgroundColor,
  });

  /// Convenience constructors for common order statuses.
  factory StatusBadge.pending() => const StatusBadge(
    label: 'Pending',
    color: AppColors.warning,
    backgroundColor: AppColors.warningBg,
  );

  factory StatusBadge.inProgress() => const StatusBadge(
    label: 'In Progress',
    color: AppColors.info,
    backgroundColor: AppColors.infoBg,
  );

  factory StatusBadge.ready() => const StatusBadge(
    label: 'Ready',
    color: AppColors.success,
    backgroundColor: AppColors.successBg,
  );

  factory StatusBadge.overdue() => const StatusBadge(
    label: 'Overdue',
    color: AppColors.error,
    backgroundColor: AppColors.errorBg,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
