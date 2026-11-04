import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/date_time_sheet.dart';
import '../../../l10n/app_strings.dart';

class AppointmentForm extends StatefulWidget {
  const AppointmentForm({super.key});

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  DateTime? _date;
  TimeOfDay? _time;

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
  Widget build(BuildContext context) {
    final date = _date;
    final time = _time;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(AppStrings.addAppointment),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppTheme.contentWidth),
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.large),
              children: [
                const Text(AppStrings.formPreview),
                const SizedBox(height: AppTheme.medium),
                const CupertinoTextField(
                  placeholder: AppStrings.title,
                  decoration: AppTheme.field,
                  padding: EdgeInsets.all(AppTheme.medium),
                ),
                const SizedBox(height: AppTheme.medium),
                const CupertinoTextField(
                  placeholder: AppStrings.notes,
                  decoration: AppTheme.field,
                  padding: EdgeInsets.all(AppTheme.medium),
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: AppTheme.medium),
                CupertinoButton.tinted(
                  onPressed: _pickDate,
                  child: Text(
                    date == null
                        ? AppStrings.chooseDate
                        : AppStrings.formatDate(date),
                  ),
                ),
                CupertinoButton.tinted(
                  onPressed: _pickTime,
                  child: Text(
                    time == null ? AppStrings.chooseTime : time.format(context),
                  ),
                ),
                const SizedBox(height: AppTheme.medium),
                const CupertinoTextField(
                  placeholder: AppStrings.location,
                  decoration: AppTheme.field,
                  padding: EdgeInsets.all(AppTheme.medium),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
