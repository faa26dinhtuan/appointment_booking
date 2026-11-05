import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/widgets/auth_notice.dart';
import '../controllers/locale_controller.dart';
import '../controllers/theme_controller.dart';
import '../screens/display_name_screen.dart';
import '../screens/about_screen.dart';
import '../controllers/text_size_controller.dart';
import '../screens/formats_screen.dart';
import 'settings_options.dart';

class SettingsPanel extends ConsumerStatefulWidget {
  const SettingsPanel({required this.uid, super.key});

  final String uid;

  @override
  ConsumerState<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends ConsumerState<SettingsPanel> {
  bool _signingOut = false;
  bool _changingLanguage = false;
  bool _changingTheme = false;
  bool _changingTextSize = false;

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
    final selected = await showSettingsOptions(
      context: context,
      title: strings.settingsLanguage,
      options: AppStrings.supportedLocales,
      current: current,
      label: AppStrings.languageName,
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

  String _themeLabel(AppStrings strings, ThemeMode mode) => switch (mode) {
    ThemeMode.system => strings.themeSystem,
    ThemeMode.light => strings.themeLight,
    ThemeMode.dark => strings.themeDark,
  };

  Future<void> _chooseTheme() async {
    final strings = AppStrings.of(context);
    final current = ref.read(themeControllerProvider);
    final selected = await showSettingsOptions(
      context: context,
      title: strings.settingsAppearance,
      options: ThemeMode.values,
      current: current,
      label: (mode) => _themeLabel(strings, mode),
    );
    if (!mounted || selected == null || selected == current) return;
    setState(() => _changingTheme = true);
    try {
      await ref.read(themeControllerProvider.notifier).select(selected);
      HapticFeedback.selectionClick();
    } catch (_) {
      if (mounted) {
        await showAuthNotice(
          context,
          strings.settingsAppearance,
          strings.themeSaveError,
        );
      }
    } finally {
      if (mounted) setState(() => _changingTheme = false);
    }
  }

  String _textSizeLabel(AppStrings strings, AppTextSize size) => switch (size) {
    AppTextSize.small => strings.textSizeSmall,
    AppTextSize.standard => strings.textSizeStandard,
    AppTextSize.large => strings.textSizeLarge,
  };

  Future<void> _chooseTextSize() async {
    final strings = AppStrings.of(context);
    final current = ref.read(textSizeControllerProvider);
    final selected = await showSettingsOptions(
      context: context,
      title: strings.settingsTextSize,
      options: AppTextSize.values,
      current: current,
      label: (size) => _textSizeLabel(strings, size),
    );
    if (!mounted || selected == null || selected == current) return;
    setState(() => _changingTextSize = true);
    try {
      await ref.read(textSizeControllerProvider.notifier).select(selected);
      HapticFeedback.selectionClick();
    } catch (_) {
      if (mounted) {
        await showAuthNotice(
          context,
          strings.settingsTextSize,
          strings.textSizeSaveError,
        );
      }
    } finally {
      if (mounted) setState(() => _changingTextSize = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final locale = ref.watch(localeControllerProvider);
    final themeMode = ref.watch(themeControllerProvider);
    final textSize = ref.watch(textSizeControllerProvider);
    final profileProvider = displayNameProvider(widget.uid);
    final profile = ref.watch(profileProvider);
    final name = profile.asData?.value;
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
            style: TextStyle(
              color: AppTheme.of(context).muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DecoratedBox(
          decoration: AppTheme.of(context).card,
          child: ClipRRect(
            borderRadius: AppTheme.corners,
            child: CupertinoListTile(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.medium,
                vertical: AppTheme.small,
              ),
              leading: Icon(
                CupertinoIcons.globe,
                color: AppTheme.of(context).accent,
              ),
              title: Text(strings.settingsLanguage),
              additionalInfo: Text(AppStrings.languageName(locale)),
              trailing: _changingLanguage
                  ? const CupertinoActivityIndicator()
                  : const CupertinoListTileChevron(),
              onTap: _changingLanguage ? null : _chooseLanguage,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.small),
        DecoratedBox(
          decoration: AppTheme.of(context).card,
          child: ClipRRect(
            borderRadius: AppTheme.corners,
            child: CupertinoListTile(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.medium,
                vertical: AppTheme.small,
              ),
              leading: Icon(
                CupertinoIcons.sun_max,
                color: AppTheme.of(context).accent,
              ),
              title: Text(strings.settingsAppearance),
              additionalInfo: Text(_themeLabel(strings, themeMode)),
              trailing: _changingTheme
                  ? const CupertinoActivityIndicator()
                  : const CupertinoListTileChevron(),
              onTap: _changingTheme ? null : _chooseTheme,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.small),
        DecoratedBox(
          decoration: AppTheme.of(context).card,
          child: ClipRRect(
            borderRadius: AppTheme.corners,
            child: CupertinoListTile(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.medium,
                vertical: AppTheme.small,
              ),
              leading: Icon(
                CupertinoIcons.textformat_size,
                color: AppTheme.of(context).accent,
              ),
              title: Text(strings.settingsTextSize),
              additionalInfo: Text(_textSizeLabel(strings, textSize)),
              trailing: _changingTextSize
                  ? const CupertinoActivityIndicator()
                  : const CupertinoListTileChevron(),
              onTap: _changingTextSize ? null : _chooseTextSize,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.small),
        DecoratedBox(
          decoration: AppTheme.of(context).card,
          child: ClipRRect(
            borderRadius: AppTheme.corners,
            child: CupertinoListTile(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.medium,
                vertical: AppTheme.small,
              ),
              leading: Icon(
                CupertinoIcons.clock,
                color: AppTheme.of(context).accent,
              ),
              title: Text(strings.settingsFormats),
              trailing: const CupertinoListTileChevron(),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).push<void>(
                  CupertinoPageRoute(builder: (_) => const FormatsScreen()),
                );
              },
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
              color: AppTheme.of(context).muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DecoratedBox(
          decoration: AppTheme.of(context).card,
          child: ClipRRect(
            borderRadius: AppTheme.corners,
            child: CupertinoListTile(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.medium,
                vertical: AppTheme.small,
              ),
              leading: Icon(
                CupertinoIcons.person_crop_circle,
                color: AppTheme.of(context).accent,
              ),
              title: Text(strings.displayName),
              subtitle: profile.hasValue
                  ? Text(
                      name == null || name.isEmpty
                          ? strings.displayNameUnset
                          : name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              trailing: profile.isLoading
                  ? const CupertinoActivityIndicator()
                  : const CupertinoListTileChevron(),
              onTap: profile.isLoading
                  ? null
                  : () {
                      if (profile.hasError) {
                        ref.invalidate(profileProvider);
                        return;
                      }
                      Navigator.of(context).push<void>(
                        CupertinoPageRoute(
                          builder: (_) => DisplayNameScreen(
                            uid: widget.uid,
                            initialName: name,
                          ),
                        ),
                      );
                    },
            ),
          ),
        ),
        const SizedBox(height: AppTheme.small),
        DecoratedBox(
          decoration: AppTheme.of(context).card,
          child: ClipRRect(
            borderRadius: AppTheme.corners,
            child: CupertinoListTile(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.medium,
                vertical: AppTheme.small,
              ),
              leading: Icon(
                CupertinoIcons.square_arrow_right,
                color: AppTheme.of(context).accent,
              ),
              title: Text(AppStrings.of(context).signOut),
              trailing: _signingOut ? const CupertinoActivityIndicator() : null,
              onTap: _signingOut ? null : _signOut,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.large),
        DecoratedBox(
          decoration: AppTheme.of(context).card,
          child: ClipRRect(
            borderRadius: AppTheme.corners,
            child: CupertinoListTile(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.medium,
                vertical: AppTheme.small,
              ),
              leading: Icon(
                CupertinoIcons.info_circle,
                color: AppTheme.of(context).accent,
              ),
              title: Text(strings.settingsAbout),
              trailing: const CupertinoListTileChevron(),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).push<void>(
                  CupertinoPageRoute(builder: (_) => const AboutScreen()),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
