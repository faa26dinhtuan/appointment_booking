import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show DateUtils, TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
import '../controllers/appointments_controller.dart';
import 'appointment_empty_state.dart';

class AppointmentList extends ConsumerWidget {
  const AppointmentList({required this.uid, this.day, super.key});

  final String uid;
  final DateTime? day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = appointmentsProvider(uid);
    return ref
        .watch(provider)
        .when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (_, _) => Column(
            children: [
              const Text(AppStrings.appointmentsLoadError),
              CupertinoButton(
                onPressed: () => ref.invalidate(provider),
                child: const Text(AppStrings.retry),
              ),
            ],
          ),
          data: (appointments) {
            final visible = appointments
                .where(
                  (appointment) =>
                      day == null ||
                      DateUtils.isSameDay(day, appointment.startsAt),
                )
                .toList();
            if (visible.isEmpty) {
              return AppointmentEmptyState(isCalendar: day != null);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final appointment in visible)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.medium),
                    child: DecoratedBox(
                      decoration: AppTheme.card,
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.medium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppTheme.small),
                            Text(AppStrings.formatDate(appointment.startsAt)),
                            Text(
                              TimeOfDay.fromDateTime(appointment.startsAt)
                                  .format(context),
                            ),
                            if (appointment.location.isNotEmpty)
                              Text(appointment.location),
                            if (appointment.notes.isNotEmpty)
                              Text(appointment.notes),
                            if (appointment.pending)
                              const Text(AppStrings.appointmentPending),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
  }
}
