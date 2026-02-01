import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PointState {
  final int totalBalance;
  final List<Map<String, dynamic>> history;
  final bool isAttendedToday;

  PointState({
    required this.totalBalance,
    required this.history,
    this.isAttendedToday = false,
  });

  PointState copyWith({
    int? totalBalance,
    List<Map<String, dynamic>>? history,
    bool? isAttendedToday,
  }) {
    return PointState(
      totalBalance: totalBalance ?? this.totalBalance,
      history: history ?? this.history,
      isAttendedToday: isAttendedToday ?? this.isAttendedToday,
    );
  }
}

class PointNotifier extends StateNotifier<PointState> {
  PointNotifier()
      : super(PointState(
          totalBalance: 3500,
          history: [
            {
              "date": "2024.01.30",
              "title": "출석체크 보상",
              "amount": 50,
              "type": "earn"
            },
            {
              "date": "2024.01.29",
              "title": "커뮤니티 글 작성",
              "amount": 100,
              "type": "earn"
            },
            {
              "date": "2024.01.28",
              "title": "프리미엄 공고 보기",
              "amount": -500,
              "type": "use"
            },
            {
              "date": "2024.01.25",
              "title": "신규 가입 환영 선물",
              "amount": 3000,
              "type": "earn"
            },
          ],
        ));

  final _fortuneMessages = [
    "오늘은 귀인을 만날 거예요! 🦸‍♂️",
    "노력한 만큼 결과가 나올 날! 🔥",
    "뜻밖의 행운이 기다려요! 🍀",
    "잠시 휴식을 취하면 더 멀리 갈 수 있어요 ☕",
    "작은 친절이 큰 기쁨으로 돌아옵니다 🎁",
  ];

  Map<String, dynamic>? drawFortune() {
    if (state.isAttendedToday) return null;

    final random = Random();
    final point = 10 + random.nextInt(41); // 10 ~ 50
    final message = _fortuneMessages[random.nextInt(_fortuneMessages.length)];

    final newHistory = List<Map<String, dynamic>>.from(state.history)
      ..insert(0, {
        "date": "오늘", 
        "title": "🥠 오늘의 포춘쿠키",
        "amount": point,
        "type": "earn"
      });

    state = state.copyWith(
      totalBalance: state.totalBalance + point,
      history: newHistory,
      isAttendedToday: true,
    );
    
    return {
      "point": point,
      "message": message,
    };
  }

  bool usePoints(int amount, String itemName) {
    if (state.totalBalance < amount) return false;

    final newHistory = List<Map<String, dynamic>>.from(state.history)
      ..insert(0, {
        "date": "오늘",
        "title": itemName,
        "amount": -amount,
        "type": "use"
      });

    state = state.copyWith(
      totalBalance: state.totalBalance - amount,
      history: newHistory,
    );
    
    return true;
  }

  // 외부에서 포인트 지급 (예: 서류 등록 보상)
  void earnPoints(int amount, String title) {
    final newHistory = List<Map<String, dynamic>>.from(state.history)
      ..insert(0, {
        "date": "오늘", 
        "title": title,
        "amount": amount,
        "type": "earn"
      });

    state = state.copyWith(
      totalBalance: state.totalBalance + amount,
      history: newHistory,
    );
  }
}

final pointProvider = StateNotifierProvider<PointNotifier, PointState>((ref) {
  return PointNotifier();
});
