import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// MVP dark theme
ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgPrimary,
    fontFamily: AppTypography.fontFamilySans,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentPrimary,
      onPrimary: AppColors.textInverse,
      surface: AppColors.surfaceDefault,
      onSurface: AppColors.textPrimary,
      error: AppColors.errorDefault,
      onError: AppColors.textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypography.titleSm,
      toolbarHeight: AppSpacing.appBarHeight,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerDefault,
      thickness: 1,
      space: 0,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceDefault,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: const BorderSide(color: AppColors.borderDefault),
      ),
      margin: EdgeInsets.zero,
    ),
  );
}
