import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show TimeOfDay;

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/brand_assets.dart';
import '../../../data/models/appointment.dart';
import '../../../l10n/app_strings.dart';
import 'appointment_status_badge.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    required this.appointment,
    required this.showTimeline,
    required this.onTap,
    super.key,
  });

  final Appointment appointment;
  final bool showTimeline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final strings = AppStrings.of(context);
    final time = AppStrings.formatTime(
      context,
      TimeOfDay.fromDateTime(appointment.startsAt),
    );
    final date = strings.formatDate(appointment.startsAt);
    final tint = appointment.status == AppointmentStatus.upcoming
        ? theme.sky
        : theme.peach;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: double.infinity,
        decoration: theme.card,
        padding: const EdgeInsets.all(AppTheme.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTimeline) ...[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: AppTheme.pill,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.medium,
                    vertical: AppTheme.small,
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: theme.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.small),
            ],
            Row(
              children: [
                if (!showTimeline) ...[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: tint,
                      borderRadius: AppTheme.corners,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.small),
                      child: BrandAssets.icon(BrandAssets.calendarCheck),
                    ),
                  ),
                  const SizedBox(width: AppTheme.small),
                ],
                Expanded(
                  child: Text(
                    appointment.title,
                    style: TextStyle(
                      color: theme.ink,
                      fontWeight: FontWeight.w700,
                      fontSize: AppTheme.bodyTextSize,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.small),
                Icon(
                  CupertinoIcons.chevron_right,
                  color: theme.muted,
                  size: AppTheme.captionTextSize,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.small),
            if (!showTimeline) Text('$date · $time', style: theme.caption),
            if (appointment.location.isNotEmpty)
              Row(
                children: [
                  BrandAssets.icon(BrandAssets.locationPin, size: 20),
                  const SizedBox(width: AppTheme.small),
                  Expanded(
                    child: Text(
                      appointment.location,
                      style: TextStyle(color: theme.muted),
                    ),
                  ),
                ],
              ),
            if (appointment.notes.isNotEmpty)
              Text(
                appointment.notes,
                style: TextStyle(color: theme.muted),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: AppTheme.small),
            AppointmentStatusBadge(status: appointment.status),
            if (appointment.pending)
              Text(strings.appointmentPending, style: theme.caption),
          ],
        ),
      ),
    );
  }
}
