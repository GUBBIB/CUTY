import 'package:flutter/material.dart';

class JobCapabilityProvider with ChangeNotifier {
  int? _score;

  int? get score => _score;
  bool get isDiagnosed => _score != null;

  void updateScore(int newScore) {
    _score = newScore;
    notifyListeners();
  }
}
