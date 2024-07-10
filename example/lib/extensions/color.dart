import 'package:flutter/widgets.dart';

extension ColorExt on Color {
  Color withRelativeOpacity(double opacity) => withAlpha((alpha * opacity).round());
}
