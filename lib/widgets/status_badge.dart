import 'package:flutter/material.dart';
import 'package:pollard/theme/app_theme.dart';

/// A small pill-shaped status badge ("In Stock" / "Low Stock" style).
class StatusBadge extends StatelessWidget {
  final String label;
  final Color background;
  final Color textColor;

  const StatusBadge({
    Key? key,
    required this.label,
    required this.background,
    required this.textColor,
  }) : super(key: key);

  /// Green success badge.
  factory StatusBadge.success(String label) => StatusBadge(
        label: label,
        background: AppColors.successBg,
        textColor: AppColors.successText,
      );

  /// Orange warning badge.
  factory StatusBadge.warning(String label) => StatusBadge(
        label: label,
        background: AppColors.warningBg,
        textColor: AppColors.warningText,
      );

  /// Red error badge.
  factory StatusBadge.error(String label) => StatusBadge(
        label: label,
        background: AppColors.errorBg,
        textColor: AppColors.errorText,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMd.copyWith(color: textColor),
      ),
    );
  }
}
