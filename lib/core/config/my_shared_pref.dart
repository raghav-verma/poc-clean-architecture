import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences wrapper for non-sensitive app/session cache data.
class MySharedPref {
  static const userType = "user_type";
  // Legacy key kept only for logout cleanup/migration from old templates.
  static const accessToken = "access_token";
  static const userId = "user_id";
  static const fcmTokenKey = "fcm_token";
  static const fcmPassedKey = "fcm_passed_to_server";
  static const showIntroScreen = "shouldShowIntroScreen";
  static const registrationFlag = "registration";
  static const userRole = "role";
  static const drinkListingCache = "drink_listing_cache";

  final SharedPreferences _pref;

  MySharedPref(this._pref);

  int getUserId() {
    return _pref.getInt(userId) ?? -1;
  }

  void setUserId(final int id) {
    _pref.setInt(userId, id);
  }

  void setUserType(final String type) {
    _pref.setString(userType, type);
  }

  String getUserType() {
    return _pref.getString(userType) ?? "";
  }

  void deleteUserType() {
    _pref.remove(userType);
  }

  void logout() {
    _pref.remove(userType);
    _pref.remove(accessToken);
    _pref.remove(fcmTokenKey);
    _pref.remove(fcmPassedKey);
    _pref.remove(userId);
    _pref.remove(userRole);
    _pref.remove(registrationFlag);
    _pref.remove(drinkListingCache);
  }

  void saveFCMToken(String token) {
    _pref.setString(fcmTokenKey, token);
  }

  String getFCMToken() {
    return _pref.getString(fcmTokenKey) ?? "";
  }

  bool shouldPassFCMTokenToServer() {
    return _pref.getBool(fcmPassedKey) != true;
  }

  void fcmTokenPassedToServer() {
    _pref.setBool(fcmPassedKey, true);
  }

  bool shouldShowIntroScreen() {
    final shouldShowIntro = _pref.getBool(showIntroScreen) ?? true;
    if (shouldShowIntro) {
      _pref.setBool(showIntroScreen, false);
    }
    return shouldShowIntro;
  }

  bool isRegistrationCompleted() {
    return _pref.getBool(registrationFlag) ?? false;
  }

  void setRegistrationCompletedFlag(bool flag) {
    _pref.setBool(registrationFlag, flag);
  }

  Future<String> getUserRole() async {
    return _pref.getString(userRole) ?? "";
  }

  Future<void> setUserRole(String role) async {
    await _pref.setString(userRole, role);
  }

  void saveDrinkListingCache(String jsonValue) {
    _pref.setString(drinkListingCache, jsonValue);
  }

  String getDrinkListingCache() {
    return _pref.getString(drinkListingCache) ?? "";
  }
}
