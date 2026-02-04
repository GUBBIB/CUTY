import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. PointHistory Model (Robust & Null-Safe)
class PointHistory {
  final String title;
  final DateTime date;
  final int amount;
  final String type; // 'earn' | 'use'

  PointHistory({
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
  });
}

class PointState {
  final int totalBalance;
  final List<PointHistory> history; // Changed from List<Map>
  final bool isAttendedToday;

  PointState({
    required this.totalBalance,
    required this.history,
    this.isAttendedToday = false,
  });

  PointState copyWith({
    int? totalBalance,
    List<PointHistory>? history,
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
          totalBalance: 10000, // Initial dummy balance
          history: [
            PointHistory(
              title: "튜토리얼 완료 🎁",
              date: DateTime.now().subtract(const Duration(hours: 1)),
              amount: 300,
              type: 'earn',
            ),
            PointHistory(
              title: "신규 가입 축하금 🎉",
              date: DateTime.now().subtract(const Duration(days: 1)),
              amount: 9650,
              type: 'earn',
            ),
            PointHistory(
              title: "첫 로그인 보상",
              date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
              amount: 50,
              type: 'earn',
            ),
          ],
        ));

  // Earn Points (External)
  void earnPoints(int amount, String title) {
    final newHistory = List<PointHistory>.from(state.history)
      ..insert(0, PointHistory(
        title: title,
        date: DateTime.now(),
        amount: amount,
        type: 'earn',
      ));

    state = state.copyWith(
      totalBalance: state.totalBalance + amount,
      history: newHistory,
    );
  }

  // Use Points
  bool usePoints(int amount, String title) {
    if (state.totalBalance < amount) return false;

    final newHistory = List<PointHistory>.from(state.history)
      ..insert(0, PointHistory(
        title: title,
        date: DateTime.now(),
        amount: -amount,
        type: 'use',
      ));

    state = state.copyWith(
      totalBalance: state.totalBalance - amount,
      history: newHistory,
    );
    
    return true;
  }
}

final pointProvider = StateNotifierProvider<PointNotifier, PointState>((ref) {
  return PointNotifier();
});
