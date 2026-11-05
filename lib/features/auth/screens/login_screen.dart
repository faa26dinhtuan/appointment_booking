import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
import '../auth_validation.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_notice.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
      await controller.signIn(_email.text.trim(), _password.text);
    } catch (error) {
      if (mounted) {
        await showAuthNotice(
          context,
          AppStrings.of(context).login,
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
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppTheme.contentWidth),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(AppTheme.large),
              children: [
                Icon(
                  CupertinoIcons.calendar,
                  size: 40,
                  color: AppTheme.of(context).accent,
                ),
                const SizedBox(height: AppTheme.medium),
                Text(
                  AppStrings.of(context).login,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.of(context).ink,
                  ),
                ),
                const SizedBox(height: AppTheme.small),
                Text(
                  AppStrings.of(context).loginSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.of(context).muted),
                ),
                const SizedBox(height: AppTheme.large),
                DecoratedBox(
                  decoration: AppTheme.of(context).card,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.medium),
                    child: Form(
                      key: _form,
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CupertinoTextFormFieldRow(
                              controller: _email,
                              placeholder: AppStrings.of(context).email,
                              decoration: AppTheme.of(context).field,
                              padding: const EdgeInsets.all(AppTheme.small),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.username],
                              autocorrect: false,
                              validator: (value) => AuthValidation.email(
                                value,
                                AppStrings.of(context),
                              ),
                            ),
                            CupertinoTextFormFieldRow(
                              controller: _password,
                              placeholder: AppStrings.of(context).password,
                              decoration: AppTheme.of(context).field,
                              padding: const EdgeInsets.all(AppTheme.small),
                              obscureText: _obscure,
                              autocorrect: false,
                              enableSuggestions: false,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? AppStrings.of(context).passwordRequired
                                  : null,
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
                                      AppStrings.of(context).login,
                                      textAlign: TextAlign.center,
                                    ),
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
                      onPressed: _busy
                          ? null
                          : () => Navigator.of(context).push<void>(
                              CupertinoPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            ),
                      child: Text(AppStrings.of(context).register),
                    ),
                    CupertinoButton(
                      onPressed: _busy
                          ? null
                          : () => Navigator.of(context).push<void>(
                              CupertinoPageRoute(
                                builder: (_) => const ResetPasswordScreen(),
                              ),
                            ),
                      child: Text(AppStrings.of(context).forgotPassword),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
