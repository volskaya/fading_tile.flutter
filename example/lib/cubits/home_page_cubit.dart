import 'package:app/cubits/home_page_state.dart';
import 'package:app/models/chat_message.dart';
import 'package:app/utils/our_cubit.dart';
import 'package:flutter/services.dart';

class HomePageCubit extends OurCubit<HomePageState> {
  HomePageCubit() : super(const HomePageState()) {
    state = state.copyWith(
      // Add random messages for the sake of example.
      paginated: List<ChatMessage>.generate(100, (_) => ChatMessage.fromRandom()),
    );
  }

  void addSubscribedItem({int count = 1}) {
    assert(count > 0);
    final randomMessages = List<ChatMessage>.generate(count, (_) => ChatMessage.fromRandom());

    state = state.copyWith(
      subscribed: [...state.subscribed, ...randomMessages],
    );

    HapticFeedback.lightImpact();
  }
}
