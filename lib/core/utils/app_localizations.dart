import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Localization class for loading different languages
class AppLocalizations {
  /// Getting instance of this class
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// Getting string from en.json
  String getString(String key) =>
      language!.containsKey(key) ? language![key] : key;

  String getStringWithPrefix(String? key, String? prefix) {
    return language!.containsKey('${prefix ?? ''}_${key ?? ''}')
        ? language!['${prefix ?? ''}_${key ?? ''}']
        : '${prefix ?? ''}_${key ?? ''}';
  }

  /// Getting list from en.json
  List<String> getList(String key) {
    final List<String> items = List.empty(growable: true);
    if (language![key] is List) {
      items.addAll(List<String>.from(language![key].whereType<String>()));
    }
    return items;
  }

  /// Getting Map list from en.json
  List<Map> getMapList(String key) {
    final List<Map> items = List.empty(growable: true);
    if (language![key] is List) {
      items.addAll(List<Map>.from(language![key].whereType<Map>()));
    }
    return items;
  }

  /// Getting HashMap from en.json
  dynamic getMap(String key) {
    return language![key];
  }
}

Map<String, dynamic>? language;

/// Class to load the json file for strings
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final String string = await rootBundle.loadString(
      "lib/localization/${locale.languageCode}.json",
    );
    language = json.decode(string);
    return SynchronousFuture<AppLocalizations>(AppLocalizations());
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
