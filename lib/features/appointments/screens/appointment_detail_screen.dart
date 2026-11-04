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
        title: const Text(AppStrings.deleteAppointment),
        content: const Text(AppStrings.deleteAppointmentConfirmation),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AppStrings.delete),
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
          title: const Text(AppStrings.cancelAppointment),
          content: const Text(AppStrings.cancelAppointmentConfirmation),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(AppStrings.keepAppointment),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(AppStrings.cancelAppointment),
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
                              AppointmentStatusBadge(
                                status: appointment.status,
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
                      if (_updatingStatus)
                        const Center(child: CupertinoActivityIndicator())
                      else if (appointment.pending)
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
                        onPressed: appointment.pending || _updatingStatus
                            ? null
                            : () => _edit(appointment),
                        child: const Text(AppStrings.editAppointment),
                      ),
                      if (_statusFailed)
                        Semantics(
                          liveRegion: true,
                          child: const Text(
                            AppStrings.appointmentStatusError,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (appointment.status == AppointmentStatus.upcoming) ...[
                        CupertinoButton(
                          onPressed: appointment.pending || _updatingStatus
                              ? null
                              : () => _setStatus(AppointmentStatus.completed),
                          child: const Text(AppStrings.completeAppointment),
                        ),
                        CupertinoButton(
                          onPressed: appointment.pending || _updatingStatus
                              ? null
                              : () => _setStatus(AppointmentStatus.canceled),
                          child: const Text(AppStrings.cancelAppointment),
                        ),
                      ],
                      if (_deleteFailed)
                        Semantics(
                          liveRegion: true,
                          child: const Text(
                            AppStrings.appointmentDeleteError,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      CupertinoButton(
                        onPressed: appointment.pending || _updatingStatus
                            ? null
                            : _delete,
                        child: Text(
                          AppStrings.deleteAppointment,
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
