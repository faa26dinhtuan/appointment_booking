import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
import '../../../core/widgets/date_time_sheet.dart';
import '../widgets/appointment_list.dart';
import '../../settings/widgets/settings_panel.dart';
import 'appointment_form.dart';

class AppointmentShell extends StatefulWidget {
  const AppointmentShell({required this.uid, super.key});

  final String uid;

  @override
  State<AppointmentShell> createState() => _AppointmentShellState();
}

class _AppointmentShellState extends State<AppointmentShell> {
  int _tab = 0;
  DateTime _day = DateUtils.dateOnly(DateTime.now());

  Future<void> _pickDay() async {
    final day = await showDateTimeSheet(
      context: context,
      initial: _day,
      minimumDate: DateTime(1900),
      maximumDate: DateTime(2200),
    );
    if (mounted && day != null) setState(() => _day = day);
  }

  Future<void> _openForm() async {
    HapticFeedback.lightImpact();
    final saved = await Navigator.of(context).push<bool>(
      CupertinoPageRoute(builder: (_) => AppointmentForm(uid: widget.uid)),
    );
    if (mounted && saved == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.of(context).appointmentSaved)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCalendar = _tab == 1;
    final isSettings = _tab == 2;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text(
                isSettings
                    ? AppStrings.of(context).settings
                    : isCalendar
                    ? AppStrings.of(context).calendar
                    : AppStrings.of(context).appName,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppTheme.large),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppTheme.contentWidth,
                    ),
                    child: isSettings
                        ? const SettingsPanel()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (isCalendar) ...[
                                CupertinoButton.tinted(
                                  onPressed: _pickDay,
                                  child: Text(
                                    AppStrings.of(context).formatDate(_day),
                                  ),
                                ),
                                const SizedBox(height: AppTheme.medium),
                              ],

                              if (!isCalendar)
                                CupertinoButton.filled(
                                  onPressed: _openForm,
                                  child: Text(
                                    AppStrings.of(context).addAppointment,
                                  ),
                                ),
                              const SizedBox(height: AppTheme.medium),
                              AppointmentList(
                                uid: widget.uid,
                                day: isCalendar ? _day : null,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _tab,
        onTap: (index) {
          if (index == _tab) return;
          HapticFeedback.selectionClick();
          setState(() => _tab = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: AppStrings.of(context).appName,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: AppStrings.of(context).calendar,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: AppStrings.of(context).settings,
          ),
        ],
      ),
    );
  }
}
