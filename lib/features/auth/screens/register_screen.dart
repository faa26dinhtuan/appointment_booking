import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
import '../auth_validation.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_notice.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _busy = false;
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    HapticFeedback.lightImpact();
    setState(() => _busy = true);
    final controller = ref.read(authControllerProvider);
    try {
      await controller.register(_email.text.trim(), _password.text);
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        await showAuthNotice(
          context,
          AppStrings.of(context).register,
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
        middle: Text(AppStrings.of(context).register),
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
                Text(
                  AppStrings.of(context).createAccount,
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle,
                ),
                const SizedBox(height: AppTheme.small),
                Text(
                  AppStrings.of(context).registerSubtitle,
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
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            validator: (value) => AuthValidation.email(
                              value,
                              AppStrings.of(context),
                            ),
                          ),
                          CupertinoTextFormFieldRow(
                            controller: _password,
                            placeholder: AppStrings.of(context).password,
                            decoration: AppTheme.field,
                            padding: const EdgeInsets.all(AppTheme.small),
                            obscureText: _obscure,
                            autocorrect: false,
                            enableSuggestions: false,
                            textInputAction: TextInputAction.next,
                            validator: (value) => AuthValidation.newPassword(
                              value,
                              AppStrings.of(context),
                            ),
                          ),
                          CupertinoTextFormFieldRow(
                            placeholder: AppStrings.of(context).confirmPassword,
                            decoration: AppTheme.field,
                            padding: const EdgeInsets.all(AppTheme.small),
                            obscureText: _obscure,
                            autocorrect: false,
                            enableSuggestions: false,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.of(context)
                                    .confirmPasswordRequired;
                              }
                              if (value != _password.text) {
                                return AppStrings.of(context).passwordMismatch;
                              }
                              return null;
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: CupertinoButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              child: Text(
                                _obscure
                                    ? AppStrings.of(context).showPassword
                                    : AppStrings.of(context).hidePassword,
                              ),
                            ),
                          ),
                          CupertinoButton.filled(
                            borderRadius: AppTheme.corners,
                            onPressed: _busy ? null : _submit,
                            child: _busy
                                ? const CupertinoActivityIndicator()
                                : Text(
                                    AppStrings.of(context).register,
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
