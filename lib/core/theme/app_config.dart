import 'dart:ui';

import 'package:flutter_clean_arch_template/core/theme/data/custom_theme_data.dart';
import 'package:flutter/material.dart';

/// App-level theming configuration.
///
/// Managed as a lazy singleton via `get_it` in [setupLocator].
class AppConfig {
  bool isDarkMode = false;

  ThemeMode themeMode = ThemeMode.system;

  void toggleTheme() {
    if (themeMode == ThemeMode.system) {
      // First toggle: respect the OS default and switch to its opposite.
      themeMode = isSystemDarkMode() ? ThemeMode.light : ThemeMode.dark;
    } else {
      themeMode =
          themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    }
    isDarkMode = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && isSystemDarkMode());
  }

  bool isSystemDarkMode() {
    return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
  }

  ThemeData get theme {
    switch (themeMode) {
      case ThemeMode.system:
        return isSystemDarkMode() ? darkThemeData : lightThemeData;
      case ThemeMode.dark:
        return darkThemeData;
      case ThemeMode.light:
        return lightThemeData;
    }
  }
}
