import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class RenderSizeExpandTransition extends RenderAligningShiftedBox {
  RenderSizeExpandTransition({
    required this.axis,
    required Animation<double> animation,
    super.child, // ignore: unused_element
    super.alignment = Alignment.center,
    super.textDirection,
    this.clip = false,
  }) {
    this.animation = animation;
  }

  final SizeTween _sizeTween = SizeTween();

  Axis? axis;
  bool? clip;
  Animation<double>? _animation;

  bool _hasVisualOverflow = false;
  double? _lastValue;
  Size get _animatedSize =>
      _animation != null ? _sizeTween.evaluate(_animation!) ?? const Size.square(0) : const Size.square(0);

  set animation(Animation<double> animation) {
    _animation?.removeListener(_handleAnimation);
    _animation = animation..addListener(_handleAnimation);
  }

  void _handleAnimation() {
    if (_lastValue != _animation?.value) markNeedsLayout();
  }

  @override
  void detach() {
    _animation?.removeListener(_handleAnimation);
    _animation = null;
    super.detach();
  }

  @override
  void performLayout() {
    _hasVisualOverflow = false;
    _lastValue = _animation?.value;
    final BoxConstraints constraints = this.constraints;
    if (child == null || constraints.isTight) {
      size = _sizeTween.begin = _sizeTween.end = constraints.smallest;
      child?.layout(constraints);
      return;
    }

    child!.layout(constraints, parentUsesSize: true);

    _sizeTween.end = debugAdoptSize(child!.size);
    switch (axis) {
      case Axis.horizontal:
        _sizeTween.begin = Size(0.0, _sizeTween.end!.height);
        break;
      case Axis.vertical:
        _sizeTween.begin = Size(_sizeTween.end!.width, 0.0);
        break;
      default:
    }

    size = constraints.constrain(_animatedSize);
    alignChild();

    if (size.width < _sizeTween.end!.width || size.height < _sizeTween.end!.height) {
      _hasVisualOverflow = true;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (clip == true && child != null && _hasVisualOverflow) {
      final Rect rect = Offset.zero & size;
      context.pushClipRect(needsCompositing, offset, rect, super.paint);
    } else {
      super.paint(context, offset);
    }
  }
}
