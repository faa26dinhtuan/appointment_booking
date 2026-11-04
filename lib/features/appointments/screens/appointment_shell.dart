import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
import '../../../core/widgets/date_time_sheet.dart';
import '../widgets/appointment_empty_state.dart';
import 'appointment_form.dart';

class AppointmentShell extends StatefulWidget {
  const AppointmentShell({super.key});

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

  void _openForm() {
    HapticFeedback.lightImpact();
    Navigator.of(
      context,
    ).push<void>(CupertinoPageRoute(builder: (_) => const AppointmentForm()));
  }

  @override
  Widget build(BuildContext context) {
    final isCalendar = _tab == 1;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text(
                isCalendar ? AppStrings.calendar : AppStrings.appName,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isCalendar) ...[
                          CupertinoButton.tinted(
                            onPressed: _pickDay,
                            child: Text(AppStrings.formatDate(_day)),
                          ),
                          const SizedBox(height: AppTheme.medium),
                        ],
                        AppointmentEmptyState(isCalendar: isCalendar),
                        const SizedBox(height: AppTheme.medium),
                        if (!isCalendar)
                          CupertinoButton.filled(
                            onPressed: _openForm,
                            child: const Text(AppStrings.addAppointment),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: AppStrings.appName,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: AppStrings.calendar,
          ),
        ],
      ),
    );
  }
}
