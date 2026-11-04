import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
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
    final day = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
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
            SliverAppBar.large(
              title: Text(
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
                          OutlinedButton.icon(
                            onPressed: _pickDay,
                            icon: const Icon(CupertinoIcons.calendar),
                            label: Text(AppStrings.formatDate(_day)),
                          ),
                          const SizedBox(height: AppTheme.medium),
                        ],
                        AppointmentEmptyState(isCalendar: isCalendar),
                        const SizedBox(height: AppTheme.medium),
                        if (!isCalendar)
                          FilledButton.icon(
                            onPressed: _openForm,
                            icon: const Icon(CupertinoIcons.add),
                            label: const Text(AppStrings.addAppointment),
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) {
          if (index == _tab) return;
          HapticFeedback.selectionClick();
          setState(() => _tab = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(CupertinoIcons.list_bullet),
            label: AppStrings.appName,
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.calendar),
            label: AppStrings.calendar,
          ),
        ],
      ),
    );
  }
}
