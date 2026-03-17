import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

enum StatusBannerType { offline, apiError, maintenance }

class StatusBanner extends StatelessWidget {
  final StatusBannerType type;
  final String? message;

  const StatusBanner({
    super.key,
    required this.type,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, accent, icon, defaultMsg) = _styleFor(type);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      color: bg,
      child: Row(
        children: [
          Icon(icon, size: 18, color: accent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message ?? defaultMsg,
              style: AppTypography.bodySm.copyWith(color: accent),
            ),
          ),
        ],
      ),
    );
  }

  static (Color, Color, IconData, String) _styleFor(StatusBannerType t) {
    return switch (t) {
      StatusBannerType.offline => (
        AppColors.warningBg,
        AppColors.warningDefault,
        Icons.wifi_off,
        'Нет подключения к интернету',
      ),
      StatusBannerType.apiError => (
        AppColors.errorBg,
        AppColors.errorDefault,
        Icons.error_outline,
        'Ошибка сервера',
      ),
      StatusBannerType.maintenance => (
        AppColors.infoBg,
        AppColors.infoDefault,
        Icons.construction,
        'Техническое обслуживание',
      ),
    };
  }
}
