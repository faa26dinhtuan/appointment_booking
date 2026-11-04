import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
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
    final selected = await showDatePicker(
      context: context,
      initialDate: _date != null && !_date!.isBefore(today) ? _date : today,
      firstDate: today,
      lastDate: DateTime(2200),
    );
    if (mounted && selected != null) setState(() => _date = selected);
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (mounted && selected != null) setState(() => _time = selected);
  }

  @override
  Widget build(BuildContext context) {
    final date = _date;
    final time = _time;
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.addAppointment)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppTheme.contentWidth),
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.large),
              children: [
                const Text(AppStrings.formPreview),
                const SizedBox(height: AppTheme.medium),
                const TextField(
                  decoration: InputDecoration(labelText: AppStrings.title),
                ),
                const SizedBox(height: AppTheme.medium),
                const TextField(
                  decoration: InputDecoration(labelText: AppStrings.notes),
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: AppTheme.medium),
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(CupertinoIcons.calendar),
                  label: Text(
                    date == null
                        ? AppStrings.chooseDate
                        : AppStrings.formatDate(date),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(CupertinoIcons.clock),
                  label: Text(
                    time == null ? AppStrings.chooseTime : time.format(context),
                  ),
                ),
                const SizedBox(height: AppTheme.medium),
                const TextField(
                  decoration: InputDecoration(labelText: AppStrings.location),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
