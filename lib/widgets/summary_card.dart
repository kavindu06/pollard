import 'package:flutter/material.dart';
import 'package:pollard/theme/app_theme.dart';

/// Solid blue hero card with an uppercase label, a large amount, and an
/// optional caption — matches the "Today's Sales" dashboard card.
class SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String? caption;

  const SummaryCard({
    Key? key,
    required this.label,
    required this.value,
    this.caption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelMd.copyWith(color: AppColors.onPrimaryMuted),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.displayBilling.copyWith(color: AppColors.onPrimary),
          ),
          if (caption != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              caption!,
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onPrimaryMuted),
            ),
          ],
        ],
      ),
    );
  }
}
