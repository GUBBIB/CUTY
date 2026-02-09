import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final fortuneProvider = StateNotifierProvider<FortuneNotifier, FortuneState>((ref) {
  return FortuneNotifier();
});

class FortuneState {
  final bool hasOpened; // 오늘 열었는지 여부
  final bool isHidden;  // 숨김 처리 여부 (애니메이션 후 사라짐)

  const FortuneState({this.hasOpened = false, this.isHidden = false});

  FortuneState copyWith({bool? hasOpened, bool? isHidden}) {
    return FortuneState(
      hasOpened: hasOpened ?? this.hasOpened,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}

class FortuneResult {
  final String message;
  final int points;

  FortuneResult(this.message, this.points);
}

class FortuneNotifier extends StateNotifier<FortuneState> {
  FortuneNotifier() : super(const FortuneState()) {
    checkDailyStatus();
  }

  static const String _lastOpenedKey = 'last_fortune_date';

  final List<String> _fortunes = [
    "뜻밖의 행운이 찾아옵니다! 🍀",
    "오늘은 귀인을 만날 날이에요. 😊",
    "노력한 만큼 좋은 결실을 맺을 거예요. 💪",
    "기다리던 소식이 곧 도착합니다. 📩",
    "자신감을 가지세요! 당신은 최고입니다. 👍",
    "작은 행복들이 모여 큰 기쁨이 됩니다. ✨",
    "오늘은 무엇을 해도 잘 되는 날! 🎉",
    "잠시 휴식을 취하면 더 멀리 갈 수 있어요. ☕",
    "행운의 색상은 '보라색' 입니다. 💜",
    "당신의 미소가 누군가에게 힘이 됩니다. 😄",
    "새로운 기회가 문을 두드리고 있어요. 🚪",
    "걱정하지 마세요, 모든 것이 잘 될 거예요. 🌈",
  ];

  Future<void> checkDailyStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString(_lastOpenedKey);
    final today = _getTodayString();

    if (lastDate == today) {
      // 오늘 이미 열었다면 -> 숨김 처리
      state = state.copyWith(hasOpened: true, isHidden: true);
    } else {
      // 아직 안 열었다면 -> 보임
      state = state.copyWith(hasOpened: false, isHidden: false);
    }
  }

  Future<FortuneResult> openCookie() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayString();

    await prefs.setString(_lastOpenedKey, today);
    
    // 열자마자 숨김 처리 (애니메이션 등은 UI에서 처리하겠지만 데이터적으로는 숨김)
    state = state.copyWith(hasOpened: true, isHidden: true);

    final random = Random();
    final message = _fortunes[random.nextInt(_fortunes.length)];
    final points = 10 + random.nextInt(41); // 10 ~ 50 Random Points

    return FortuneResult(message, points);
  }

  String _getTodayString() {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  // Method to reset for testing
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastOpenedKey); // await 필수! 키 삭제 대기
    // 리셋 시 다시 보이게 설정
    state = state.copyWith(hasOpened: false, isHidden: false);
  }
}
