import 'package:fading_tile/fading_tile.dart';
import 'package:fading_tile/src/transitions/fade_through_transition.dart';
import 'package:fading_tile/src/transitions/size_in_transition.dart';
import 'package:flutter/material.dart';
import 'package:other_animations/other_animations.dart';

/// Animation type for [FadingTile].
enum FadingTileType {
  fade,
  slideLeft,
  slideRight,
  slideBottom,
  slideTop,
  scaleUp,
}

/// Fading animation widget that wraps list / grid children.
///
/// Must be a descendant of [FadingTileController].
class FadingTile extends StatefulWidget with FadingTileWidget {
  /// Creates [FadingTile] without size animation.
  ///
  /// This is the constructor to use for paginated items,
  /// that won't fade in before the other items in the list,
  /// so it wouldn't need a visual size animation pushing
  /// other items away.
  FadingTile({
    super.key,
    FadingTileType? type,
    Duration? duration,
    required this.child,
    required this.index,
    this.fade = true,
    this.paginator,
    this.stagger = true,
  })  : alignment = null,
        axis = null,
        clipBehavior = Clip.none,
        optimizeOutChild = false,
        type = type ?? defaultType,
        sizeDuration = defaultSizeDuration,
        duration = duration ?? defaultDuration,
        _size = false;

  /// Creates [FadingTile] with size animation.
  ///
  /// This is the constructor to use for subscribed items,
  /// that would fade in before the other items in the list
  /// and would need to push them away with an animation.
  FadingTile.size({
    super.key,
    FadingTileType? type,
    Duration? sizeDuration,
    Duration? duration,
    required this.child,
    required this.index,
    this.alignment = Alignment.topCenter,
    this.axis = Axis.vertical,
    this.clipBehavior = Clip.none,
    this.optimizeOutChild = false,
    this.fade = true,
    this.paginator,
    this.stagger = true,
  })  : type = type ?? defaultType,
        sizeDuration = sizeDuration ?? defaultSizeDuration,
        duration = duration ?? defaultDuration,
        _size = true;

  static FadingTileType defaultType = FadingTileType.fade;

  // static Duration defaultDuration = const Duration(milliseconds: 250);
  // static Duration defaultSizeDuration = const Duration(milliseconds: 500);
  // static Duration defaultStaggerDuration = const Duration(milliseconds: 30);

  static Duration defaultDuration = Motion.durations.medium;
  static Duration defaultSizeDuration = Motion.durations.medium;
  static Duration defaultStaggerDuration = const Duration(milliseconds: 30);

  final bool _size;

  @override
  final int index;

  @override
  final Duration duration;

  /// Child widget to fade in.
  final Widget child;

  /// Fade in animation type.
  final FadingTileType type;

  /// Alignment of the child in the size animation.
  final Alignment? alignment;

  /// Scroll axis of the list, where this [FadingTile] is built.
  final Axis? axis;

  /// The [Clip] to pass to the nested size animation.
  final Clip clipBehavior;

  /// While the animation is dismissed and [optimizeOutChild] is true, the
  /// child widget won't be built.
  final bool optimizeOutChild;

  /// Whether to use the fade animation.
  final bool fade;

  /// Intended duration of the size animation. If this is lower than the fade animation,
  /// size will be animated with an [Interval].
  final Duration sizeDuration;

  /// Callback to call when the element for this widget is mounted.
  final VoidCallback? Function(int index)? paginator;

  /// Whether to request the fade animation with stagger enabled.
  ///
  /// There are cases where you may want to set stagger to false, for
  /// example when fading tiles in a reversed list with reversed items,
  /// because the widget tree initialization order won't match the order
  /// you intended for your items and requested fades would be other way
  /// around.
  @override
  final bool stagger;

  @override
  VoidCallback? getPaginator(int index) => paginator?.call(index);

  @override
  State<FadingTile> createState() => _FadingTileState();
}

class _FadingTileState extends State<FadingTile>
    with SingleTickerProviderStateMixin<FadingTile>, FadingTileStateMixin<FadingTile> {
  static final _curve = CurveTween(curve: Motion.easing.emphasized);
  static final _slideFromLeftTween = Tween<double>(begin: -1.0, end: 0.0).chain(_curve);
  static final _slideFromRightTween = Tween<double>(begin: 1.0, end: 0.0).chain(_curve);
  static final _slideFromBottomTween = Tween<double>(begin: 1.0, end: 0.0).chain(_curve);
  static final _scaleInTween = Tween<double>(begin: 0.0, end: 1.0).chain(_curve);

  @override
  Widget build(BuildContext context) {
    // Controller is usually not returned anymore, when the tile has faded out and it has disposed.
    //
    // Avoid wrapping the child in animation widgets.
    if (fadeAnimation == null || !widget.fade) return widget.child;

    Widget tile;

    switch (widget.type) {
      case FadingTileType.fade:
        tile = FadeTroughTransitionZoomedFadeIn(
          animation: fadeAnimation!,
          child: widget.child,
        );
        break;
      case FadingTileType.slideLeft:
        final animation = _slideFromLeftTween.animate(fadeAnimation!);
        tile = AnimatedBuilder(
          animation: animation,
          builder: (_, __) => FractionalTranslation(
            translation: Offset(animation.value, 0.0),
            child: widget.child,
          ),
        );
        break;
      case FadingTileType.slideRight:
        final animation = _slideFromRightTween.animate(fadeAnimation!);
        tile = AnimatedBuilder(
          animation: animation,
          builder: (_, __) => FractionalTranslation(
            translation: Offset(animation.value, 0.0),
            child: widget.child,
          ),
        );
        break;
      case FadingTileType.slideBottom:
        final size = MediaQuery.sizeOf(context);
        final animation = _slideFromBottomTween.animate(fadeAnimation!);
        tile = AnimatedBuilder(
          animation: animation,
          builder: (_, __) => Transform.translate(
            offset: Offset(0.0, size.height * animation.value),
            child: widget.child,
          ),
        );
        break;
      case FadingTileType.slideTop:
        final size = MediaQuery.sizeOf(context);
        final animation = _slideFromBottomTween.animate(fadeAnimation!);
        tile = AnimatedBuilder(
          animation: animation,
          builder: (_, __) => Transform.translate(
            offset: Offset(0.0, -(size.height * animation.value)),
            child: widget.child,
          ),
        );
        break;
      case FadingTileType.scaleUp:
        final animation = _scaleInTween.animate(fadeAnimation!);
        tile = AnimatedBuilder(
          animation: animation,
          builder: (_, __) => Transform.scale(
            scale: animation.value,
            filterQuality: FilterQuality.none,
            child: widget.child,
          ),
        );
        break;
    }

    if (widget._size) {
      final tween = CurveTween(curve: Motion.easing.emphasizedDecelerate);
      tile = SizeInTransition(
        animation: fadeAnimation!.drive(tween),
        alignment: widget.alignment!,
        axis: widget.axis!,
        clip: widget.clipBehavior != Clip.none,
        optimizeOutChild: widget.optimizeOutChild,
        fade: widget.fade,
        child: tile,
      );
    }

    return tile;
  }
}
