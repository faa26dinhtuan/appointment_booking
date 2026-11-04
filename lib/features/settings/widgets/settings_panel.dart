import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/widgets/auth_notice.dart';

class SettingsPanel extends ConsumerStatefulWidget {
  const SettingsPanel({super.key});

  @override
  ConsumerState<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends ConsumerState<SettingsPanel> {
  bool _signingOut = false;

  Future<void> _signOut() async {
    if (_signingOut) return;
    HapticFeedback.lightImpact();
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text(AppStrings.signOut),
        content: const Text(AppStrings.signOutConfirmation),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AppStrings.signOut),
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
          AppStrings.signOut,
          authErrorMessage(error),
        );
      }
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: AppTheme.medium,
            bottom: AppTheme.small,
          ),
          child: Text(
            AppStrings.settingsAccount,
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
              title: const Text(AppStrings.signOut),
              trailing: _signingOut ? const CupertinoActivityIndicator() : null,
              onTap: _signingOut ? null : _signOut,
            ),
          ),
        ),
      ],
    );
  }
}
