import 'package:flutter/material.dart';

/// Design system color tokens (MVP v1 — dark theme only)
abstract final class AppColors {
  // ── Core Surfaces ──
  static const bgPrimary = Color(0xFF0F1115);
  static const bgSecondary = Color(0xFF131722);
  static const surfaceDefault = Color(0xFF171A21);
  static const surfaceElevated = Color(0xFF1E2430);
  static const surfaceMuted = Color(0xFF222A38);

  // ── Text ──
  static const textPrimary = Color(0xFFF5F7FA);
  static const textSecondary = Color(0xFFA7B0C0);
  static const textTertiary = Color(0xFF7E8798);
  static const textInverse = Color(0xFF0F1115);

  // ── Brand / Action ──
  static const accentPrimary = Color(0xFF5B8CFF);
  static const accentPrimaryHover = Color(0xFF6C98FF);
  static const accentPrimaryPressed = Color(0xFF4D7DF2);

  // ── Semantic ──
  static const successDefault = Color(0xFF23C16B);
  static const successBg = Color(0xFF163526);
  static const warningDefault = Color(0xFFF5B83D);
  static const warningBg = Color(0xFF3B2B12);
  static const errorDefault = Color(0xFFFF5D5D);
  static const errorBg = Color(0xFF3F1D24);
  static const infoDefault = Color(0xFF4DA3FF);
  static const infoBg = Color(0xFF14283E);

  // ── Borders & Dividers ──
  static const borderDefault = Color(0xFF2A3140);
  static const borderStrong = Color(0xFF3A4356);
  static const borderFocus = Color(0xFF7AA2FF);
  static const dividerDefault = Color(0xFF232A36);

  // ── Overlays ──
  static const overlayHover = Color(0x0AFFFFFF); // 4%
  static const overlayPressed = Color(0x14FFFFFF); // 8%
  static const overlayScrim = Color(0x7A000000); // 48%
}
