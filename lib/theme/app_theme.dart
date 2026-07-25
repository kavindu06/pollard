import 'package:flutter/material.dart';

/// Design tokens from the Stitch "Efficient Commerce Core" design system
/// (see stitch_retail_inventory_billing_system/efficient_commerce_core/DESIGN.md).
class AppColors {
  AppColors._();

  static const surface = Color(0xFFF9F9FF);
  static const surfaceContainerLow = Color(0xFFF0F3FF);
  static const surfaceContainer = Color(0xFFE7EEFE);
  static const surfaceContainerHigh = Color(0xFFE2E8F8);
  static const onSurface = Color(0xFF151C27);
  static const onSurfaceVariant = Color(0xFF414754);
  static const outline = Color(0xFF727785);
  static const outlineVariant = Color(0xFFC1C6D6);

  static const primary = Color(0xFF005BBF);
  static const primaryContainer = Color(0xFF1A73E8);
  static const onPrimary = Colors.white;
  static const onPrimaryMuted = Color(0xE6FFFFFF);

  static const secondary = Color(0xFF555F70);
  static const secondaryContainer = Color(0xFFD6E0F4);
  static const onSecondaryContainer = Color(0xFF596374);

  static const tertiary = Color(0xFF006A61);
  static const tertiaryContainer = Color(0xFF00857A);

  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // Semantic status colors used for badges (in-stock / low-stock / etc).
  static const successBg = Color(0xFFD9F2E6);
  static const successText = Color(0xFF00693E);
  static const warningBg = Color(0xFFFFE9CC);
  static const warningText = Color(0xFF8A5300);
  static const errorBg = errorContainer;
  static const errorText = onErrorContainer;

  // Categorical chart series colors (validated pair, ΔE 9.8 protan / 16.1
  // normal-vision — see dataviz skill palette check). Used for Buying vs
  // Selling series across the analytics graphs.
  static const chartBuying = primary;
  static const chartSelling = Color(0xFF7C4DFF);
}

class AppTextStyles {
  AppTextStyles._();

  static const fontFamily = 'Inter';

  static const displayBilling = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.02,
    color: AppColors.onSurface,
  );

  static const headlineLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    color: AppColors.onSurface,
  );

  static const headlineMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    color: AppColors.onSurface,
  );

  static const bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.onSurface,
  );

  static const bodyMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.onSurfaceVariant,
  );

  static const labelMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.05,
    color: AppColors.onSurfaceVariant,
  );

  static const dataMono = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: -0.01,
    color: AppColors.onSurface,
  );
}

class AppRadius {
  AppRadius._();

  static const sm = 2.0;
  static const standard = 4.0;
  static const md = 6.0;
  static const lg = 8.0;
  static const xl = 12.0;
  static const full = 9999.0;
}

class AppSpacing {
  AppSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const marginMobile = 16.0;
}

/// App-wide Material ThemeData built from the tokens above.
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: AppTextStyles.fontFamily,
    scaffoldBackgroundColor: AppColors.surface,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryContainer,
      tertiary: AppColors.tertiary,
      error: AppColors.error,
      errorContainer: AppColors.errorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.onSurface),
      titleTextStyle: AppTextStyles.headlineMd,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.standard),
        ),
        textStyle: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.standard),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.standard),
        borderSide: const BorderSide(color: AppColors.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.standard),
        borderSide: const BorderSide(color: AppColors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.standard),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.outlineVariant),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
