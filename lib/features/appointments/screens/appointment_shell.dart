import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/brand_assets.dart';
import '../../../l10n/app_strings.dart';
import '../../../core/widgets/date_time_sheet.dart';
import '../widgets/agenda_banner.dart';
import '../widgets/appointment_list.dart';
import '../widgets/appointment_week_strip.dart';
import '../../settings/widgets/settings_panel.dart';
import 'appointment_form.dart';

enum _AppointmentFeedback { saved, deleted }

class AppointmentShell extends StatefulWidget {
  const AppointmentShell({required this.uid, super.key});

  final String uid;

  @override
  State<AppointmentShell> createState() => _AppointmentShellState();
}

class _AppointmentShellState extends State<AppointmentShell> {
  static final _firstDate = DateTime(1900);
  static final _lastDate = DateTime(2200);

  int _tab = 0;
  DateTime _day = DateUtils.dateOnly(DateTime.now());

  _AppointmentFeedback? _feedback;
  Timer? _feedbackTimer;

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    super.dispose();
  }

  void _showFeedback(_AppointmentFeedback feedback) {
    _feedbackTimer?.cancel();
    setState(() => _feedback = feedback);
    _feedbackTimer = Timer(const Duration(seconds: 5), () {
      setState(() => _feedback = null);
    });
  }

  Future<void> _pickDay() async {
    final day = await showDateTimeSheet(
      context: context,
      initial: _day,
      minimumDate: _firstDate,
      maximumDate: _lastDate,
    );
    if (mounted && day != null) setState(() => _day = day);
  }

  Future<void> _openForm() async {
    HapticFeedback.lightImpact();
    final saved = await Navigator.of(context).push<bool>(
      CupertinoPageRoute(builder: (_) => AppointmentForm(uid: widget.uid)),
    );
    if (mounted && saved == true) {
      _showFeedback(_AppointmentFeedback.saved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final strings = AppStrings.of(context);
    final isCalendar = _tab == 1;
    final isSettings = _tab == 2;
    BottomNavigationBarItem tabItem(String icon, String label) =>
        BottomNavigationBarItem(
          icon: SizedBox.square(
            dimension: 28,
            child: Center(child: BrandAssets.icon(icon)),
          ),
          activeIcon: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.sky,
              borderRadius: AppTheme.pill,
            ),
            child: SizedBox.square(
              dimension: 28,
              child: Center(child: BrandAssets.icon(icon)),
            ),
          ),
          label: label,
        );
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
              padding: const EdgeInsets.all(AppTheme.pagePadding),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppTheme.contentWidth,
                    ),
                    child: isSettings
                        ? SettingsPanel(uid: widget.uid)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (isCalendar)
                                AppointmentWeekStrip(
                                  selected: _day,
                                  firstDate: _firstDate,
                                  lastDate: _lastDate,
                                  onOpenPicker: _pickDay,
                                  onSelect: (day) {
                                    if (DateUtils.isSameDay(day, _day)) return;
                                    HapticFeedback.selectionClick();
                                    setState(() => _day = day);
                                  },
                                )
                              else
                                AgendaBanner(onAdd: _openForm),
                              const SizedBox(height: AppTheme.large),
                              Text(
                                isCalendar
                                    ? strings.dailySchedule
                                    : strings.agendaSection,
                                style: theme.sectionTitle,
                              ),
                              const SizedBox(height: AppTheme.small),
                              if (_feedback case final feedback?)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppTheme.medium,
                                  ),
                                  child: Semantics(
                                    liveRegion: true,
                                    child: DecoratedBox(
                                      decoration: theme.card,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                          AppTheme.medium,
                                        ),
                                        child: Text(
                                          switch (feedback) {
                                            _AppointmentFeedback.saved =>
                                              strings.appointmentSaved,
                                            _AppointmentFeedback.deleted =>
                                              strings.appointmentDeleted,
                                          },
                                          style: TextStyle(color: theme.success),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              AppointmentList(
                                uid: widget.uid,
                                day: isCalendar ? _day : null,
                                onDeleted: () =>
                                    _showFeedback(_AppointmentFeedback.deleted),
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
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.pagePadding,
            AppTheme.small,
            AppTheme.pagePadding,
            AppTheme.small,
          ),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppTheme.contentWidth,
              ),
              child: DecoratedBox(
                decoration: theme.card.copyWith(borderRadius: AppTheme.pill),
                child: ClipRRect(
                  borderRadius: AppTheme.pill,
                  child: CupertinoTabBar(
                    backgroundColor: theme.surface,
                    activeColor: theme.accent,
                    inactiveColor: theme.muted,
                    border: const Border(),
                    currentIndex: _tab,
                    onTap: (index) {
                      if (index == _tab) return;
                      FocusScope.of(context).unfocus();
                      HapticFeedback.selectionClick();
                      setState(() => _tab = index);
                    },
                    items: [
                      tabItem(BrandAssets.appointmentList, strings.appName),
                      tabItem(BrandAssets.calendar, strings.calendar),
                      tabItem(BrandAssets.settings, strings.settings),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
