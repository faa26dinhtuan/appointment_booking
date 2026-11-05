import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/brand_assets.dart';
import '../../../data/models/appointment.dart';
import '../../../l10n/app_strings.dart';

class AppointmentStatusBadge extends StatelessWidget {
  const AppointmentStatusBadge({required this.status, super.key});

  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final label = AppStrings.of(context).statusLabel(status);
    final icon = switch (status) {
      AppointmentStatus.upcoming => BrandAssets.clock,
      AppointmentStatus.completed => BrandAssets.completed,
      AppointmentStatus.canceled => BrandAssets.canceled,
    };
    final theme = AppTheme.of(context);
    final (color, background) = switch (status) {
      AppointmentStatus.upcoming => (theme.accent, theme.sky),
      AppointmentStatus.completed => (theme.success, theme.background),
      AppointmentStatus.canceled => (theme.danger, theme.peach),
    };
    return DecoratedBox(
      decoration: BoxDecoration(color: background, borderRadius: AppTheme.pill),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.small,
          vertical: AppTheme.small,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrandAssets.icon(icon, size: 20),
            const SizedBox(width: AppTheme.small),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: AppTheme.captionTextSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
