import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';

class AgendaBanner extends StatelessWidget {
  const AgendaBanner({required this.onAdd, super.key});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final strings = AppStrings.of(context);
    return DecoratedBox(
      decoration: theme.agendaBanner,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: AppTheme.pill,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.small),
                child: Icon(CupertinoIcons.calendar, color: theme.accent),
              ),
            ),
            const SizedBox(height: AppTheme.medium),
            Text(strings.agendaHeading, style: theme.sectionTitle),
            const SizedBox(height: AppTheme.small),
            Text(
              strings.agendaDescription,
              style: TextStyle(color: theme.muted),
            ),
            const SizedBox(height: AppTheme.medium),
            CupertinoButton.filled(
              borderRadius: AppTheme.pill,
              onPressed: onAdd,
              child: Text(strings.addAppointment, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
