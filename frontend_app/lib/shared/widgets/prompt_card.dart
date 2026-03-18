import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class PromptCard extends StatelessWidget {
  final Widget child;
  final double minHeight;

  const PromptCard({super.key, required this.child, this.minHeight = 140});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDefault,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: child,
    );
  }
}
