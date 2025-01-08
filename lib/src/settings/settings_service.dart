import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _themeKey = 'theme';

  Future<ThemeMode> themeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(_themeKey);

    if (theme == 'dark') {
      return ThemeMode.dark;
    } else if (theme == 'light') {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();

    String themeString = 'system';
    if (theme == ThemeMode.dark) {
      themeString = 'dark';
    } else if (theme == ThemeMode.light) {
      themeString = 'light';
    }

    await prefs.setString(_themeKey, themeString);
  }
}
