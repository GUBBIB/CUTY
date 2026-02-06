import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class VisaProvider extends ChangeNotifier {
  // 상태 변수 (기본값: 'research' (F-2-7))
  String _selectedVisaType = 'research';

  VisaProvider() {
    _init();
  }

  void _init() {
    // LocalStorageService는 main.dart에서 이미 init() 되었으므로 동기적으로 접근 가능
    final savedGoal = LocalStorageService().getUserGoal();
    if (savedGoal != null) {
      _selectedVisaType = savedGoal;
    } else {
      // 저장된 값이 없으면 'none'으로 설정하여 선택 화면 유도
      _selectedVisaType = 'none';
    }
  }

  // Getter
  String get selectedVisaType => _selectedVisaType;

  // Setter 메서드
  void selectVisaType(String type) {
    _selectedVisaType = type;
    LocalStorageService().saveUserGoal(type); // Save to local storage
    notifyListeners();
  }
}
