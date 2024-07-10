import 'package:app/design/tokens.dart';
import 'package:app/models/chat_message.dart';
import 'package:app/widgets/tiles/chat_message_tile.dart';
import 'package:flutter/material.dart';

class ExampleScrollableTile extends StatelessWidget {
  const ExampleScrollableTile({
    super.key,
    required this.paginated,
    required this.subscribed,
    required this.isSubscribed,
    required this.index,
    required this.message,
  });

  final List<ChatMessage> paginated;
  final List<ChatMessage> subscribed;
  final bool isSubscribed;
  final int index;
  final ChatMessage message;

  static const _messageBatchTimeframe = Duration(minutes: 5);

  static bool _isWithinTimeframe([ChatMessage? previous, ChatMessage? next]) {
    if (previous?.date == null || next?.date == null) return false;

    final a = previous!.date.millisecondsSinceEpoch;
    final b = next!.date.millisecondsSinceEpoch;

    return (a - b).abs() <= _messageBatchTimeframe.inMilliseconds;
  }

  @override
  Widget build(BuildContext context) {
    final items = isSubscribed ? subscribed : paginated;
    final next = index > 0 ? items[index - 1] : null;
    final previous = index < (items.length - 1) ? items[index + 1] : null;
    final currentDate = message.date;
    final previousDate = previous?.date;
    final previousDay = previousDate?.day ?? currentDate.day;
    final nextDay = next?.date.day ?? currentDate.day;

    // Make sure page breaks register the messages as not similar.
    bool similarNext =
        next?.sender == message.sender && nextDay == currentDate.day && _isWithinTimeframe(message, next);
    bool similarPrevious =
        previous?.sender == message.sender && previousDay == currentDate.day && _isWithinTimeframe(previous, message);

    // Subscribed items are in a reversed order.
    if (isSubscribed) {
      final prev = similarPrevious;
      similarPrevious = similarNext;
      similarNext = prev;
    }

    return ChatMessageTile(
      message: message,
      similarPrevious: similarPrevious,
      similarNext: similarNext,
      padding: EdgeInsets.only(
        top: similarPrevious ? Dimensions.lines : xs,
        bottom: similarNext ? Dimensions.lines : xs,
      ),
    );
  }
}
