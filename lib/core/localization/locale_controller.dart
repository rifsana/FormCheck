import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_language.dart';

const String _kLocalePrefKey = 'user_selected_locale_code';

class LocaleNotifier extends Notifier<Locale> {
  SharedPreferences? _prefs;

  @override
  Locale build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    if (_prefs != null) {
      final savedCode = _prefs!.getString(_kLocalePrefKey);
      if (savedCode != null && savedCode.isNotEmpty) {
        final lang = AppLanguage.fromCode(savedCode);
        if (lang.isReady) {
          return Locale(lang.code);
        }
      }
    }
    return const Locale('en');
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (!language.isReady) return;
    state = Locale(language.code);
    if (_prefs != null) {
      await _prefs!.setString(_kLocalePrefKey, language.code);
    }
  }

  Future<void> setLocaleCode(String code) async {
    final lang = AppLanguage.fromCode(code);
    await setLanguage(lang);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
