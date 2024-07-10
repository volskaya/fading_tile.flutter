import 'package:fading_tile/src/fading_tile_coordinator.dart';
import 'package:fading_tile/src/fading_tile_props.dart';
import 'package:flutter/widgets.dart';

// Mixin for creating your own [FadingTile] widgets.
//
// This handles attaching to the [FadingTileCoordinator] and setting up the animation.
mixin FadingTileWidget on StatefulWidget {
  /// Index of the child in the list.
  int get index;

  /// Whether to request the fade animation with stagger enabled.
  ///
  /// There are cases where you may want to set stagger to false, for
  /// example when fading tiles in a reversed list with reversed items,
  /// because the widget tree initialization order won't match the order
  /// you intended for your items and requested fades would be other way
  /// around.
  bool get stagger;

  /// Duration of the animation.
  Duration get duration;
  VoidCallback? getPaginator(int index) => null;
}

// Mixin state for creating your own [FadingTile] widgets.
//
// This handles attaching to the [FadingTileCoordinator] and setting up the animation.
mixin FadingTileStateMixin<T extends FadingTileWidget> on State<T>, TickerProvider {
  late final FadingTileCoordinator _coordinator;

  AnimationController? fadeAnimationController; // Do not dispose this controller.
  Animation<double>? fadeAnimation;
  bool _isAnimating = false;

  void _handleAnimationStatus(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        if (!_isAnimating) {
          _isAnimating = true;
          _coordinator.registerAnimatingIndex(widget.index);
        }
        break;
      case AnimationStatus.completed:
        if (_isAnimating) {
          _isAnimating = false;
          _coordinator.unregisterAnimatingIndex(widget.index, didComplete: true);
        }
        break;
      case AnimationStatus.dismissed:
        throw UnsupportedError('The controllers are expected to move only in 1 direction');
    }
  }

  @override
  void initState() {
    super.initState();

    // No dependency created on the coordinator, it's not supposed to ever change above
    // the fading tiles.
    _coordinator = FadingTileCoordinator.of(context, listen: false)..registerIndex(widget.index);

    // The request may return a null fade, which means animations should be optimized out.
    final fade = _coordinator.requestFade(
      widget.index,
      this,
      fadeDuration: widget.duration,
      stagger: widget.stagger,
    );

    switch (fade) {
      case FadingTilePropsIdle v:
        fadeAnimation = fadeAnimationController = v.controller
          ..addStatusListener(_handleAnimationStatus)
          ..forward();
        break;
      case FadingTilePropsDelayed v:
        fadeAnimation = CurveTween(curve: v.interval).animate(v.controller);
        fadeAnimationController = v.controller
          ..addStatusListener(_handleAnimationStatus)
          ..forward();
        break;
      case FadingTilePropsInProgress v:
        fadeAnimation = fadeAnimationController = v.controller
          ..addStatusListener(_handleAnimationStatus)
          ..forward(from: v.progress);
        break;
      case null: // Do nothing.
    }

    final paginator = widget.getPaginator(widget.index);
    if (paginator != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) paginator();
      });
    }
  }

  @override
  void dispose() {
    fadeAnimationController?.dispose();
    if (_isAnimating) {
      _coordinator.unregisterAnimatingIndex(widget.index);
      _isAnimating = false;
    }
    _coordinator.unregisterIndex(widget.index);

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    assert(oldWidget.index == widget.index);
    super.didUpdateWidget(oldWidget);
  }
}
