import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage_service.dart';

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _initLocale();
  }

  void _initLocale() {
    final savedCode = LocalStorageService().getLocale();
    if (savedCode != null) {
      state = Locale(savedCode);
    }
    // If null, it will default to system locale or supportedLocales[0]
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await LocalStorageService().saveLocale(locale.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});
