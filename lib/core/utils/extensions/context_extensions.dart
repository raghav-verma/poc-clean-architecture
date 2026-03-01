import 'package:flutter_clean_arch_template/core/theme/app_config.dart';
import 'package:flutter_clean_arch_template/core/theme/data/custom_theme_data.dart';
import 'package:flutter_clean_arch_template/core/utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_arch_template/injection.dart';

extension ContextExtensions on BuildContext {
  String stringForKeyObsolete(final String localizationKey) {
    return AppLocalizations.of(this).getString(localizationKey);
  }

  String stringForKey(final String? key) {
    return AppLocalizations.of(this).getString(key ?? '');
  }

  List<String> listOfStringForKey(final String localizationKey) {
    return AppLocalizations.of(this).getList(localizationKey);
  }

  Map getMapForKey(final String localizationKey) {
    return AppLocalizations.of(this).getMap(localizationKey);
  }

  List<Map> getListOfMapForKey(final String localizationKey) {
    return AppLocalizations.of(this).getMapList(localizationKey);
  }

  double get screenHeight {
    return MediaQuery.of(this).size.height;
  }

  double get screenWidth {
    return MediaQuery.of(this).size.width;
  }

  void showBottomSheet(
    Widget widget, {
    bool isDismissible = false,
    Color? backgroundColor,
  }) {
    showModalBottomSheet(
      context: this,
      backgroundColor: backgroundColor ?? const Color(0xFFF1F1F1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      isDismissible: isDismissible,
      builder: (sheetContext) {
        return widget;
      },
    );
  }

  CustomThemeData get theme {
    return Theme.of(this).extension<CustomThemeData>() ??
        (locator<AppConfig>().isDarkMode
            ? DarkCustomThemeData()
            : LightCustomThemeData());
  }

  Future<void> showToast(String message, {String? extra}) async {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('$message ${extra ?? ''}'.trim()),
          duration: const Duration(milliseconds: 1500),
        ),
      );
  }

  String get getRouteName {
    return ModalRoute.of(this)?.settings.name ?? '';
  }

  String stringForKeyWithPrefix(final String? key) {
    String prefix = getRouteName.substring(1);
    return AppLocalizations.of(this).getStringWithPrefix(key, prefix);
  }
}

extension AppNavigation on BuildContext {
  /// Function to go to previous screen
  void back() {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop();
    } else {
      SystemNavigator.pop();
    }
  }

  /// Function to go to previous screen
  void backWithData(Object? argumentClass) {
    Navigator.pop(this, argumentClass);
  }

  /// Function to navigate to new screen without data passing
  void intent(String nameRouted) {
    Navigator.pushNamed(this, nameRouted);
  }

  /// Function to navigate to new screen by replacing it with new screen
  void intentWithoutBack(String nameRouted, Object? argumentClass) {
    Navigator.pushReplacementNamed(this, nameRouted, arguments: argumentClass);
  }

  /// Function to navigate to new screen by replacing it with new screen
  Future<dynamic> intentWithoutBackWithData(
    String nameRouted,
    Object? argumentClass,
  ) {
    return Navigator.pushReplacementNamed(
      this,
      nameRouted,
      arguments: argumentClass,
    );
  }

  /// Function to navigation to new screen and remove all other screens in backstack
  void intentWithClearAllRoutes(String nameRouted) {
    Navigator.of(
      this,
    ).pushNamedAndRemoveUntil(nameRouted, (Route<dynamic> route) => false);
  }

  /// Function to navigate to new screen and passing some data
  void intentWithData(String nameRouted, Object? argumentClass) {
    Navigator.pushNamed(this, nameRouted, arguments: argumentClass);
  }

  /// Function to navigate to new screen and wait for result
  Future<dynamic> intentWithResult(String nameRouted) {
    return Navigator.pushNamed(this, nameRouted, arguments: null);
  }

  /// Function to navigate to new screen and passing some data
  Future<dynamic> intentWithDataAndResult(
    String nameRouted,
    Object? argumentClass,
  ) {
    return Navigator.pushNamed(this, nameRouted, arguments: argumentClass);
  }

  /// Function to navigation to new screen and remove all other screens in backstack
  void intentWithClearAllRoutesWithData(
    String nameRouted,
    Object? argumentClass,
  ) {
    Navigator.of(this).pushNamedAndRemoveUntil(
      nameRouted,
      (Route<dynamic> route) => false,
      arguments: argumentClass,
    );
  }
}
