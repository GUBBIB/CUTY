import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  int _currentStep = 0;
  
  String? _nationality;
  String? _region;
  String? _school;

  // 1. Nationality Data (Alphabetical)
  final List<String> nationalities = [
    'China', 'France', 'Germany', 'Japan', 'Mongolia', 
    'Philippines', 'Russia', 'UK', 'USA', 'Uzbekistan', 'Vietnam', 'Other'
  ];

  // 2. Region Data
  final List<String> regions = [
    'Seoul', 'Busan', 'Gyeonggi', 'Incheon', 'Daegu', 'Daejeon', 'Gwangju', 'Other'
  ];

  // 3. Regional University Mapping (Mock Data)
  final Map<String, List<String>> regionalSchools = {
    'Seoul': ['Seoul National Univ', 'Yonsei Univ', 'Korea Univ', 'Sungkyunkwan Univ', 'Hanyang Univ', 'Kyung Hee Univ', 'Other'],
    'Busan': ['Pusan National Univ', 'Kyungsung Univ', 'Dong-A Univ', 'Pukyong National Univ', 'Other'],
    'Gyeonggi': ['Ajou Univ', 'Gachon Univ', 'Kyonggi Univ', 'Other'],
    'Incheon': ['Incheon National Univ', 'Inha Univ', 'Other'],
    'Daegu': ['Kyungpook National Univ', 'Keimyung Univ', 'Other'],
    'Daejeon': ['KAIST', 'Chungnam National Univ', 'Other'],
    'Gwangju': ['Chonnam National Univ', 'Chosun Univ', 'Other'],
  };

  int get currentStep => _currentStep;
  String? get nationality => _nationality;
  String? get region => _region;
  String? get school => _school;

  // Logic to return schools based on selected region
  List<String> get availableSchools {
    if (_region != null && regionalSchools.containsKey(_region)) {
      return regionalSchools[_region]!;
    }
    return ['Other']; // fallback if region not selected or not mapped
  }

  void nextStep() {
    if (_currentStep < 3) {
      _currentStep++;
      notifyListeners();
    }
  }

  void updateNationality(String? val) {
    _nationality = val;
    notifyListeners();
  }

  void updateRegion(String? val) {
    if (_region != val) {
      _region = val;
      _school = null; // Reset school when region changes
      notifyListeners();
    }
  }

  void updateSchool(String? val) {
    _school = val;
    notifyListeners();
  }

  void reset() {
    _currentStep = 0;
    _nationality = null;
    _region = null;
    _school = null;
    notifyListeners();
  }
}
