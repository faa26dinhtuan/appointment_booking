import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';

Future<T?> showSettingsOptions<T extends Object>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required T current,
  required String Function(T) label,
}) {
  final cancel = AppStrings.of(context).cancel;
  const style = TextStyle(fontSize: AppTheme.bodyTextSize);
  return showCupertinoModalPopup<T>(
    context: context,
    builder: (sheetContext) => CupertinoActionSheet(
      title: Text(title, style: style),
      actions: [
        for (final option in options)
          CupertinoActionSheetAction(
            isDefaultAction: option == current,
            onPressed: () => Navigator.pop(sheetContext, option),
            child: Text(label(option), style: style),
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(sheetContext),
        child: Text(cancel, style: style),
      ),
    ),
  );
}
