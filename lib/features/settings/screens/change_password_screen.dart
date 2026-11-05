import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/brand_assets.dart';
import '../../../l10n/app_strings.dart';
import '../../auth/auth_validation.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/widgets/auth_notice.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({required this.uid, super.key});

  final String uid;

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  bool _saving = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    HapticFeedback.lightImpact();
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider)
          .changePassword(
            uid: widget.uid,
            currentPassword: _current.text,
            newPassword: _new.text,
          );
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
      final strings = AppStrings.of(context);
      await showAuthNotice(
        context,
        strings.changePassword,
        strings.passwordChanged,
      );
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        final message = passwordChangeErrorMessage(
          error,
          AppStrings.of(context),
        );
        setState(() => _error = message);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  CupertinoTextFormFieldRow _passwordField({
    required String label,
    required String? Function(String?) validator,
    TextEditingController? controller,
    bool isLast = false,
  }) {
    return CupertinoTextFormFieldRow(
      controller: controller,
      placeholder: label,
      decoration: AppTheme.of(context).field,
      padding: const EdgeInsets.all(AppTheme.small),
      obscureText: _obscure,
      autocorrect: false,
      enableSuggestions: false,
      enabled: !_saving,
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: isLast ? (_) => _save() : null,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = AppTheme.of(context);
    final error = _error;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(strings.changePassword),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppTheme.contentWidth),
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.large),
              children: [
                Center(
                  child: BrandAssets.icon(BrandAssets.passwordLock, size: 56),
                ),
                const SizedBox(height: AppTheme.medium),
                DecoratedBox(
                  decoration: theme.card,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.medium),
                    child: Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _passwordField(
                            label: strings.currentPassword,
                            controller: _current,
                            validator: (value) => value == null || value.isEmpty
                                ? strings.currentPasswordRequired
                                : null,
                          ),
                          _passwordField(
                            label: strings.newPassword,
                            controller: _new,
                            validator: (value) =>
                                AuthValidation.newPassword(value, strings) ??
                                (value == _current.text
                                    ? strings.passwordMustDiffer
                                    : null),
                          ),
                          _passwordField(
                            label: strings.confirmPassword,
                            isLast: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return strings.confirmPasswordRequired;
                              }
                              return value == _new.text
                                  ? null
                                  : strings.passwordMismatch;
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: CupertinoButton(
                              onPressed: _saving
                                  ? null
                                  : () => setState(() => _obscure = !_obscure),
                              child: Text(
                                _obscure
                                    ? strings.showPassword
                                    : strings.hidePassword,
                              ),
                            ),
                          ),
                          if (error != null) ...[
                            Semantics(
                              liveRegion: true,
                              child: Text(
                                error,
                                style: TextStyle(color: theme.danger),
                              ),
                            ),
                            const SizedBox(height: AppTheme.medium),
                          ],
                          CupertinoButton.filled(
                            borderRadius: AppTheme.pill,
                            onPressed: _saving ? null : _save,
                            child: _saving
                                ? const CupertinoActivityIndicator()
                                : Text(strings.changePassword),
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
