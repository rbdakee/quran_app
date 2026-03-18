import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;

  const MetricCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceDefault,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.textTertiary),
            const SizedBox(height: 6),
          ],
          Text(value, style: AppTypography.titleLg.copyWith(fontSize: 26)),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
