import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

enum FeedbackType { success, error, warning, info }

class FeedbackBanner extends StatelessWidget {
  final FeedbackType type;
  final String message;

  const FeedbackBanner({super.key, required this.type, required this.message});

  @override
  Widget build(BuildContext context) {
    final (bg, accent, icon) = _styleFor(type);

    return AnimatedContainer(
      duration: AppDurations.fast,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMd.copyWith(color: accent),
            ),
          ),
        ],
      ),
    );
  }

  static (Color bg, Color accent, IconData icon) _styleFor(FeedbackType t) {
    return switch (t) {
      FeedbackType.success => (
        AppColors.successBg,
        AppColors.successDefault,
        Icons.check_circle_outline,
      ),
      FeedbackType.error => (
        AppColors.errorBg,
        AppColors.errorDefault,
        Icons.cancel_outlined,
      ),
      FeedbackType.warning => (
        AppColors.warningBg,
        AppColors.warningDefault,
        Icons.warning_amber_outlined,
      ),
      FeedbackType.info => (
        AppColors.infoBg,
        AppColors.infoDefault,
        Icons.info_outline,
      ),
    };
  }
}
