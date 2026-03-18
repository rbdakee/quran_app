import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

enum OptionState { idle, selected, correct, wrongSelected, disabled }

class OptionTile extends StatelessWidget {
  final String text;
  final OptionState state;
  final VoidCallback? onTap;

  const OptionTile({
    super.key,
    required this.text,
    this.state = OptionState.idle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, border, textColor, icon) = _styleFor(state);

    return GestureDetector(
      onTap: state == OptionState.disabled ? null : onTap,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        height: AppSpacing.optionHeight,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: AppTypography.bodyLg.copyWith(color: textColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 20, color: textColor),
            ],
          ],
        ),
      ),
    );
  }

  static (Color bg, Color border, Color text, IconData? icon) _styleFor(
    OptionState s,
  ) {
    return switch (s) {
      OptionState.idle => (
        Colors.transparent,
        AppColors.borderDefault,
        AppColors.textPrimary,
        null,
      ),
      OptionState.selected => (
        AppColors.accentPrimary.withValues(alpha: 0.1),
        AppColors.accentPrimary,
        AppColors.textPrimary,
        null,
      ),
      OptionState.correct => (
        AppColors.successBg,
        AppColors.successDefault,
        AppColors.successDefault,
        Icons.check_circle_outline,
      ),
      OptionState.wrongSelected => (
        AppColors.errorBg,
        AppColors.errorDefault,
        AppColors.errorDefault,
        Icons.cancel_outlined,
      ),
      OptionState.disabled => (
        Colors.transparent,
        AppColors.borderDefault.withValues(alpha: 0.4),
        AppColors.textTertiary,
        null,
      ),
    };
  }
}
