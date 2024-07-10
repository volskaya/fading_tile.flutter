import 'package:flutter/widgets.dart';
import 'package:other_animations/other_animations.dart';

class FadeTroughTransitionZoomedFadeIn extends StatelessWidget {
  const FadeTroughTransitionZoomedFadeIn({
    super.key,
    required this.child,
    required this.animation,
  });

  final Widget child;
  final Animation<double> animation;

  static final CurveTween _inCurve = CurveTween(curve: const Cubic(0.0, 0.0, 0.2, 1.0));
  static final TweenSequence<double> _scaleIn = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(tween: ConstantTween<double>(0.92), weight: 6 / 20),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.92, end: 1.0).chain(_inCurve), weight: 14 / 20),
    ],
  );
  static final TweenSequence<double> _fadeInOpacity = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(tween: ConstantTween<double>(0.0), weight: 6 / 20),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.0).chain(_inCurve), weight: 14 / 20),
    ],
  );

  static Widget get({
    required Widget child,
    required Animation<double> animation,
  }) =>
      Animations.fade(
        opacity: _fadeInOpacity.animate(animation),
        child: Animations.scale(
          scale: _scaleIn.animate(animation),
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) => get(
        child: child,
        animation: animation,
      );
}
