import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:suraj_approval/core/constants/app_constants.dart';
import 'package:suraj_approval/core/models/user_model.dart';

class LocalDB {
  static late final SharedPreferences _pref;

  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await _pref.setString(key, value);
  }

  static String? getString(String key) {
    return _pref.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _pref.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _pref.getBool(key);
  }

  static Future<void> setInt(String key, int value) async {
    await _pref.setInt(key, value);
  }

  static int? getInt(String key) {
    return _pref.getInt(key);
  }

  static UserModel? getUserModel() {
    final userData = _pref.getString(AppConstants.currentUser);
    if (userData == null || userData.isEmpty) return null;
    return UserModel.fromJson(jsonDecode(userData)); // ✅ Restore from SharedPreferences
  }

  static Future<void> clearUser() async {
    await _pref.remove(AppConstants.currentUser);
  }

  // static UserModel? getUserModel() {
  //   try {
  //     final userData = _pref.getString(AppConstants.currentUser);
  //     print('🟢 Raw userData from SharedPreferences: $userData');
  //
  //     if (userData == null || userData.isEmpty) {
  //       print('🔴 No user data found in SharedPreferences');
  //       return null;
  //     }
  //
  //     final decodedData = jsonDecode(userData);
  //     print('🟢 Decoded userData: $decodedData');
  //
  //     final userModel = UserModel.fromJson(decodedData);
  //     print('🟢 UserModel created successfully: ${userModel.toJson()}');
  //     return userModel;
  //   } catch (e) {
  //     print('🔴 Error in getUserModel(): $e');
  //     return null;
  //   }
  // }
}
