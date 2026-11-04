import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/appointment.dart';
import '../../../l10n/app_strings.dart';
import '../controllers/appointments_controller.dart';
import 'appointment_form.dart';

class AppointmentDetailScreen extends ConsumerStatefulWidget {
  const AppointmentDetailScreen({
    required this.uid,
    required this.appointmentId,
    super.key,
  });

  final String uid;
  final String appointmentId;

  @override
  ConsumerState<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState
    extends ConsumerState<AppointmentDetailScreen> {
  bool _updated = false;

  Future<void> _edit(Appointment appointment) async {
    HapticFeedback.lightImpact();
    final updated = await Navigator.of(context).push<bool>(
      CupertinoPageRoute(
        builder: (_) =>
            AppointmentForm(uid: widget.uid, appointment: appointment),
      ),
    );
    if (mounted && updated == true) setState(() => _updated = true);
  }

  @override
  Widget build(BuildContext context) {
    final provider = appointmentsProvider(widget.uid);
    final content = ref
        .watch(provider)
        .when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (_, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(AppStrings.appointmentsLoadError),
              CupertinoButton(
                onPressed: () => ref.invalidate(provider),
                child: const Text(AppStrings.retry),
              ),
            ],
          ),
          data: (items) {
            final appointment = items
                .where((item) => item.id == widget.appointmentId)
                .firstOrNull;
            if (appointment == null) {
              return const Text(AppStrings.appointmentUnavailable);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DecoratedBox(
                  decoration: AppTheme.card,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.large),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.title,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navTitleTextStyle,
                        ),
                        const SizedBox(height: AppTheme.medium),
                        Text(AppStrings.formatDate(appointment.startsAt)),
                        Text(
                          TimeOfDay.fromDateTime(appointment.startsAt)
                              .format(context),
                        ),
                        if (appointment.location.isNotEmpty) ...[
                          const SizedBox(height: AppTheme.medium),
                          const Text(
                            AppStrings.location,
                            style: TextStyle(color: AppTheme.muted),
                          ),
                          Text(appointment.location),
                        ],
                        if (appointment.notes.isNotEmpty) ...[
                          const SizedBox(height: AppTheme.medium),
                          const Text(
                            AppStrings.notes,
                            style: TextStyle(color: AppTheme.muted),
                          ),
                          Text(appointment.notes),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.medium),
                if (appointment.pending)
                  const Text(
                    AppStrings.appointmentPending,
                    textAlign: TextAlign.center,
                  )
                else if (_updated)
                  Semantics(
                    liveRegion: true,
                    child: const Text(
                      AppStrings.appointmentUpdated,
                      textAlign: TextAlign.center,
                    ),
                  ),
                CupertinoButton.filled(
                  borderRadius: AppTheme.corners,
                  onPressed: appointment.pending
                      ? null
                      : () => _edit(appointment),
                  child: const Text(AppStrings.editAppointment),
                ),
              ],
            );
          },
        );

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(AppStrings.appointmentDetails),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppTheme.contentWidth),
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.large),
              children: [content],
            ),
          ),
        ),
      ),
    );
  }
}
