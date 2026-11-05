import 'package:flutter/cupertino.dart';

import '../../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import 'brand_assets.dart';

class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;
  late final Animation<double> _iconEntrance;
  late final Animation<double> _titleEntrance;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
      animationBehavior: AnimationBehavior.preserve,
    );
    _iconEntrance = _intro.drive(
      CurveTween(curve: const Interval(0, 0.28, curve: Curves.easeOutCubic)),
    );
    _titleEntrance = _intro.drive(
      CurveTween(curve: const Interval(0.625, 0.88, curve: Curves.easeOutCubic)),
    );
    _intro.addStatusListener(_onIntroStatus);
    _intro.forward();
  }

  void _onIntroStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onFinished();
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final icon = DecoratedBox(
      decoration: theme.card,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.medium),
        child: BrandAssets.icon(BrandAssets.calendarCheck, size: 64),
      ),
    );
    final title = Text(
      AppStrings.productName,
      textAlign: TextAlign.center,
      style: theme.sectionTitle,
    );

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
                  if (reduceMotion)
                    icon
                  else
                    FadeTransition(
                      opacity: _iconEntrance.drive(Tween(begin: 0.5, end: 1.0)),
                      child: ScaleTransition(
                        scale: _iconEntrance.drive(Tween(begin: 0.88, end: 1.0)),
                        child: icon,
                      ),
                    ),
                  const SizedBox(height: AppTheme.large),
                  if (reduceMotion)
                    FadeTransition(
                      opacity: _intro.drive(
                        CurveTween(curve: const Threshold(0.625)),
                      ),
                      child: title,
                    )
                  else
                    FadeTransition(
                      opacity: _titleEntrance,
                      child: SlideTransition(
                        position: _titleEntrance.drive(
                          Tween(begin: const Offset(0, 0.24), end: Offset.zero),
                        ),
                        child: title,
                      ),
                    ),
                  const SizedBox(height: AppTheme.medium),
                  if (reduceMotion)
                    const SizedBox(height: 20)
                  else
                    FadeTransition(
                      opacity: _titleEntrance,
                      child: const CupertinoActivityIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

