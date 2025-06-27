import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeNotifier extends Notifier<ThemeMode> {
  // O construtor agora pode aceitar um valor inicial.
  AppThemeNotifier([this._initialThemeMode = ThemeMode.light]);
  final ThemeMode _initialThemeMode;

  static const themeKey = 'app_theme_mode';

  @override
  ThemeMode build() {
    // O método build agora retorna o valor inicial que foi passado durante a construção.
    return _initialThemeMode;
  }

  Future<void> setTheme(ThemeMode mode) async {
    if (state != mode) {
      state = mode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(themeKey, mode.name);
    }
  }

  Future<void> toggleTheme() async {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeKey, state.name);
  }
}

final appThemeProvider = NotifierProvider<AppThemeNotifier, ThemeMode>(
  AppThemeNotifier.new,
);
