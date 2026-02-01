import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserState {
  final String name;
  final String university;
  final String major;
  
  UserState({
    this.name = '김쿠티',
    this.university = '한국대학교',
    this.major = '경영학과',
  });
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState());
  
  void updateUser({String? name, String? university, String? major}) {
    state = UserState(
      name: name ?? state.name,
      university: university ?? state.university,
      major: major ?? state.major,
    );
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
