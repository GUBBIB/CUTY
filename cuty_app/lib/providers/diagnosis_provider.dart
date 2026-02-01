import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod Provider Definition
final diagnosisProvider = ChangeNotifierProvider<DiagnosisProvider>((ref) {
  return DiagnosisProvider();
});

class DiagnosisProvider with ChangeNotifier {
  // 1. State Variables
  final Map<String, dynamic> _answers = {
    'target_job': '',
    'major': '',
    'topik': '',
    'exp': '',
  };

  final Map<String, dynamic> _result = {
    'visa_status': '',
    'total_score': 0,
    'score_major': 0,
    'score_exp': 0,
    'score_lang': 0,
    'score_extra': 0,
  };

  // Getters
  Map<String, dynamic> get answers => _answers;
  Map<String, dynamic> get result => _result;
  
  bool get isAnalysisDone => _result['visa_status'] != '';

  // New Getter for Riverpod Consumers expecting resultData (Adapter)
  // Warning: This is a temporary adapter. Use 'result' map directly if possible.
  // We'll update consumers to use 'result' map.

  // Update Answer
  void updateAnswer(String key, dynamic value) {
    _answers[key] = value;
    notifyListeners();
  }

  // 2. Core Logic: Analyze Spec
  void analyzeSpec() {
    // Null Safety defaults
    final String targetJob = _answers['target_job'] ?? '';
    final String major = _answers['major'] ?? '';
    final String topik = _answers['topik'] ?? '';
    final String exp = _answers['exp'] ?? '';

    // Track 1: Visa Status (Eligibility)
    String visaStatus = 'INELIGIBLE';
    
    // Define Mapping
    if (targetJob == 'IT개발' && major == '공학계열') {
      visaStatus = 'ELIGIBLE';
    } else if (targetJob == '디자인' && major == '예체능') {
      visaStatus = 'ELIGIBLE';
    } else if ((targetJob == '마케팅' || targetJob == '무역') && (major == '상경계열' || major == '인문계열')) {
      visaStatus = 'ELIGIBLE';
    }

    // Track 2: Competitiveness Score (Max 100)
    int scoreMajor = 0; // Max 40
    int scoreExp = 0;   // Max 30
    int scoreLang = 0;  // Max 20
    int scoreExtra = 10; // Max 10 (Base score)

    // Calculate Major Score (40)
    if (visaStatus == 'ELIGIBLE') {
      scoreMajor = 40;
    } else {
      scoreMajor = 20; // Partial score
    }

    // Calculate Experience Score (30)
    if (exp == '2회 이상') {
      scoreExp = 30;
    } else if (exp == '1회') {
      scoreExp = 20;
    } else {
      scoreExp = 0;
    }

    // Calculate Language Score (20)
    if (topik == '5급 이상') {
      scoreLang = 20;
    } else if (topik == '4급') {
      scoreLang = 15;
    } else if (topik == '3급 이하') {
      scoreLang = 10;
    } else {
      scoreLang = 0;
    }

    // Total
    int totalScore = scoreMajor + scoreExp + scoreLang + scoreExtra;

    // Save Results
    _result['visa_status'] = visaStatus;
    _result['total_score'] = totalScore;
    _result['score_major'] = scoreMajor;
    _result['score_exp'] = scoreExp;
    _result['score_lang'] = scoreLang;
    _result['score_extra'] = scoreExtra;

    notifyListeners();
  }
}
