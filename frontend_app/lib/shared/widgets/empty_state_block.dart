import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import 'primary_button.dart';

class EmptyStateBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String? ctaLabel;
  final VoidCallback? onCta;

  const EmptyStateBlock({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.ctaLabel,
    this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: AppColors.textTertiary),
          const SizedBox(height: AppSpacing.s5),
          Text(title, style: AppTypography.titleMd, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.s2),
          Text(
            body,
            style: AppTypography.bodyMd.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (ctaLabel != null) ...[
            const SizedBox(height: AppSpacing.s6),
            SizedBox(
              width: 220,
              child: PrimaryButton(label: ctaLabel!, onPressed: onCta),
            ),
          ],
        ],
      ),
    );
  }
}
