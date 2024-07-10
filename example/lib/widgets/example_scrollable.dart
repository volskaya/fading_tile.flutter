import 'package:app/extensions/edge_insets.dart';
import 'package:app/models/chat_message.dart';
import 'package:app/widgets/example_scrollable_buttons.dart';
import 'package:app/widgets/tiles/example_scrollable_tile.dart';
import 'package:fading_tile/fading_tile.dart';
import 'package:flutter/material.dart';

/// The example for `fading_tile` package.
class ExampleScrollable extends StatelessWidget {
  const ExampleScrollable({
    super.key,
    required this.paginated,
    required this.subscribed,
  });

  final List<ChatMessage> paginated;
  final List<ChatMessage> subscribed;

  /// Subscribed items are built in a reversed order, in a reversed scrollabe,
  /// so their widget positional index needs to be reversed, so when new items
  /// are inserted infront of the list and older ones pushed to further indexes,
  /// the widget tree can find where the old widget went and not drop its state.
  int _findSubscribedIndexCallback(Key key) {
    final index = (key as ValueKey<int>).value;
    final reversedIndex = subscribed.length - 1 - index;
    return reversedIndex;
  }

  Widget _buildPaginated(BuildContext context, int index) => FadingTile(
        key: ValueKey(index),
        index: index,
        child: ExampleScrollableTile(
          message: paginated[index],
          isSubscribed: false,
          index: index,
          paginated: paginated,
          subscribed: subscribed,
        ),
      );

  Widget _buildSubscribed(BuildContext context, int index) {
    // Reversed the index, so the newer items appear before older, in the reversed list.
    final effectiveIndex = subscribed.length - 1 - index;

    return FadingTile.size(
      key: ValueKey<int>(effectiveIndex),
      index: effectiveIndex,
      alignment: Alignment.bottomCenter,
      stagger: false, // Initialization order won't match our item order, so the fades will be off.
      child: ExampleScrollableTile(
        message: subscribed[effectiveIndex],
        isSubscribed: true,
        index: effectiveIndex,
        paginated: paginated,
        subscribed: subscribed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final horizontalPadding = padding.getSidesOnly();

    // Note how the scrollable is in reverse, since this is building
    // a chat message list, which we want to scroll from bottom -> up.
    //
    // In a typical setup you have the:
    //
    // - Paginated items, which are older messages that paginate in from the database, as you scroll back in the chat.
    // - Subscribed items, which are new messages that arrive while the chat is built.
    //
    // Here we use [FadingTileController] and [FadingTile] items on 2 separate
    // slivers for paginated and subscribed chat messages.
    //
    // The paginated sliver being staggered, where subscribed has stagger = false,
    // to just animate them in as the messages are added to the list.
    return CustomScrollView(
      reverse: true,
      slivers: [
        // Bottom safe area of the scrollable.
        SliverPadding(padding: padding.getBottomOnly()),

        // The buttons at the bottom, to add more test messages.
        const SliverToBoxAdapter(
          child: ExampleScrollableButtons(),
        ),

        // Example sliver list of subscribed chat messages.
        if (subscribed.isNotEmpty)
          FadingTileController(
            key: const ValueKey('subscribed_list'),
            expectedItemCount: subscribed.length,
            bucket: null,
            child: SliverPadding(
              padding: horizontalPadding,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  _buildSubscribed,
                  childCount: subscribed.length,
                  findChildIndexCallback: _findSubscribedIndexCallback,
                  addAutomaticKeepAlives: false,
                ),
              ),
            ),
          ),

        // Example sliver list of paginated chat messages.
        FadingTileController(
          key: const ValueKey('paginated_list'),
          expectedItemCount: paginated.length,
          child: SliverPadding(
            padding: horizontalPadding,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                _buildPaginated,
                childCount: paginated.length,
              ),
            ),
          ),
        ),

        // Top safe area of the scrollable.
        SliverPadding(padding: padding.getTopOnly()),
      ],
    );
  }
}
