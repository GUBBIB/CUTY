import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null); // Init with null (logged out)
  
  // Login: Use ApiService
  Future<bool> login(String email, String password) async {
    print("Attempting login for $email...");
    final success = await ApiService.instance.login(email, password);
    
    if (success) {
      print("Login successful. Fetching user info...");
      final user = await ApiService.instance.fetchMyInfo();
      if (user != null) {
        state = user;
        print("User info loaded: ${user.name}");
        return true;
      } else {
        print("Failed to fetch user info after login.");
      }
    } else {
      print("Login failed.");
    }
    return false;
  }

  // Logout: Clear state
  void logout() {
    state = null;
    // ApiService.instance.logout(); // Implement storage clear if needed
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
