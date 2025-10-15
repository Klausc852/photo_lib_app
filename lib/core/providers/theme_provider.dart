import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme modes available in the app
enum AppThemeMode {
  light,
  dark,
  custom,
}

/// Theme Provider for managing app theme state
/// Handles theme switching and persistence using SharedPreferences
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  AppThemeMode _appThemeMode = AppThemeMode.light;

  ThemeProvider() {
    _loadThemeMode();
  }

  /// Get current app theme mode
  AppThemeMode get appThemeMode => _appThemeMode;

  /// Convert AppThemeMode to Flutter's ThemeMode
  ThemeMode get themeMode {
    switch (_appThemeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.custom:
        return ThemeMode
            .light; // Custom uses light theme base with custom colors
    }
  }

  /// Check if current theme is light
  bool get isLight => _appThemeMode == AppThemeMode.light;

  /// Check if current theme is dark
  bool get isDark => _appThemeMode == AppThemeMode.dark;

  /// Check if current theme is custom
  bool get isCustom => _appThemeMode == AppThemeMode.custom;

  /// Load theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      _appThemeMode = AppThemeMode.values[themeIndex];
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
    }
  }

  /// Save theme mode to SharedPreferences
  Future<void> _saveThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, _appThemeMode.index);
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_appThemeMode == mode) return;
    _appThemeMode = mode;
    await _saveThemeMode();
    notifyListeners();
  }

  /// Toggle to next theme (Light -> Dark -> Custom -> Light)
  Future<void> toggleTheme() async {
    switch (_appThemeMode) {
      case AppThemeMode.light:
        await setThemeMode(AppThemeMode.dark);
        break;
      case AppThemeMode.dark:
        await setThemeMode(AppThemeMode.custom);
        break;
      case AppThemeMode.custom:
        await setThemeMode(AppThemeMode.light);
        break;
    }
  }

  /// Get theme mode name for display
  String get themeModeName {
    switch (_appThemeMode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.custom:
        return 'Custom';
    }
  }

  /// Get theme icon
  IconData get themeIcon {
    switch (_appThemeMode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.custom:
        return Icons.palette;
    }
  }
}
