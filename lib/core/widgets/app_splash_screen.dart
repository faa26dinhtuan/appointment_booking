import 'package:flutter/cupertino.dart';

import '../../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import 'brand_assets.dart';

class AppSplashScreen extends StatelessWidget {
  const AppSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return CupertinoPageScaffold(
      backgroundColor: theme.background,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: theme.agendaBanner.gradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.large),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DecoratedBox(
                    decoration: theme.card,
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.medium),
                      child: BrandAssets.icon(BrandAssets.calendarCheck, size: 64),
                    ),
                  ),
                  const SizedBox(height: AppTheme.large),
                  Text(
                    AppStrings.productName,
                    textAlign: TextAlign.center,
                    style: theme.sectionTitle,
                  ),
                  const SizedBox(height: AppTheme.medium),
                  const CupertinoActivityIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
