import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPrimary,
          disabledBackgroundColor: AppColors.accentPrimary.withValues(
            alpha: 0.3,
          ),
          foregroundColor: AppColors.textInverse,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          elevation: 0,
        ),
        child: AnimatedSwitcher(
          duration: AppDurations.fast,
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.textPrimary,
                  ),
                )
              : Text(label, style: AppTypography.labelMd),
        ),
      ),
    );
  }
}
