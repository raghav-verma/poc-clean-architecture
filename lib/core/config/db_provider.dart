import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_clean_arch_template/core/utils/constants.dart';

/// Hive-backed local DB provider. Boxes are opened lazily and reused.
class DBProvider {
  Box? _userBox;
  Box? _rolesBox;

  Future<Box> _getUserBox() async {
    _userBox ??= await Hive.openBox(DBConstants.userLocalDB);
    return _userBox!;
  }

  Future<Box> _getRolesBox() async {
    _rolesBox ??= await Hive.openBox(DBConstants.rolesLocalDB);
    return _rolesBox!;
  }

  Future<bool> saveUserInformation({required final String userData}) async {
    final box = await _getUserBox();
    await box.clear();
    await box.put("data", userData);
    return true;
  }

  Future<String?> getUserInformation() async {
    final box = await _getUserBox();
    return box.get("data");
  }

  Future<bool> saveRoles({required final String roles}) async {
    final box = await _getRolesBox();
    await box.clear();
    await box.put("data", roles);
    return true;
  }

  Future<String?> getRoles() async {
    final box = await _getRolesBox();
    return box.get("data");
  }

  Future<void> logout() async {
    final userBox = await _getUserBox();
    final rolesBox = await _getRolesBox();

    await userBox.clear();
    await rolesBox.clear();
  }
}
