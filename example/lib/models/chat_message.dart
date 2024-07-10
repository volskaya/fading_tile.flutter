import 'dart:math' as math;
import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:uuid/uuid.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String text,
    required String sender,
    required DateTime date,
    required bool owned,
  }) = _ChatMessage;

  /// 1st value is reserved for self.
  static const fakeSenders = ["One", "Two", "Three"];
  static const _uuid = Uuid();
  static final _random = math.Random();

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
  factory ChatMessage.fromRandom() {
    final id = _uuid.v4();
    final wordCount = (lerpDouble(1, 10, _random.nextDouble())!.round());
    final text = loremIpsum(words: wordCount);
    final owned = const [true, false][_random.nextDouble().round()];
    final sender = owned
        ? fakeSenders.first //
        : fakeSenders[lerpDouble(1, fakeSenders.length - 1, _random.nextDouble())!.round()];

    assert(!owned || sender == fakeSenders.first);

    return ChatMessage(
      id: id,
      text: text,
      sender: sender,
      date: DateTime.now(),
      owned: owned,
    );
  }
}
