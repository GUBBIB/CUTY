import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageNotifier extends StateNotifier<int> {
  // 초기값 0
  MessageNotifier() : super(0) {
    pickRandomIndex();
  }

  void pickRandomIndex() {
    // 0부터 5까지 (총 6개 메시지) 랜덤 선택
    state = Random().nextInt(6);
  }
}

final messageProvider = StateNotifierProvider<MessageNotifier, int>((ref) {
  return MessageNotifier();
});
