import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/appointment.dart';
import '../../../l10n/app_strings.dart';

class AppointmentStatusBadge extends StatelessWidget {
  const AppointmentStatusBadge({required this.status, super.key});

  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final label = AppStrings.of(context).statusLabel(status);
    final icon = switch (status) {
      AppointmentStatus.upcoming => CupertinoIcons.clock,
      AppointmentStatus.completed => CupertinoIcons.check_mark_circled,
      AppointmentStatus.canceled => CupertinoIcons.xmark_circle,
    };
    final color = status == AppointmentStatus.upcoming
        ? AppTheme.accent
        : AppTheme.muted;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: AppTheme.corners,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.small,
          vertical: AppTheme.small,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: AppTheme.small),
            Flexible(
              child: Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
