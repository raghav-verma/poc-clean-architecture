import 'dart:ui';

import 'package:flutter_clean_arch_template/core/theme/data/custom_theme_data.dart';
import 'package:flutter/material.dart';

class AppConfig {
  AppConfig? _instance;
  bool isDarkMode = false;
  Future<AppConfig> getInstance() async {
    _instance = AppConfig();
    return _instance!;
  }

  static ThemeMode themeMode = ThemeMode.system;

  void toggleTheme() {
    if ((themeMode == ThemeMode.system)) {
      //first time handle for device default theme
      if (isSystemDarkMode()) {
        themeMode = ThemeMode.light;
      } else {
        themeMode = ThemeMode.dark;
      }
    } else {
      ////handle app toggle
      if (themeMode == ThemeMode.dark) {
        themeMode = ThemeMode.light;
      } else {
        themeMode = ThemeMode.dark;
      }
    }
  }

  bool isSystemDarkMode() {
    final brightness = PlatformDispatcher.instance.platformBrightness;
    return brightness == Brightness.dark;
  }

  ThemeData get theme {
    switch (themeMode) {
      case ThemeMode.system:
        if (isSystemDarkMode()) {
          return darkThemeData;
        } else {
          return lightThemeData;
        }
      case ThemeMode.dark:
        return darkThemeData;
      case ThemeMode.light:
        return lightThemeData;
    }
  }
}
