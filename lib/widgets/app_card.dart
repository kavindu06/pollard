import 'package:flutter/material.dart';
import 'package:pollard/theme/app_theme.dart';

/// White bordered card (Level 1 surface) used across all list/summary layouts.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color color;

  const AppCard({
    Key? key,
    required this.child,
    this.padding,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
