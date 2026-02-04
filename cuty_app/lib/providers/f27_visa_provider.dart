import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class VisaScoreProvider extends ChangeNotifier {
  // --- State Variables ---
  String? selectedAge;
  String? educationLevel; // 박사, 석사, 학사, 전문학사
  bool isStemOrDoubleMajor = false; // 이공계 or 복수전공
  String? koreanLevel;
  String? incomeBracket;

  VisaScoreProvider() {
    _loadAllData();
  }

  void _loadAllData() {
    final ls = LocalStorageService();
    isSpecWalletLinked = ls.getWalletLink();
    
    selectedAge = ls.getString('f27_age');
    educationLevel = ls.getString('f27_education');
    isStemOrDoubleMajor = ls.getBool('f27_stem');
    koreanLevel = ls.getString('f27_korean');
    incomeBracket = ls.getString('f27_income');
    uniBonusType = ls.getString('f27_uni_bonus');
    kiipCompleted = ls.getBool('f27_kiip');
    highTechIndustry = ls.getBool('f27_hightech');
    govRecommendation = ls.getBool('f27_gov');
    warVeteran = ls.getBool('f27_veteran');
    volunteerBonus = ls.getString('f27_volunteer');
    regionalScore = ls.getInt('f27_region');
    immigrationViolation = ls.getBool('f27_immigration');
    criminalPunishment = ls.getBool('f27_criminal');

    if (isSpecWalletLinked && selectedAge == null) {
       loadMockData();
    }
  }

  // --- Bonus Items ---
  String? uniBonusType; // 'top_global', 'domestic', or null
  bool kiipCompleted = false; // 사회통합 5단계 이수
  bool highTechIndustry = false; // 첨단분야 종사
  bool govRecommendation = false; // 중앙행정기관장 추천
  bool warVeteran = false; // 참전국 우수인재
  String? volunteerBonus; // 봉사활동 (3년/2년/1년)
  
  // Regional Score (Input)
  int regionalScore = 0; 
  
  // --- Penalty Items ---
  bool immigrationViolation = false;
  bool criminalPunishment = false;

  // --- UI State ---
  bool isSpecWalletLinked = LocalStorageService().getWalletLink();

  // --- Actions ---

  void updateAge(String? value) {
    selectedAge = value;
    LocalStorageService().saveString('f27_age', value ?? '');
    notifyListeners();
  }

  void updateEducation(String? level) {
    educationLevel = level;
    LocalStorageService().saveString('f27_education', level ?? '');
    notifyListeners();
  }

  void updateStemStatus(bool value) {
    isStemOrDoubleMajor = value;
    LocalStorageService().saveBool('f27_stem', value);
    notifyListeners();
  }

  void updateKoreanLevel(String? level) {
    koreanLevel = level;
    LocalStorageService().saveString('f27_korean', level ?? '');
    notifyListeners();
  }

  void updateIncome(String? bracket) {
    incomeBracket = bracket;
    LocalStorageService().saveString('f27_income', bracket ?? '');
    notifyListeners();
  }

  void updateUniBonus(String? type) {
    uniBonusType = type;
    LocalStorageService().saveString('f27_uni_bonus', type ?? '');
    notifyListeners();
  }

  void updateKiipBonus(bool value) {
    kiipCompleted = value;
    LocalStorageService().saveBool('f27_kiip', value);
    notifyListeners();
  }

  void updateHighTechBonus(bool value) {
    highTechIndustry = value;
    LocalStorageService().saveBool('f27_hightech', value);
    notifyListeners();
  }

  void updateGovBonus(bool value) {
    govRecommendation = value;
    LocalStorageService().saveBool('f27_gov', value);
    notifyListeners();
  }

  void updateVeteranBonus(bool value) {
    warVeteran = value;
    LocalStorageService().saveBool('f27_veteran', value);
    notifyListeners();
  }

  void updateVolunteerBonus(String? val) {
    volunteerBonus = val;
    LocalStorageService().saveString('f27_volunteer', val ?? '');
    notifyListeners();
  }

  void updateRegionalScore(int score) {
    regionalScore = score;
    LocalStorageService().saveInt('f27_region', score);
    notifyListeners();
  }

  void updateImmigrationPenalty(bool value) {
    immigrationViolation = value;
    LocalStorageService().saveBool('f27_immigration', value);
    notifyListeners();
  }

  void updateCriminalPenalty(bool value) {
    criminalPunishment = value;
    LocalStorageService().saveBool('f27_criminal', value);
    notifyListeners();
  }

  void toggleSpecWallet(bool value) {
    isSpecWalletLinked = value;
    // 상태 변경 시 즉시 저장
    LocalStorageService().saveWalletLink(value);

    if (value) {
      loadMockData(); 
      // Save all mocked data
      final ls = LocalStorageService();
      ls.saveString('f27_age', selectedAge ?? '');
      ls.saveString('f27_education', educationLevel ?? '');
      ls.saveBool('f27_stem', isStemOrDoubleMajor);
      ls.saveString('f27_korean', koreanLevel ?? '');
      ls.saveString('f27_income', incomeBracket ?? '');
      ls.saveString('f27_uni_bonus', uniBonusType ?? '');
      ls.saveBool('f27_kiip', kiipCompleted);
      ls.saveBool('f27_hightech', highTechIndustry);
      ls.saveBool('f27_gov', govRecommendation);
      ls.saveBool('f27_veteran', warVeteran);
      ls.saveString('f27_volunteer', volunteerBonus ?? '');
      ls.saveInt('f27_region', regionalScore);
      ls.saveBool('f27_immigration', immigrationViolation);
      ls.saveBool('f27_criminal', criminalPunishment);
    } else {
      reset();
      // Save all reset data (cleared)
      final ls = LocalStorageService();
      ls.saveString('f27_age', '');
      ls.saveString('f27_education', '');
      ls.saveBool('f27_stem', false);
      ls.saveString('f27_korean', '');
      ls.saveString('f27_income', '');
      ls.saveString('f27_uni_bonus', '');
      ls.saveBool('f27_kiip', false);
      ls.saveBool('f27_hightech', false);
      ls.saveBool('f27_gov', false);
      ls.saveBool('f27_veteran', false);
      ls.saveString('f27_volunteer', '');
      ls.saveInt('f27_region', 0);
      ls.saveBool('f27_immigration', false);
      ls.saveBool('f27_criminal', false);
    }
    notifyListeners();
  }

  void reset() {
    selectedAge = null;
    educationLevel = null;
    isStemOrDoubleMajor = false;
    koreanLevel = null;
    incomeBracket = null;
    uniBonusType = null;
    kiipCompleted = false;
    highTechIndustry = false;
    govRecommendation = false;
    warVeteran = false;
    volunteerBonus = null;
    regionalScore = 0;
    immigrationViolation = false;
    criminalPunishment = false;
    isSpecWalletLinked = false;
    notifyListeners();
  }

  void loadMockData() {
    // "Golden Path" Scenario
    selectedAge = '25~29세'; // 25
    educationLevel = '석사'; // 17 (Normal) / 20 (STEM)
    isStemOrDoubleMajor = true; // -> 20
    koreanLevel = 'TOPIK 5~6급 / KIIP 5단계'; // 20
    incomeBracket = '3천만 ~ 4천만 미만'; // 30
    // Bonus
    uniBonusType = 'domestic'; // +7 (Master)
    // Calc: 25 + 20 + 20 + 30 + 7 = 102 (Wow)
    notifyListeners();
  }

  // --- Calculation Logic ---
  int calculateTotalScore() {
    int total = 0;

    // A. Age
    if (selectedAge == '25~29세') {
      total += 25;
    } else if (selectedAge == '18~24세' || selectedAge == '30~34세') {
      total += 23;
    } else if (selectedAge == '35~39세') {
      total += 20;
    } else if (selectedAge == '40~44세') {
      total += 12;
    } else if (selectedAge == '45~50세') {
      total += 8;
    } else if (selectedAge == '51세 이상') {
      total += 3;
    }

    // B. Education
    // Levels: 박사, 석사, 학사, 전문학사
    if (educationLevel == '박사') {
      total += (isStemOrDoubleMajor ? 25 : 20);
    } else if (educationLevel == '석사') {
      total += (isStemOrDoubleMajor ? 20 : 17);
    } else if (educationLevel == '학사') {
      total += (isStemOrDoubleMajor ? 17 : 15);
    } else if (educationLevel == '전문학사') {
      total += (isStemOrDoubleMajor ? 15 : 10);
    }

    // C. Korean
    if (koreanLevel == 'TOPIK 5~6급 / KIIP 5단계') {
      total += 20;
    } else if (koreanLevel == 'TOPIK 4급 / KIIP 4단계') {
      total += 15;
    } else if (koreanLevel == 'TOPIK 3급 / KIIP 3단계') {
      total += 10;
    } else if (koreanLevel == 'TOPIK 2급 / KIIP 2단계') {
      total += 5;
    } else if (koreanLevel == 'TOPIK 1급 / KIIP 1단계') {
      total += 3;
    }

    // D. Income
    if (incomeBracket == '1억 원 이상') {
      total += 60;
    } else if (incomeBracket == '9천만 ~ 1억 미만') {
      total += 58;
    } else if (incomeBracket == '8천만 ~ 9천만 미만') {
      total += 56;
    } else if (incomeBracket == '7천만 ~ 8천만 미만') {
      total += 53;
    } else if (incomeBracket == '6천만 ~ 7천만 미만') {
      total += 50;
    } else if (incomeBracket == '5천만 ~ 6천만 미만') {
      total += 45;
    } else if (incomeBracket == '4천만 ~ 5천만 미만') {
      total += 40;
    } else if (incomeBracket == '3천만 ~ 4천만 미만') {
      total += 30;
    } else if (incomeBracket == '최저임금 ~ 3천만 미만') {
      total += 10;
    }
    // '없음 / 미취업' -> 0 (Default)

    // E. Bonus (Max 40)
    int bonus = 0;
    
    // E-1. University
    if (uniBonusType == 'top_global') {
      if (educationLevel == '박사') {
        bonus += 30;
      } else if (educationLevel == '석사') {
        bonus += 20;
      } else if (educationLevel == '학사') {
        bonus += 15;
      }
    } else if (uniBonusType == 'domestic') {
       if (educationLevel == '박사') {
         bonus += 10;
       } else if (educationLevel == '석사') {
         bonus += 7;
       } else if (educationLevel == '학사') {
         bonus += 5;
       }
    }

    // E-2. Policy
    if (kiipCompleted) bonus += 10;
    if (highTechIndustry) bonus += 20;
    if (govRecommendation) bonus += 20;
    if (warVeteran) bonus += 20;

    // E-3. Volunteer
    if (volunteerBonus == '3년 이상') {
      bonus += 7;
    } else if (volunteerBonus == '2년 이상') {
      bonus += 5;
    } else if (volunteerBonus == '1년 이상') {
      bonus += 1;
    }

    // E-4. Regional
    bonus += regionalScore;

    // Cap
    if (bonus > 40) bonus = 40;
    total += bonus;

    // F. Deductions
    if (immigrationViolation) total -= 30;
    if (criminalPunishment) total -= 40;

    return total;
  }
}
