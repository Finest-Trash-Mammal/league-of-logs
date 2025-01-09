import 'package:flutter/material.dart';
import 'settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class SettingsController with ChangeNotifier {
  final Logger _logger = Logger();
  final SettingsService _settingsService;
  late ThemeMode _themeMode;
  late SharedPreferences _prefs;

  SettingsController(this._settingsService);

  ThemeMode get themeMode => _themeMode;

  bool saveNameAndRole = false;
  String fitnessLevel = 'Beginner';

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _prefs = await SharedPreferences.getInstance();
    saveNameAndRole = _prefs.getBool('saveNameAndRole') ?? false;
    fitnessLevel = _prefs.getString('fitnessLevel') ?? 'Beginner';
    notifyListeners();
  }

  Future<void> toggleSaveNameAndRole(bool value) async {
    try {
      saveNameAndRole = value;
      notifyListeners();
      
      await _prefs.setBool('saveNameAndRole', value);
    } on Exception catch (e) {
      print('Error toggling saveNameAndRole: $e');
    }
  }

  Future<void> setFitnessLevel(String newFitnessLevel) async {
    try {
      fitnessLevel = newFitnessLevel;
      notifyListeners();
      
      await _prefs.setString('fitnessLevel', newFitnessLevel);
    } on Exception catch (e) {
      print('Error toggling saveNameAndRole: $e');
    }
  }

  Future<void> updateThemeMode(ThemeMode newThemeMode) async {
    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }
}
