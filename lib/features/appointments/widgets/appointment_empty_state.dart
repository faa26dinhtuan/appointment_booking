import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';

class AppointmentEmptyState extends StatelessWidget {
  const AppointmentEmptyState({required this.isCalendar, super.key});

  final bool isCalendar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppTheme.corners,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.large),
        child: Column(
          children: [
            Icon(CupertinoIcons.calendar, color: theme.colorScheme.primary),
            const SizedBox(height: AppTheme.medium),
            Text(
              AppStrings.of(context).emptyTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.small),
            Text(
              isCalendar
                  ? AppStrings.of(context).emptyDay
                  : AppStrings.of(context).emptyDescription,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
