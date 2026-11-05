import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/brand_assets.dart';
import '../../../l10n/app_strings.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = AppTheme.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(strings.settingsAbout),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppTheme.contentWidth),
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.large),
              children: [
                Center(
                  child: BrandAssets.icon(BrandAssets.calendarCheck, size: 40),
                ),
                const SizedBox(height: AppTheme.medium),
                Text(
                  AppStrings.productName,
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle,
                ),
                const SizedBox(height: AppTheme.small),
                Text(
                  strings.aboutDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.muted),
                ),
                const SizedBox(height: AppTheme.large),
                DecoratedBox(
                  decoration: theme.card,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.medium),
                    child: FutureBuilder<PackageInfo>(
                      future: _packageInfo,
                      builder: (context, snapshot) {
                        final info = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.aboutVersion,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppTheme.small),
                            if (snapshot.connectionState !=
                                ConnectionState.done)
                              const CupertinoActivityIndicator()
                            else
                              Text(
                                info == null || info.version.isEmpty
                                    ? strings.aboutVersionUnavailable
                                    : info.buildNumber.isEmpty
                                    ? info.version
                                    : '${info.version} (${info.buildNumber})',
                              ),
                          ],
                        );
                      },
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
