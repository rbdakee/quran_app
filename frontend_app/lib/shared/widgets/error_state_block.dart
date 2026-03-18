import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import 'primary_button.dart';

class ErrorStateBlock extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorStateBlock({
    super.key,
    this.message = 'Не удалось загрузить данные',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 56,
            color: AppColors.errorDefault,
          ),
          const SizedBox(height: AppSpacing.s5),
          Text(
            message,
            style: AppTypography.bodyLg,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.s6),
            SizedBox(
              width: 200,
              child: PrimaryButton(label: 'Повторить', onPressed: onRetry),
            ),
          ],
        ],
      ),
    );
  }
}
