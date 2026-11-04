import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
import '../auth_validation.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _form = GlobalKey<FormState>();

  void _submit() {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    HapticFeedback.lightImpact();
    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text(AppStrings.resetPassword),
        content: const Text(AppStrings.authPreview),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.done),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(AppStrings.resetPassword),
        previousPageTitle: AppStrings.login,
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppTheme.contentWidth),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(AppTheme.large),
              children: [
                const Icon(
                  CupertinoIcons.envelope,
                  size: 40,
                  color: AppTheme.accent,
                ),
                const SizedBox(height: AppTheme.medium),
                Text(
                  AppStrings.resetPassword,
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle,
                ),
                const SizedBox(height: AppTheme.small),
                const Text(
                  AppStrings.resetPasswordSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.muted),
                ),
                const SizedBox(height: AppTheme.large),
                DecoratedBox(
                  decoration: AppTheme.card,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.medium),
                    child: Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CupertinoTextFormFieldRow(
                            placeholder: AppStrings.email,
                            decoration: AppTheme.field,
                            padding: const EdgeInsets.all(AppTheme.small),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            autocorrect: false,
                            validator: AuthValidation.email,
                            onFieldSubmitted: (_) => _submit(),
                          ),
                          const SizedBox(height: AppTheme.small),
                          CupertinoButton.filled(
                            borderRadius: AppTheme.corners,
                            onPressed: _submit,
                            child: const Text(
                              AppStrings.sendResetLink,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
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
