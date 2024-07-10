import 'package:fading_tile/src/fading_tile_coordinator.dart';
import 'package:flutter/widgets.dart';

class FadingTileControllerInheritedWidget extends InheritedWidget {
  const FadingTileControllerInheritedWidget({
    super.key,
    required super.child,
    required this.coordinator,
  });

  final FadingTileCoordinator coordinator;

  @override
  bool updateShouldNotify(covariant FadingTileControllerInheritedWidget oldWidget) {
    return oldWidget.coordinator != coordinator;
  }
}
