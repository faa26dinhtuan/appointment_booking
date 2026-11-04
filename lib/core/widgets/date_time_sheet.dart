import 'package:flutter/cupertino.dart';

import '../../l10n/app_strings.dart';
import '../theme/app_theme.dart';

Future<DateTime?> showDateTimeSheet({
  required BuildContext context,
  required DateTime initial,
  DateTime? minimumDate,
  DateTime? maximumDate,
  CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
}) {
  var selection = initial;
  return showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (sheetContext) => DecoratedBox(
      decoration: const BoxDecoration(color: AppTheme.surface),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text(AppStrings.cancel),
                ),
                CupertinoButton(
                  onPressed: () => Navigator.pop(sheetContext, selection),
                  child: const Text(AppStrings.done),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: mode,
                initialDateTime: initial,
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                minimumYear: minimumDate?.year ?? 1900,
                maximumYear: maximumDate?.year ?? 2200,
                use24hFormat: true,
                onDateTimeChanged: (date) => selection = date,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
