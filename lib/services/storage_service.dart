import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class StorageService extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  Locale _locale = const Locale('pt');
  bool _soundEnabled = true;
  bool _adsRemoved = false;

  Locale get locale => _locale;
  bool get soundEnabled => _soundEnabled;
  bool get adsRemoved => _adsRemoved;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
    _isInitialized = true;
    notifyListeners();
  }

  void _loadSettings() {
    final languageCode = _prefs.getString(AppConstants.keyLanguage) ?? 'pt';
    _locale = Locale(languageCode);
    _soundEnabled = _prefs.getBool(AppConstants.keySoundEnabled) ?? true;
    _adsRemoved = _prefs.getBool(AppConstants.keyAdsRemoved) ?? false;
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _prefs.setString(AppConstants.keyLanguage, locale.languageCode);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    await _prefs.setBool(AppConstants.keySoundEnabled, enabled);
    notifyListeners();
  }

  Future<void> setAdsRemoved(bool removed) async {
    _adsRemoved = removed;
    await _prefs.setBool(AppConstants.keyAdsRemoved, removed);
    notifyListeners();
  }
}
