import 'package:flutter/widgets.dart';

/// A seal for one of our [FadingTile] prop classes.
///
/// - [FadingTilePropsIdle].
/// - [FadingTilePropsDelayed].
/// - [FadingTilePropsInProgress].
sealed class FadingTileProps {
  const FadingTileProps();
}

//

class FadingTilePropsIdle extends FadingTileProps {
  const FadingTilePropsIdle({
    required this.controller,
  });

  final AnimationController controller;
}

class FadingTilePropsDelayed extends FadingTileProps {
  const FadingTilePropsDelayed({
    required this.controller,
    required this.interval,
  });

  final AnimationController controller;
  final Interval interval;
}

class FadingTilePropsInProgress extends FadingTileProps {
  const FadingTilePropsInProgress({
    required this.controller,
    required this.progress,
  });

  final AnimationController controller;
  final double progress;
}
