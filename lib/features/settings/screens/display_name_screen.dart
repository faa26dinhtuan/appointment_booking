import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_strings.dart';
import '../../auth/controllers/auth_controller.dart';

class DisplayNameScreen extends ConsumerStatefulWidget {
  const DisplayNameScreen({required this.uid, this.initialName, super.key});

  final String uid;
  final String? initialName;

  @override
  ConsumerState<DisplayNameScreen> createState() => _DisplayNameScreenState();
}

class _DisplayNameScreenState extends ConsumerState<DisplayNameScreen> {
  late final _name = TextEditingController(text: widget.initialName);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final name = _name.text.trim();
    if (name == (widget.initialName ?? '')) {
      Navigator.of(context).pop();
      return;
    }
    FocusScope.of(context).unfocus();
    HapticFeedback.lightImpact();
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider)
          .updateDisplayName(widget.uid, name);
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        final message = authErrorMessage(error, AppStrings.of(context));
        setState(() => _error = message);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = AppTheme.of(context);
    final error = _error;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(strings.displayName)),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppTheme.contentWidth),
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.large),
              children: [
                Text(
                  strings.displayNameHint,
                  style: TextStyle(color: theme.muted),
                ),
                const SizedBox(height: AppTheme.medium),
                CupertinoTextField(
                  controller: _name,
                  decoration: theme.field,
                  padding: const EdgeInsets.all(AppTheme.medium),
                  placeholder: strings.displayName,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  maxLength: 50,
                  enabled: !_saving,
                  onSubmitted: (_) => _save(),
                ),
                const SizedBox(height: AppTheme.medium),
                if (error != null)
                  Semantics(liveRegion: true, child: Text(error)),
                CupertinoButton.filled(
                  borderRadius: AppTheme.corners,
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const CupertinoActivityIndicator()
                      : Text(strings.saveProfile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
