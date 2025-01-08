import 'package:flutter/material.dart';
import 'settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController with ChangeNotifier {
  final SettingsService _settingsService;
  late ThemeMode _themeMode;

  SettingsController(this._settingsService);

  ThemeMode get themeMode => _themeMode;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    final prefs = await SharedPreferences.getInstance();
    saveNameAndRole = prefs.getBool('saveNameAndRole') ?? false;
    notifyListeners();
  }

  bool saveNameAndRole = false;

  Future<void> toggleSaveNameAndRole(bool value) async {
    saveNameAndRole = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('saveNameAndRole', value);
  }

  Future<void> updateThemeMode(ThemeMode newThemeMode) async {
    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }
}
