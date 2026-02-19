import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  int _currentStep = 0; // 0: 약관동의, 1: 정보입력, 2: 가입완료

  // Step 1: Terms
  bool _agreeTerms = false;
  bool _agreePrivacy = false;

  // Step 2: Info
  String _email = '';
  String _password = '';
  String _passwordConfirm = '';

  int get currentStep => _currentStep;
  bool get agreeTerms => _agreeTerms;
  bool get agreePrivacy => _agreePrivacy;
  String get email => _email;
  String get password => _password;
  String get passwordConfirm => _passwordConfirm;

  bool get isTermsAllChecked => _agreeTerms && _agreePrivacy;
  // Dev Mode: Allow any input with length >= 1
  bool get isInfoValid => _email.isNotEmpty && _password.isNotEmpty; 
  bool get isPwMismatch => _passwordConfirm.isNotEmpty && _password != _passwordConfirm;

  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void prevStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void toggleAllTerms(bool? val) {
    final newValue = val ?? false;
    _agreeTerms = newValue;
    _agreePrivacy = newValue;
    notifyListeners();
  }

  void toggleTerms(bool? val) {
    _agreeTerms = val ?? false;
    notifyListeners();
  }

  void togglePrivacy(bool? val) {
    _agreePrivacy = val ?? false;
    notifyListeners();
  }

  void updateEmail(String val) {
    _email = val;
    notifyListeners();
  }

  void updatePassword(String val) {
    _password = val;
    notifyListeners();
  }

  void updatePasswordConfirm(String val) {
    _passwordConfirm = val;
    notifyListeners();
  }

  void reset() {
    _currentStep = 0;
    _agreeTerms = false;
    _agreePrivacy = false;
    _email = '';
    _password = '';
    _passwordConfirm = '';
    notifyListeners();
  }
}
