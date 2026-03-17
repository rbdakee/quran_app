import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Design system typography tokens
abstract final class AppTypography {
  // ── Font Families ──
  static const fontFamilySans = 'Inter';
  static const fontFamilyArabic = 'NotoNaskhArabic';

  // ── Display ──
  static const displayLg = TextStyle(
    fontFamily: fontFamilySans,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Titles ──
  static const titleLg = TextStyle(
    fontFamily: fontFamilySans,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const titleMd = TextStyle(
    fontFamily: fontFamilySans,
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const titleSm = TextStyle(
    fontFamily: fontFamilySans,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Body ──
  static const bodyLg = TextStyle(
    fontFamily: fontFamilySans,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const bodyMd = TextStyle(
    fontFamily: fontFamilySans,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const bodySm = TextStyle(
    fontFamily: fontFamilySans,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // ── Labels ──
  static const labelMd = TextStyle(
    fontFamily: fontFamilySans,
    fontSize: 14,
    height: 18 / 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const labelSm = TextStyle(
    fontFamily: fontFamilySans,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // ── Arabic ──
  static const arabicWord = TextStyle(
    fontFamily: fontFamilyArabic,
    fontSize: 32,
    height: 44 / 32,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const arabicSegment = TextStyle(
    fontFamily: fontFamilyArabic,
    fontSize: 24,
    height: 36 / 24,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const arabicInline = TextStyle(
    fontFamily: fontFamilyArabic,
    fontSize: 18,
    height: 28 / 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
}
