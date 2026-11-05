import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/appointment.dart';
import '../../../l10n/app_strings.dart';
import '../controllers/appointments_controller.dart';
import '../widgets/appointment_status_badge.dart';
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
  bool _deleting = false;
  bool _deleteFailed = false;
  bool _updatingStatus = false;
  bool _statusFailed = false;

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

  Future<void> _delete() async {
    if (_deleting) return;
    HapticFeedback.lightImpact();
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(AppStrings.of(context).deleteAppointment),
        content: Text(AppStrings.of(context).deleteAppointmentConfirmation),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(AppStrings.of(context).cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(AppStrings.of(context).delete),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    setState(() {
      _deleting = true;
      _deleteFailed = false;
    });
    try {
      await ref
          .read(appointmentsRepositoryProvider)
          .delete(uid: widget.uid, id: widget.appointmentId);
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (mounted) setState(() => _deleteFailed = true);
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  Future<void> _setStatus(AppointmentStatus status) async {
    if (_updatingStatus) return;
    HapticFeedback.lightImpact();
    if (status == AppointmentStatus.canceled) {
      final confirmed = await showCupertinoDialog<bool>(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: Text(AppStrings.of(context).cancelAppointment),
          content: Text(AppStrings.of(context).cancelAppointmentConfirmation),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(AppStrings.of(context).keepAppointment),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(AppStrings.of(context).cancelAppointment),
            ),
          ],
        ),
      );
      if (!mounted || confirmed != true) return;
    }
    setState(() {
      _updatingStatus = true;
      _statusFailed = false;
    });
    try {
      await ref
          .read(appointmentsRepositoryProvider)
          .setStatus(uid: widget.uid, id: widget.appointmentId, status: status);
    } catch (_) {
      if (mounted) setState(() => _statusFailed = true);
    } finally {
      if (mounted) setState(() => _updatingStatus = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = appointmentsProvider(widget.uid);
    final content = _deleting
        ? const Center(child: CupertinoActivityIndicator())
        : ref
              .watch(provider)
              .when(
                loading: () =>
                    const Center(child: CupertinoActivityIndicator()),
                error: (_, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppStrings.of(context).appointmentsLoadError),
                    CupertinoButton(
                      onPressed: () => ref.invalidate(provider),
                      child: Text(AppStrings.of(context).retry),
                    ),
                  ],
                ),
                data: (snapshot) {
                  final items = snapshot.items;
                  final appointment = items
                      .where((item) => item.id == widget.appointmentId)
                      .firstOrNull;
                  if (appointment == null) {
                    return Text(
                      snapshot.isFromCache
                          ? AppStrings.of(context).appointmentsAwaitingServer
                          : AppStrings.of(context).appointmentUnavailable,
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (snapshot.isFromCache) ...[
                        Text(
                          AppStrings.of(context).appointmentsCached,
                          style: TextStyle(color: AppTheme.of(context).muted),
                        ),
                        const SizedBox(height: AppTheme.medium),
                      ],
                      DecoratedBox(
                        decoration: AppTheme.of(context).card,
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
                              AppointmentStatusBadge(
                                status: appointment.status,
                              ),
                              const SizedBox(height: AppTheme.medium),
                              Text(
                                AppStrings.of(context)
                                    .formatDate(appointment.startsAt),
                              ),
                              Text(
                                AppStrings.formatTime(
                                  context,
                                  TimeOfDay.fromDateTime(appointment.startsAt),
                                ),
                              ),
                              if (appointment.location.isNotEmpty) ...[
                                const SizedBox(height: AppTheme.medium),
                                Text(
                                  AppStrings.of(context).location,
                                  style: TextStyle(
                                    color: AppTheme.of(context).muted,
                                  ),
                                ),
                                Text(appointment.location),
                              ],
                              if (appointment.notes.isNotEmpty) ...[
                                const SizedBox(height: AppTheme.medium),
                                Text(
                                  AppStrings.of(context).notes,
                                  style: TextStyle(
                                    color: AppTheme.of(context).muted,
                                  ),
                                ),
                                Text(appointment.notes),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.medium),
                      if (_updatingStatus)
                        const Center(child: CupertinoActivityIndicator())
                      else if (appointment.pending)
                        Text(
                          AppStrings.of(context).appointmentPending,
                          textAlign: TextAlign.center,
                        )
                      else if (_updated)
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            AppStrings.of(context).appointmentUpdated,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      CupertinoButton.filled(
                        borderRadius: AppTheme.corners,
                        onPressed: appointment.pending || _updatingStatus
                            ? null
                            : () => _edit(appointment),
                        child: Text(AppStrings.of(context).editAppointment),
                      ),
                      if (_statusFailed)
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            AppStrings.of(context).appointmentStatusError,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (appointment.status == AppointmentStatus.upcoming) ...[
                        CupertinoButton(
                          onPressed: appointment.pending || _updatingStatus
                              ? null
                              : () => _setStatus(AppointmentStatus.completed),
                          child: Text(
                            AppStrings.of(context).completeAppointment,
                          ),
                        ),
                        CupertinoButton(
                          onPressed: appointment.pending || _updatingStatus
                              ? null
                              : () => _setStatus(AppointmentStatus.canceled),
                          child: Text(AppStrings.of(context).cancelAppointment),
                        ),
                      ],
                      if (_deleteFailed)
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            AppStrings.of(context).appointmentDeleteError,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      CupertinoButton(
                        onPressed: appointment.pending || _updatingStatus
                            ? null
                            : _delete,
                        child: Text(
                          AppStrings.of(context).deleteAppointment,
                          style: appointment.pending
                              ? null
                              : TextStyle(
                                  color: CupertinoColors.systemRed.resolveFrom(
                                    context,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  );
                },
              );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppStrings.of(context).appointmentDetails),
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
