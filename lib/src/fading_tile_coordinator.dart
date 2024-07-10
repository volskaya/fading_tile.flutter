import 'dart:math' as math;

import 'package:fading_tile/src/fading_tile_coordinator_inherited_widget.dart';
import 'package:fading_tile/src/fading_tile_props.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Coordinates animation controllers for [FadingTile].
class FadingTileCoordinator {
  FadingTileCoordinator({
    required this.staggerDuration,
    this.expectedItemCount,
  });

  final Duration staggerDuration;

  final _indexes = <int>[];
  final _animatingIndexes = <int>[];

  int? expectedItemCount;
  int? lastFadeTime;
  (int, int)? anchor;
  int _maxIndex = -1;

  static FadingTileCoordinator of(BuildContext context, {bool listen = true}) => listen
      ? context.dependOnInheritedWidgetOfExactType<FadingTileControllerInheritedWidget>()!.coordinator
      : context.getInheritedWidgetOfExactType<FadingTileControllerInheritedWidget>()!.coordinator;

  FadingTileProps? requestFade(
    int index,
    TickerProvider vsync, {
    required Duration fadeDuration,
    bool stagger = false,
  }) {
    if (_maxIndex >= index) return null;

    final nowMs = DateTime.now().millisecondsSinceEpoch;

    if (anchor == null) {
      lastFadeTime = nowMs;
      anchor = (index, lastFadeTime!);

      return FadingTilePropsIdle(
        controller: AnimationController(
          vsync: vsync,
          duration: fadeDuration,
        ),
      );
    } else {
      final (anchorIndex, anchorFadeTime) = anchor!;

      final indexDifference = index - anchorIndex;
      final supposedFadeTime = anchorFadeTime + (staggerDuration.inMilliseconds * indexDifference);

      if (supposedFadeTime >= nowMs) {
        // This index is not supposed to fade in yet and the controller can wait.
        final awaitTime = supposedFadeTime - nowMs;
        final effectiveFadeDuration = Duration(milliseconds: awaitTime + fadeDuration.inMilliseconds);
        final intervalBegin = awaitTime / effectiveFadeDuration.inMilliseconds;

        return FadingTilePropsDelayed(
          interval: Interval(intervalBegin, 1.0),
          controller: AnimationController(
            vsync: vsync,
            duration: effectiveFadeDuration,
          ),
        );
      } else {
        final elapsedTime = nowMs - supposedFadeTime;

        double t;
        Duration effectiveFadeDuration;

        if (!stagger) {
          t = 0.0;
          effectiveFadeDuration = fadeDuration;
        } else {
          // In reversed lists with reversed children, the order of their indexes
          // may be in reverse than their item index, making the stagger look in
          // to be fading in the wrong direction.
          //
          // In those cases it's probably better to just disable stagger, maybe
          // it wasn't even needed, for example for subscribed items, but could
          // implement logic to handle that properly in the future.
          t = elapsedTime / fadeDuration.inMilliseconds;
          effectiveFadeDuration = fadeDuration * (1.0 - t);
        }

        if (t < 1.0) {
          return FadingTilePropsInProgress(
            progress: t,
            controller: AnimationController(
              vsync: vsync,
              duration: effectiveFadeDuration,
            ),
          );
        } else {
          // Nothing to animate anymore, leave the controller null.
          anchor = null;
          bumpMaxIndex(index);
        }

        assert(!elapsedTime.isNegative);
      }
    }

    return null;
  }

  void registerIndex(int index) {
    assert(!_indexes.contains(index));

    if (_indexes.isEmpty) {
      _indexes.add(index);
    } else if (index < _indexes.first) {
      _indexes.insert(0, index);
    } else if (index > _indexes.last) {
      _indexes.add(index);
    } else {
      _indexes // This can happen on an orientation change.
        ..add(index)
        ..sort();
    }

    assert(listEquals(_indexes, _indexes.toList(growable: false)..sort()));
  }

  void registerAnimatingIndex(int index) {
    assert(!_animatingIndexes.contains(index));

    if (_animatingIndexes.isEmpty) {
      _animatingIndexes.add(index);
    } else if (index < _animatingIndexes.first) {
      _animatingIndexes.insert(0, index);
    } else if (index > _animatingIndexes.last) {
      _animatingIndexes.add(index);
    } else {
      _animatingIndexes // This can happen on an orientation change.
        ..add(index)
        ..sort();
    }

    assert(listEquals(_animatingIndexes, _animatingIndexes.toList(growable: false)..sort()));
  }

  bool unregisterIndex(int index) => _indexes.remove(index);
  bool unregisterAnimatingIndex(int index, {bool didComplete = false}) {
    final removed = _animatingIndexes.remove(index);

    // When the last item finishes animating, reset the anchor and bump the last index
    // to the expected item count.
    if (didComplete && removed && _indexes.last <= index) {
      anchor = null;
      bumpMaxIndex(index);
    }

    if (_animatingIndexes.isEmpty) anchor = null;
    return removed;
  }

  void bumpMaxIndex(int newIndex) {
    _maxIndex = math.max(newIndex, expectedItemCount != null ? math.max(_maxIndex, expectedItemCount! - 1) : _maxIndex);
  }

  void bumpExpectedItemCount(int newCount) {
    assert(expectedItemCount == null || newCount > expectedItemCount!);
    expectedItemCount = newCount;
    if (_animatingIndexes.isEmpty) _maxIndex = math.max(_maxIndex, newCount);
  }
}
