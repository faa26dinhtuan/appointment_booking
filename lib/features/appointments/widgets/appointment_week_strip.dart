import 'dart:math' show max;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show DateUtils;

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';

class AppointmentWeekStrip extends StatelessWidget {
  const AppointmentWeekStrip({
    required this.selected,
    required this.firstDate,
    required this.lastDate,
    required this.onSelect,
    required this.onOpenPicker,
    super.key,
  });

  final DateTime selected;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onSelect;
  final VoidCallback onOpenPicker;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = AppTheme.of(context);
    final start = selected.day - selected.weekday + 1;
    final dates = List.generate(
      7,
      (index) => DateTime(selected.year, selected.month, start + index),
    );

    return DecoratedBox(
      decoration: theme.card,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.small),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CupertinoButton(
              onPressed: onOpenPicker,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      strings.formatDate(selected),
                      style: theme.sectionTitle,
                    ),
                  ),
                  const SizedBox(width: AppTheme.small),
                  Icon(CupertinoIcons.calendar, color: theme.accent),
                ],
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = max(
                  constraints.maxWidth / 7,
                  MediaQuery.textScalerOf(context).scale(44),
                );
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final date in dates)
                        SizedBox(
                          width: width,
                          child: Semantics(
                            selected: DateUtils.isSameDay(date, selected),
                            label: strings.formatDate(date),
                            child: CupertinoButton(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppTheme.small,
                              ),
                              onPressed:
                                  date.isBefore(firstDate) ||
                                      date.isAfter(lastDate)
                                  ? null
                                  : () => onSelect(date),
                              child: ExcludeSemantics(
                                child: Column(
                                  children: [
                                    Text(
                                      strings.weekdayAbbreviation(date),
                                      style: theme.caption,
                                    ),
                                    const SizedBox(height: AppTheme.small),
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        color:
                                            DateUtils.isSameDay(date, selected)
                                            ? theme.sky
                                            : theme.background,
                                        borderRadius: AppTheme.pill,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                          AppTheme.small,
                                        ),
                                        child: Text(
                                          strings.dayNumber(date),
                                          style: TextStyle(
                                            color:
                                                DateUtils.isSameDay(
                                                  date,
                                                  selected,
                                                )
                                                ? theme.accent
                                                : theme.ink,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
