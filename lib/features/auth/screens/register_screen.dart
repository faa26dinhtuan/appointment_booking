import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
import '../auth_validation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    HapticFeedback.lightImpact();
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(AppStrings.register),
        content: const Text(AppStrings.authPreview),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
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
        middle: Text(AppStrings.register),
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
                Text(
                  AppStrings.createAccount,
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle,
                ),
                const SizedBox(height: AppTheme.small),
                const Text(
                  AppStrings.registerSubtitle,
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
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            validator: AuthValidation.email,
                          ),
                          CupertinoTextFormFieldRow(
                            controller: _password,
                            placeholder: AppStrings.password,
                            decoration: AppTheme.field,
                            padding: const EdgeInsets.all(AppTheme.small),
                            obscureText: _obscure,
                            autocorrect: false,
                            enableSuggestions: false,
                            textInputAction: TextInputAction.next,
                            validator: AuthValidation.newPassword,
                          ),
                          CupertinoTextFormFieldRow(
                            placeholder: AppStrings.confirmPassword,
                            decoration: AppTheme.field,
                            padding: const EdgeInsets.all(AppTheme.small),
                            obscureText: _obscure,
                            autocorrect: false,
                            enableSuggestions: false,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.confirmPasswordRequired;
                              }
                              if (value != _password.text) {
                                return AppStrings.passwordMismatch;
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
                                    ? AppStrings.showPassword
                                    : AppStrings.hidePassword,
                              ),
                            ),
                          ),
                          CupertinoButton.filled(
                            borderRadius: AppTheme.corners,
                            onPressed: _submit,
                            child: const Text(AppStrings.register),
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
