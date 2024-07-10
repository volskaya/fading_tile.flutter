import 'package:fading_tile/fading_tile.dart';
import 'package:fading_tile/src/fading_tile_coordinator_inherited_widget.dart';
import 'package:flutter/widgets.dart';

/// Controller parent widget for lists that build [FadingTile] widgets.
///
/// If your lists are split between paginated / subscribed or other type of items,
/// wrap [FadingTileController] around each of the slivers for each item types, instead
/// of the whole scrollable widget.
class FadingTileController extends StatefulWidget {
  const FadingTileController({
    super.key,
    required this.child,
    this.staggerDuration,
    this.bucket,
    this.expectedItemCount,
    this.startFrom,
  });

  /// Child widget, usually the list or grid where the fading tiles are built.
  final Widget child;

  /// The stagger duration of fading tiles under this controller.
  ///
  /// By default this uses [FadingTile.defaultStaggerDuration].
  final Duration? staggerDuration;

  /// This is not used anymore, so the state can be memoized between tab switches and such.
  @Deprecated("Not used anymore, but may return.")
  final String? bucket; // Unused.

  /// The expected item count the list has, for example the
  /// length of paginated item list.
  final int? expectedItemCount;

  /// Doesn't fade children with index lower than this.
  ///
  /// This is used for lists that only build or animate in when their 1st
  /// page is ready, in which case another fade animation on the individual
  /// items would be redundant.
  final int? startFrom;

  static FadingTileCoordinator coordinatorOf(BuildContext context) => FadingTileCoordinator.of(context);

  @override
  FadingTileControllerState createState() => FadingTileControllerState();
}

class FadingTileControllerState extends State<FadingTileController> {
  late final _coordinator = FadingTileCoordinator(
    staggerDuration: widget.staggerDuration ?? FadingTile.defaultStaggerDuration,
  );

  @override
  void initState() {
    if (widget.startFrom != null) {
      _coordinator.bumpMaxIndex(widget.startFrom!);
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant FadingTileController oldWidget) {
    assert((oldWidget.expectedItemCount != null) == (widget.expectedItemCount != null));

    if (widget.expectedItemCount != null && oldWidget.expectedItemCount != widget.expectedItemCount) {
      // Do it in a postframe to allow widgets to build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _coordinator.bumpExpectedItemCount(widget.expectedItemCount!);
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => FadingTileControllerInheritedWidget(
        coordinator: _coordinator,
        child: widget.child,
      );
}
