import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences wrapper for app cache data.
class MySharedPref {
  static const drinkListingCache = "drink_listing_cache";

  final SharedPreferences _pref;

  MySharedPref(this._pref);

  void saveDrinkListingCache(String jsonValue) {
    _pref.setString(drinkListingCache, jsonValue);
  }

  String getDrinkListingCache() {
    return _pref.getString(drinkListingCache) ?? "";
  }

  void clearCache() {
    _pref.remove(drinkListingCache);
  }
}
