import 'package:fading_tile/src/rendering/size_expand_transition.dart';
import 'package:flutter/widgets.dart';

class SizeExpandTransition extends SingleChildRenderObjectWidget {
  const SizeExpandTransition({
    super.key,
    required super.child,
    required this.animation,
    this.alignment = Alignment.center,
    this.axis = Axis.vertical,
    this.clip = false,
  });

  final Animation<double> animation;
  final Alignment alignment;
  final Axis axis;
  final bool clip;

  @override
  RenderObject createRenderObject(BuildContext context) => RenderSizeExpandTransition(
        animation: animation,
        textDirection: Directionality.of(context),
        alignment: alignment,
        axis: axis,
        clip: clip,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderSizeExpandTransition renderObject,
  ) {
    renderObject
      ..animation = animation
      ..alignment = alignment
      ..axis = axis
      ..textDirection = Directionality.of(context)
      ..clip = clip;
  }
}
