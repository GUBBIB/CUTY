import 'package:flutter/material.dart';

class VisaScoreProvider extends ChangeNotifier {
  // --- State Variables ---
  String? selectedAge;
  String? educationLevel; // 박사, 석사, 학사, 전문학사
  bool isStemOrDoubleMajor = false; // 이공계 or 복수전공
  String? koreanLevel;
  String? incomeBracket;

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
  bool isSpecWalletLinked = false;

  // --- Actions ---

  void updateAge(String? value) {
    selectedAge = value;
    notifyListeners();
  }

  void updateEducation(String? level) {
    educationLevel = level;
    notifyListeners();
  }

  void updateStemStatus(bool value) {
    isStemOrDoubleMajor = value;
    notifyListeners();
  }

  void updateKoreanLevel(String? level) {
    koreanLevel = level;
    notifyListeners();
  }

  void updateIncome(String? bracket) {
    incomeBracket = bracket;
    notifyListeners();
  }

  void updateUniBonus(String? type) {
    uniBonusType = type;
    notifyListeners();
  }

  void updateKiipBonus(bool value) {
    kiipCompleted = value;
    notifyListeners();
  }

  void updateHighTechBonus(bool value) {
    highTechIndustry = value;
    notifyListeners();
  }

  void updateGovBonus(bool value) {
    govRecommendation = value;
    notifyListeners();
  }

  void updateVeteranBonus(bool value) {
    warVeteran = value;
    notifyListeners();
  }

  void updateVolunteerBonus(String? val) {
    volunteerBonus = val;
    notifyListeners();
  }

  void updateRegionalScore(int score) {
    regionalScore = score;
    notifyListeners();
  }

  void updateImmigrationPenalty(bool value) {
    immigrationViolation = value;
    notifyListeners();
  }

  void updateCriminalPenalty(bool value) {
    criminalPunishment = value;
    notifyListeners();
  }

  void toggleSpecWallet(bool value) {
    isSpecWalletLinked = value;
    if (value) {
      loadMockData(); // Auto-fill
    } else {
      reset(); // Or keep data? Request implies explicit reset usually or just unlink. Sticking to reset for clean toggle behavior as per previous code.
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
