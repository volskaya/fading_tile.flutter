import 'package:app/models/chat_message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_state.freezed.dart';

@freezed
class HomePageState with _$HomePageState {
  const HomePageState._();

  const factory HomePageState({
    @Default([]) List<ChatMessage> paginated,
    @Default([]) List<ChatMessage> subscribed,
  }) = _HomePageState;
}
