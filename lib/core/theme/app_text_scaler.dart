import 'package:flutter/painting.dart';

final class AppTextScaler extends TextScaler {
  const AppTextScaler(this.systemScaler, this.multiplier);

  final TextScaler systemScaler;
  final double multiplier;

  @override
  double scale(double fontSize) => systemScaler.scale(fontSize) * multiplier;

  @override
  double get textScaleFactor => scale(14) / 14;

  @override
  bool operator ==(Object other) =>
      other is AppTextScaler &&
      other.systemScaler == systemScaler &&
      other.multiplier == multiplier;

  @override
  int get hashCode => Object.hash(systemScaler, multiplier);
}
