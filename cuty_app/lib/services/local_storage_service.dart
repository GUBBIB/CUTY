import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- 1. 유저 & 설정 ---
  static const String _keyUserGoal = 'user_goal';
  static const String _keyWalletLinked = 'is_wallet_linked';
  
  Future<void> saveUserGoal(String goal) async => await _prefs?.setString(_keyUserGoal, goal);
  String? getUserGoal() => _prefs?.getString(_keyUserGoal);
  Future<void> removeUserGoal() async => await _prefs?.remove(_keyUserGoal);

  Future<void> saveWalletLink(bool value) async => await _prefs?.setBool(_keyWalletLinked, value);
  bool getWalletLink() => _prefs?.getBool(_keyWalletLinked) ?? false;

  // --- 2. 알바 신청서 (Complex Object) ---
  static const String _keyAlbaData = 'alba_permit_data';
  
  Future<void> saveAlbaData(Map<String, dynamic> jsonMap) async {
    await _prefs?.setString(_keyAlbaData, jsonEncode(jsonMap));
  }
  Map<String, dynamic>? getAlbaData() {
    final String? data = _prefs?.getString(_keyAlbaData);
    return data != null ? jsonDecode(data) : null;
  }

  // --- 3. 포인트 (Balance & History) ---
  static const String _keyPointBalance = 'point_balance';
  static const String _keyPointHistory = 'point_history';

  Future<void> savePoints(int balance, List<dynamic> historyJsonList) async {
    await _prefs?.setInt(_keyPointBalance, balance);
    await _prefs?.setString(_keyPointHistory, jsonEncode(historyJsonList));
  }
  int getPointBalance() => _prefs?.getInt(_keyPointBalance) ?? 0; // 기본 0 (또는 초기값)
  List<dynamic> getPointHistory() {
    final String? data = _prefs?.getString(_keyPointHistory);
    return data != null ? jsonDecode(data) : [];
  }

  // --- 4. 시간표 (Schedule List) ---
  static const String _keySchedule = 'schedule_list';

  Future<void> saveSchedule(List<dynamic> scheduleJsonList) async {
    await _prefs?.setString(_keySchedule, jsonEncode(scheduleJsonList));
  }
  List<dynamic> getSchedule() {
    final String? data = _prefs?.getString(_keySchedule);
    return data != null ? jsonDecode(data) : [];
  }

  // --- 5. 서류지갑 (Documents) ---
  static const String _keyDocuments = 'user_documents';
  Future<void> saveDocuments(List<dynamic> docsJsonList) async => 
      await _prefs?.setString(_keyDocuments, jsonEncode(docsJsonList));
  List<dynamic> getDocuments() {
    final String? data = _prefs?.getString(_keyDocuments);
    return data != null ? jsonDecode(data) : [];
  }

  // --- 6. 상점 보관함 (Shop Inventory) ---
  static const String _keyInventory = 'shop_inventory';
  Future<void> saveInventory(List<dynamic> inventoryJsonList) async => 
      await _prefs?.setString(_keyInventory, jsonEncode(inventoryJsonList));
  List<dynamic> getInventory() {
    final String? data = _prefs?.getString(_keyInventory);
    return data != null ? jsonDecode(data) : [];
  }

  // --- 7. 취업 진단 (Diagnosis) ---
  static const String _keyDiagnosis = 'diagnosis_data';
  Future<void> saveDiagnosis(Map<String, dynamic> jsonMap) async => 
      await _prefs?.setString(_keyDiagnosis, jsonEncode(jsonMap));
  Map<String, dynamic>? getDiagnosis() {
    final String? data = _prefs?.getString(_keyDiagnosis);
    return data != null ? jsonDecode(data) : null;
  }

  // --- 8. 알바 필터 (Job Filter) ---
  static const String _keyJobFilter = 'job_filter';
  Future<void> saveJobFilter(List<String> filters) async => 
      await _prefs?.setStringList(_keyJobFilter, filters);
  List<String> getJobFilter() => _prefs?.getStringList(_keyJobFilter) ?? [];


  // --- 9. 기타 유틸리티 (Primitive) ---
  Future<void> saveString(String key, String value) async => await _prefs?.setString(key, value);
  String? getString(String key) => _prefs?.getString(key);
  
  Future<void> saveInt(String key, int value) async => await _prefs?.setInt(key, value);
  int getInt(String key) => _prefs?.getInt(key) ?? 0;

  Future<void> saveBool(String key, bool value) async => await _prefs?.setBool(key, value);
  bool getBool(String key) => _prefs?.getBool(key) ?? false;

  // --- 개발자용 초기화 ---
  Future<void> clearAll() async => await _prefs?.clear();
}
