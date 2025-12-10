import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

class LocaleService extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  Locale _locale = const Locale('id');

  Locale get locale => _locale;

  // Get locale for Material widgets (fallback jv to id)
  Locale get materialLocale =>
      _locale.languageCode == 'jv' ? const Locale('id') : _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey) ?? 'id';
    _locale = Locale(localeCode);

    // Initialize date formatting for the locale
    await _initializeDateFormatting(localeCode);

    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);

    // Initialize date formatting for the new locale
    await _initializeDateFormatting(locale.languageCode);

    notifyListeners();
  }

  Future<void> _initializeDateFormatting(String localeCode) async {
    // Use Indonesian date formatting for Javanese
    final dateLocale = localeCode == 'jv'
        ? 'id_ID'
        : '${localeCode}_${localeCode.toUpperCase()}';
    try {
      await initializeDateFormatting(dateLocale, null);
    } catch (e) {
      // Fallback to id_ID if the locale is not available
      await initializeDateFormatting('id_ID', null);
    }
  }

  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'id':
        return 'Bahasa Indonesia';
      case 'jv':
        return 'Basa Jawa';
      default:
        return 'Unknown';
    }
  }
}
