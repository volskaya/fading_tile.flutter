import 'package:fading_tile/src/transitions/size_expand_transition.dart';
import 'package:flutter/widgets.dart';

class SizeInTransition extends StatelessWidget {
  const SizeInTransition({
    super.key,
    required this.child,
    required this.animation,
    this.alignment = Alignment.topCenter,
    this.axis = Axis.vertical,
    this.clip = false,
    this.optimizeOutChild = false,
    this.fade = true,
  });

  final Widget child;
  final Animation<double> animation;
  final Alignment alignment;
  final Axis axis;
  final bool clip;
  final bool optimizeOutChild;
  final bool fade;

  @override
  Widget build(BuildContext context) => SizeExpandTransition(
        animation: animation,
        alignment: alignment,
        axis: axis,
        clip: clip,
        child: !optimizeOutChild
            ? child
            : AnimatedBuilder(
                animation: animation,
                builder: (_, __) => animation.isDismissed ? const SizedBox() : child,
              ),
      );
}
