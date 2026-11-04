import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
import '../../appointments/screens/appointment_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final _form = GlobalKey<FormState>();
  bool _obscure = true;

  void _showPreviewNotice(String title) {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
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

  void _submit() {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    HapticFeedback.lightImpact();
    _showPreviewNotice(AppStrings.login);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppTheme.contentWidth),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(AppTheme.large),
              children: [
                const Icon(
                  CupertinoIcons.calendar,
                  size: 40,
                  color: AppTheme.accent,
                ),
                const SizedBox(height: AppTheme.medium),
                const Text(
                  AppStrings.login,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.ink,
                  ),
                ),
                const SizedBox(height: AppTheme.small),
                const Text(
                  AppStrings.loginSubtitle,
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
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CupertinoTextFormFieldRow(
                              placeholder: AppStrings.email,
                              decoration: AppTheme.field,
                              padding: const EdgeInsets.all(AppTheme.small),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.username],
                              autocorrect: false,
                              validator: (value) {
                                final email = value?.trim() ?? '';
                                if (email.isEmpty) {
                                  return AppStrings.emailRequired;
                                }
                                if (!_emailPattern.hasMatch(email)) {
                                  return AppStrings.emailInvalid;
                                }
                                return null;
                              },
                            ),
                            CupertinoTextFormFieldRow(
                              placeholder: AppStrings.password,
                              decoration: AppTheme.field,
                              padding: const EdgeInsets.all(AppTheme.small),
                              obscureText: _obscure,
                              autocorrect: false,
                              enableSuggestions: false,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? AppStrings.passwordRequired
                                  : null,
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
                              child: const Text(AppStrings.login),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.small),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    CupertinoButton(
                      onPressed: () => _showPreviewNotice(AppStrings.register),
                      child: const Text(AppStrings.register),
                    ),
                    CupertinoButton(
                      onPressed: () =>
                          _showPreviewNotice(AppStrings.forgotPassword),
                      child: const Text(AppStrings.forgotPassword),
                    ),
                  ],
                ),
                CupertinoButton(
                  onPressed: () => Navigator.of(context).push<void>(
                    CupertinoPageRoute(
                      builder: (_) => const AppointmentShell(),
                    ),
                  ),
                  child: const Text(
                    AppStrings.preview,
                    textAlign: TextAlign.center,
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
