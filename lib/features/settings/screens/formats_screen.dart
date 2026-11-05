import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
import '../../auth/widgets/auth_notice.dart';
import '../controllers/date_format_controller.dart';
import '../controllers/time_format_controller.dart';
import '../widgets/settings_options.dart';

class FormatsScreen extends ConsumerStatefulWidget {
  const FormatsScreen({super.key});

  @override
  ConsumerState<FormatsScreen> createState() => _FormatsScreenState();
}

class _FormatsScreenState extends ConsumerState<FormatsScreen> {
  bool _saving = false;

  Future<void> _choose<T extends Object>({
    required String title,
    required List<T> options,
    required T current,
    required String Function(T) label,
    required Future<void> Function(T) save,
    required String errorMessage,
  }) async {
    final selected = await showSettingsOptions(
      context: context,
      title: title,
      options: options,
      current: current,
      label: label,
    );
    if (!mounted || selected == null || selected == current) return;
    setState(() => _saving = true);
    try {
      await save(selected);
      HapticFeedback.selectionClick();
    } catch (_) {
      if (mounted) await showAuthNotice(context, title, errorMessage);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = AppTheme.of(context);
    final dateFormat = ref.watch(dateFormatControllerProvider);
    final use24Hour = ref.watch(timeFormatControllerProvider);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(strings.settingsFormats),
        trailing: _saving ? const CupertinoActivityIndicator() : null,
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppTheme.contentWidth),
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.large),
              children: [
                DecoratedBox(
                  decoration: theme.card,
                  child: ClipRRect(
                    borderRadius: AppTheme.corners,
                    child: Column(
                      children: [
                        CupertinoListTile(
                          leading: Icon(
                            CupertinoIcons.calendar,
                            color: theme.accent,
                          ),
                          title: Text(strings.settingsDateFormat),
                          subtitle: Text(strings.dateFormatLabel(dateFormat)),
                          trailing: const CupertinoListTileChevron(),
                          onTap: _saving
                              ? null
                              : () => _choose(
                                  title: strings.settingsDateFormat,
                                  options: AppDateFormat.values,
                                  current: dateFormat,
                                  label: strings.dateFormatLabel,
                                  save: ref
                                      .read(
                                        dateFormatControllerProvider.notifier,
                                      )
                                      .select,
                                  errorMessage: strings.dateFormatSaveError,
                                ),
                        ),
                        Container(height: 1, color: theme.border),
                        CupertinoListTile(
                          leading: Icon(
                            CupertinoIcons.clock,
                            color: theme.accent,
                          ),
                          title: Text(strings.settingsTimeFormat),
                          subtitle: Text(strings.timeFormatLabel(use24Hour)),
                          trailing: const CupertinoListTileChevron(),
                          onTap: _saving
                              ? null
                              : () => _choose(
                                  title: strings.settingsTimeFormat,
                                  options: const [true, false],
                                  current: use24Hour,
                                  label: strings.timeFormatLabel,
                                  save: ref
                                      .read(
                                        timeFormatControllerProvider.notifier,
                                      )
                                      .select,
                                  errorMessage: strings.timeFormatSaveError,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
