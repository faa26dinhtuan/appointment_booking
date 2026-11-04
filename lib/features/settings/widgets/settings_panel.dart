import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/widgets/auth_notice.dart';
import '../controllers/locale_controller.dart';

class SettingsPanel extends ConsumerStatefulWidget {
  const SettingsPanel({super.key});

  @override
  ConsumerState<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends ConsumerState<SettingsPanel> {
  bool _signingOut = false;
  bool _changingLanguage = false;

  Future<void> _signOut() async {
    if (_signingOut) return;
    HapticFeedback.lightImpact();
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(AppStrings.of(context).signOut),
        content: Text(AppStrings.of(context).signOutConfirmation),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(AppStrings.of(context).cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(AppStrings.of(context).signOut),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    setState(() => _signingOut = true);
    try {
      await ref.read(authControllerProvider).signOut();
    } catch (error) {
      if (mounted) {
        await showAuthNotice(
          context,
          AppStrings.of(context).signOut,
          authErrorMessage(error, AppStrings.of(context)),
        );
      }
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
  }

  Future<void> _chooseLanguage() async {
    final strings = AppStrings.of(context);
    final current = ref.read(localeControllerProvider);
    final selected = await showCupertinoModalPopup<Locale>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: Text(strings.settingsLanguage),
        actions: [
          for (final locale in AppStrings.supportedLocales)
            CupertinoActionSheetAction(
              isDefaultAction: locale == current,
              onPressed: () => Navigator.pop(sheetContext, locale),
              child: Text(AppStrings.languageName(locale)),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(sheetContext),
          child: Text(strings.cancel),
        ),
      ),
    );
    if (!mounted || selected == null || selected == current) return;
    setState(() => _changingLanguage = true);
    try {
      await ref.read(localeControllerProvider.notifier).select(selected);
      HapticFeedback.selectionClick();
    } catch (_) {
      if (mounted) {
        await showAuthNotice(
          context,
          strings.settingsLanguage,
          strings.languageSaveError,
        );
      }
    } finally {
      if (mounted) setState(() => _changingLanguage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final locale = ref.watch(localeControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppTheme.medium,
            bottom: AppTheme.small,
          ),
          child: Text(
            strings.settingsGeneral,
            style: const TextStyle(
              color: AppTheme.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DecoratedBox(
          decoration: AppTheme.card,
          child: ClipRRect(
            borderRadius: AppTheme.corners,
            child: CupertinoListTile(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.medium,
                vertical: AppTheme.small,
              ),
              leading: const Icon(CupertinoIcons.globe, color: AppTheme.accent),
              title: Text(strings.settingsLanguage),
              additionalInfo: Text(AppStrings.languageName(locale)),
              trailing: _changingLanguage
                  ? const CupertinoActivityIndicator()
                  : const CupertinoListTileChevron(),
              onTap: _changingLanguage ? null : _chooseLanguage,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.large),
        Padding(
          padding: EdgeInsets.only(
            left: AppTheme.medium,
            bottom: AppTheme.small,
          ),
          child: Text(
            AppStrings.of(context).settingsAccount,
            style: TextStyle(
              color: AppTheme.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DecoratedBox(
          decoration: AppTheme.card,
          child: ClipRRect(
            borderRadius: AppTheme.corners,
            child: CupertinoListTile(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.medium,
                vertical: AppTheme.small,
              ),
              leading: const Icon(
                CupertinoIcons.square_arrow_right,
                color: AppTheme.accent,
              ),
              title: Text(AppStrings.of(context).signOut),
              trailing: _signingOut ? const CupertinoActivityIndicator() : null,
              onTap: _signingOut ? null : _signOut,
            ),
          ),
        ),
      ],
    );
  }
}
