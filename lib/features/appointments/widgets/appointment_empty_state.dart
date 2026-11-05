import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';

class AppointmentEmptyState extends StatelessWidget {
  const AppointmentEmptyState({required this.isCalendar, super.key});

  final bool isCalendar;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return DecoratedBox(
      decoration: theme.card,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.large),
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.sky,
                borderRadius: AppTheme.pill,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.medium),
                child: Icon(CupertinoIcons.calendar, color: theme.accent),
              ),
            ),
            const SizedBox(height: AppTheme.medium),
            Text(
              AppStrings.of(context).emptyTitle,
              style: theme.sectionTitle,
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
