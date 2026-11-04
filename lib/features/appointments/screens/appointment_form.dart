import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/date_time_sheet.dart';
import '../../../data/models/appointment.dart';
import '../../../l10n/app_strings.dart';

import '../controllers/appointments_controller.dart';

class AppointmentForm extends ConsumerStatefulWidget {
  const AppointmentForm({required this.uid, this.appointment, super.key});

  final String uid;
  final Appointment? appointment;

  @override
  ConsumerState<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends ConsumerState<AppointmentForm> {
  final _title = TextEditingController();
  final _notes = TextEditingController();
  final _location = TextEditingController();
  bool _saving = false;
  String? _error;
  DateTime? _date;
  TimeOfDay? _time;

  @override
  void initState() {
    super.initState();
    final appointment = widget.appointment;
    if (appointment == null) return;
    _title.text = appointment.title;
    _notes.text = appointment.notes;
    _location.text = appointment.location;
    _date = DateUtils.dateOnly(appointment.startsAt);
    _time = TimeOfDay.fromDateTime(appointment.startsAt);
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final date = _date;
    final selected = await showDateTimeSheet(
      context: context,
      initial: date != null && !date.isBefore(today) ? date : today,
      minimumDate: today,
      maximumDate: DateTime(2200),
    );
    if (mounted && selected != null) setState(() => _date = selected);
  }

  Future<void> _pickTime() async {
    final now = DateTime.now();
    final time = _time ?? TimeOfDay.fromDateTime(now);
    final selected = await showDateTimeSheet(
      context: context,
      initial: DateTime(now.year, now.month, now.day, time.hour, time.minute),
      mode: CupertinoDatePickerMode.time,
    );
    if (mounted && selected != null) {
      setState(() => _time = TimeOfDay.fromDateTime(selected));
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    _location.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final title = _title.text.trim();
    final date = _date;
    final time = _time;
    if (title.isEmpty) {
      setState(() => _error = AppStrings.appointmentTitleRequired);
      return;
    }
    if (date == null || time == null) {
      setState(() => _error = AppStrings.appointmentDateTimeRequired);
      return;
    }
    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    final original = widget.appointment?.startsAt;
    final sameTime =
        original != null &&
        DateUtils.isSameDay(original, selected) &&
        original.hour == selected.hour &&
        original.minute == selected.minute;
    final startsAt = sameTime ? original : selected;
    if (!sameTime && !startsAt.isAfter(DateTime.now())) {
      setState(() => _error = AppStrings.appointmentMustBeFuture);
      return;
    }
    FocusScope.of(context).unfocus();
    HapticFeedback.lightImpact();
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(appointmentsRepositoryProvider)
          .save(
            id: widget.appointment?.id,
            uid: widget.uid,
            title: title,
            notes: _notes.text.trim(),
            location: _location.text.trim(),
            startsAt: startsAt,
          );
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = AppStrings.appointmentSaveError);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = _date;
    final time = _time;
    final error = _error;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.appointment == null
              ? AppStrings.addAppointment
              : AppStrings.editAppointment,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppTheme.contentWidth),
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.large),
              children: [
                CupertinoTextField(
                  controller: _title,
                  enabled: !_saving,
                  placeholder: AppStrings.title,
                  decoration: AppTheme.field,
                  padding: const EdgeInsets.all(AppTheme.medium),
                ),
                const SizedBox(height: AppTheme.medium),
                CupertinoTextField(
                  controller: _notes,
                  enabled: !_saving,
                  placeholder: AppStrings.notes,
                  decoration: AppTheme.field,
                  padding: const EdgeInsets.all(AppTheme.medium),
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: AppTheme.medium),
                CupertinoButton.tinted(
                  onPressed: _saving ? null : _pickDate,
                  child: Text(
                    date == null
                        ? AppStrings.chooseDate
                        : AppStrings.formatDate(date),
                  ),
                ),
                CupertinoButton.tinted(
                  onPressed: _saving ? null : _pickTime,
                  child: Text(
                    time == null ? AppStrings.chooseTime : time.format(context),
                  ),
                ),
                const SizedBox(height: AppTheme.medium),
                CupertinoTextField(
                  controller: _location,
                  enabled: !_saving,
                  placeholder: AppStrings.location,
                  decoration: AppTheme.field,
                  padding: const EdgeInsets.all(AppTheme.medium),
                ),
                const SizedBox(height: AppTheme.large),
                if (error != null) ...[
                  Semantics(liveRegion: true, child: Text(error)),
                  const SizedBox(height: AppTheme.small),
                ],
                CupertinoButton.filled(
                  borderRadius: AppTheme.corners,
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const CupertinoActivityIndicator()
                      : const Text(AppStrings.saveAppointment),
                ),
                if (_saving)
                  Semantics(
                    liveRegion: true,
                    child: const Text(
                      AppStrings.appointmentPending,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
