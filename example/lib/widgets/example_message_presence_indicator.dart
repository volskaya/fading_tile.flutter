import 'package:app/design/colors.dart';
import 'package:app/design/tokens.dart';
import 'package:app/extensions/color.dart';
import 'package:flutter/widgets.dart';

class ExampleMessagePresenceIndicator extends StatelessWidget {
  const ExampleMessagePresenceIndicator({
    super.key,
    this.invert = false,
    this.size = const Size.square(xs),
  });

  final bool invert;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final colors = OurColors.of(context);

    return Positioned(
      bottom: -(size.height / 2.0),
      left: !invert ? -(size.width / 2.0) : null,
      right: invert ? -(size.width / 2.0) : null,
      width: size.width,
      height: size.height,
      child: CustomPaint(
        painter: PresenceIndicatorPainter(
          backgroundColor: colors.background,
          color: colors.accentPrimary,
        ),
      ),
    );
  }
}

class PresenceIndicatorPainter extends CustomPainter {
  PresenceIndicatorPainter({
    required this.color,
    required this.backgroundColor,
    this.scale = 1.0,
    this.opacity,
  }) : super(repaint: opacity);

  final Color color;
  final Color backgroundColor;
  final double scale;
  final Animation<double>? opacity;

  Paint? _paint;
  Paint? _backgroundPaint;
  double? _lastOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    if (scale < 0.001) return; // No point in painting anything here.

    if (opacity != null && _lastOpacity != opacity!.value) {
      _paint = Paint()..color = color.withRelativeOpacity(opacity!.value);
      _backgroundPaint = Paint()..color = backgroundColor.withRelativeOpacity(opacity!.value);
      _lastOpacity = opacity!.value;
    } else {
      _paint ??= Paint()..color = color;
      _backgroundPaint ??= Paint()..color = backgroundColor;
    }

    final center = Offset(size.width / 2.0, size.height / 2.0);
    final radius = size.shortestSide / 2.0 * scale;
    canvas.drawCircle(center, radius, _backgroundPaint!);
    canvas.drawCircle(center, radius / 2.0, _paint!);
  }

  @override
  bool shouldRepaint(PresenceIndicatorPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.backgroundColor != backgroundColor ||
      oldDelegate.scale != scale ||
      oldDelegate.opacity != opacity;
}
