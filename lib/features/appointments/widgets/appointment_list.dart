import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show DateUtils, ScaffoldMessenger, SnackBar, TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/appointment.dart';
import '../../../l10n/app_strings.dart';
import '../controllers/appointments_controller.dart';
import '../screens/appointment_detail_screen.dart';
import 'appointment_empty_state.dart';
import 'appointment_status_badge.dart';

class AppointmentList extends ConsumerStatefulWidget {
  const AppointmentList({required this.uid, this.day, super.key});

  final String uid;
  final DateTime? day;

  @override
  ConsumerState<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends ConsumerState<AppointmentList> {
  String _query = '';
  AppointmentStatus? _status;

  Future<void> _chooseStatus() async {
    FocusScope.of(context).unfocus();
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: Text(AppStrings.of(context).filterStatus),
        actions: [
          for (final status in <AppointmentStatus?>[
            null,
            ...AppointmentStatus.values,
          ])
            CupertinoActionSheetAction(
              isDefaultAction: status == _status,
              onPressed: () {
                Navigator.of(sheetContext).pop();
                if (mounted) setState(() => _status = status);
              },
              child: Text(AppStrings.of(context).statusLabel(status)),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(sheetContext).pop(),
          child: Text(AppStrings.of(context).cancel),
        ),
      ),
    );
  }

  Future<void> _openDetails(String appointmentId) async {
    final deleted = await Navigator.of(context).push<bool>(
      CupertinoPageRoute(
        builder: (_) => AppointmentDetailScreen(
          uid: widget.uid,
          appointmentId: appointmentId,
        ),
      ),
    );
    if (mounted && deleted == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.of(context).appointmentDeleted)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = appointmentsProvider(widget.uid);
    final day = widget.day;
    return ref
        .watch(provider)
        .when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (_, _) => Column(
            children: [
              Text(AppStrings.of(context).appointmentsLoadError),
              CupertinoButton(
                onPressed: () => ref.invalidate(provider),
                child: Text(AppStrings.of(context).retry),
              ),
            ],
          ),
          data: (snapshot) {
            final appointments = snapshot.items;
            final byDay = day == null
                ? appointments
                : appointments
                      .where((item) => DateUtils.isSameDay(day, item.startsAt))
                      .toList();
            final visible = byDay
                .where(
                  (item) =>
                      (_status == null || item.status == _status) &&
                      item.title.toLowerCase().contains(_query),
                )
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (snapshot.isFromCache) ...[
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      byDay.isEmpty
                          ? AppStrings.of(context).appointmentsAwaitingServer
                          : AppStrings.of(context).appointmentsCached,
                      style: TextStyle(color: AppTheme.of(context).muted),
                    ),
                  ),
                  const SizedBox(height: AppTheme.small),
                ],
                if (day != null && !snapshot.isFromCache) ...[
                  Text(AppStrings.of(context).appointmentsOnDay(byDay.length)),
                  const SizedBox(height: AppTheme.small),
                ],
                CupertinoSearchTextField(
                  placeholder: AppStrings.of(context).searchAppointments,
                  decoration: AppTheme.of(context).field,
                  onChanged: (value) =>
                      setState(() => _query = value.trim().toLowerCase()),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CupertinoButton(
                    onPressed: _chooseStatus,
                    child: Text(
                      AppStrings.of(context).statusFilterLabel(_status),
                    ),
                  ),
                ),
                if (byDay.isEmpty && !snapshot.isFromCache)
                  AppointmentEmptyState(isCalendar: day != null)
                else if (byDay.isNotEmpty && visible.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(AppTheme.medium),
                    child: Text(
                      AppStrings.of(context).noAppointmentMatches,
                      textAlign: TextAlign.center,
                    ),
                  ),
                for (final appointment in visible)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.medium),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _openDetails(appointment.id),
                      child: Container(
                        width: double.infinity,
                        decoration: AppTheme.of(context).card,
                        child: Padding(
                          padding: const EdgeInsets.all(AppTheme.medium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.of(context).ink,
                                ),
                              ),
                              const SizedBox(height: AppTheme.small),
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
                              if (appointment.location.isNotEmpty)
                                Text(appointment.location),
                              if (appointment.notes.isNotEmpty)
                                Text(appointment.notes),
                              const SizedBox(height: AppTheme.small),
                              AppointmentStatusBadge(
                                status: appointment.status,
                              ),
                              if (appointment.pending)
                                Text(AppStrings.of(context).appointmentPending),
                            ],
                          ),
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
