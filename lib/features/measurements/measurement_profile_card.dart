import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'measurement_models.dart';
import 'measurement_templates.dart';

class MeasurementProfileCard extends StatelessWidget {
  const MeasurementProfileCard({
    super.key,
    required this.record,
    required this.onTap,
  });

  final MeasurementProfileRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final revision = record.latestRevision;
    final garment = GarmentType.fromStorage(revision.garmentType);
    final unit = MeasurementUnit.fromStorage(revision.unit);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.straighten, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${garment.label} · ${revision.profileName}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${unit.label} · Updated ${DateFormat('d MMM yyyy').format(record.profile.updatedAt)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
