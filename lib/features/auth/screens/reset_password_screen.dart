import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
import '../auth_validation.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_notice.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    HapticFeedback.lightImpact();
    setState(() => _busy = true);
    final controller = ref.read(authControllerProvider);
    try {
      await controller.resetPassword(_email.text.trim());
      if (mounted) {
        await showAuthNotice(
          context,
          AppStrings.of(context).resetPassword,
          AppStrings.of(context).resetSent,
        );
      }
    } catch (error) {
      if (mounted) {
        await showAuthNotice(
          context,
          AppStrings.of(context).resetPassword,
          authErrorMessage(error, AppStrings.of(context)),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppStrings.of(context).resetPassword),
        previousPageTitle: AppStrings.of(context).login,
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
                  AppStrings.of(context).resetPassword,
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle,
                ),
                const SizedBox(height: AppTheme.small),
                Text(
                  AppStrings.of(context).resetPasswordSubtitle,
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
                            controller: _email,
                            placeholder: AppStrings.of(context).email,
                            decoration: AppTheme.field,
                            padding: const EdgeInsets.all(AppTheme.small),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            autocorrect: false,
                            validator: (value) => AuthValidation.email(
                              value,
                              AppStrings.of(context),
                            ),
                            onFieldSubmitted: (_) => _submit(),
                          ),
                          const SizedBox(height: AppTheme.small),
                          CupertinoButton.filled(
                            borderRadius: AppTheme.corners,
                            onPressed: _busy ? null : _submit,
                            child: _busy
                                ? const CupertinoActivityIndicator()
                                : Text(
                                    AppStrings.of(context).sendResetLink,
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
