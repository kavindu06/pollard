import 'package:flutter/material.dart';
import 'package:pollard/theme/app_theme.dart';
import 'app_card.dart';

/// White stat card: uppercase label, large value, optional caption, and a
/// trailing icon chip — matches the "Total Orders" dashboard card.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? caption;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final Color? valueColor;

  const StatCard({
    Key? key,
    required this.label,
    required this.value,
    this.caption,
    required this.icon,
    this.iconColor = AppColors.primary,
    this.iconBackground = AppColors.surfaceContainer,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(), style: AppTextStyles.labelMd),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  value,
                  style: AppTextStyles.headlineLg.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? AppColors.onSurface,
                  ),
                ),
                if (caption != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(caption!, style: AppTextStyles.bodyMd),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
        ],
      ),
    );
  }
}

/// Full-width tinted alert card ("Low Stock Alerts" style).
class AlertCard extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const AlertCard({
    Key? key,
    required this.label,
    required this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.errorContainer,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: AppTextStyles.labelMd
                          .copyWith(color: AppColors.onErrorContainer),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      value,
                      style: AppTextStyles.headlineLg
                          .copyWith(color: AppColors.onErrorContainer),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: const Icon(Icons.warning_amber_outlined,
                    size: 22, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
