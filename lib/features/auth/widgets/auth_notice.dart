import 'package:flutter/cupertino.dart';

import '../../../l10n/app_strings.dart';

Future<void> showAuthNotice(
  BuildContext context,
  String title,
  String message,
) {
  return showCupertinoDialog<void>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.done),
        ),
      ],
    ),
  );
}
