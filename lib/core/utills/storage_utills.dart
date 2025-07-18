import 'package:get_storage/get_storage.dart';
import '../constants/app_constants.dart';
import 'package:universal_html/html.dart' as html;
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../service/local_db.dart';

class StorageUtils extends GetxService {
  final GetStorage _storage = GetStorage();

  // Check if the platform is web
  bool get isWeb => identical(0, 0.0);

  // Setters
  Future<void> setToken(String token) async => _setValue(AppConstants.tokenKey, token);
  Future<void> setUserName(String name) async => _setValue(AppConstants.userName, name);
  Future<void> setUserId(String id) async => _setValue(AppConstants.userIdKey, id);
  Future<void> setRoleId(String roleId) async => _setValue(AppConstants.roleIdKey, roleId);
  Future<void> setIsLoggedIn(bool isLoggedIn) async => _setValue(AppConstants.isLoggedInKey, isLoggedIn);
  Future<void> setItems(List<String> items) async => _setValue(AppConstants.itemsKey, items);
  Future<void> setProfile(Map<String, dynamic> profile) async => _setValue(AppConstants.profileKey, profile);
  Future<void> setLatitude(String value) async => _setValue(AppConstants.latitudeKey, value);
  Future<void> setLongitude(String value) async => _setValue(AppConstants.longitudeKey, value);
  Future<void> setFirstTimeLogin(String value) async => _setValue(AppConstants.firstTimeLoginKey, value);
  Future<void> setDarkMode(String value) async => _setValue(AppConstants.isDarkModeKey, value);
  Future<void> setLocal(String value) async => _setValue(AppConstants.localeKey, value);
  Future<void> setLocationPermission(String value) async => _setValue(AppConstants.locationPermission, value);
  Future<void> setNotificationPermission(String value) async => _setValue(AppConstants.notificationPermission, value);
  Future<void> setLoggedInUserName(String name) async => _setValue(AppConstants.loggedInUserName, name);
  Future<void> setLoggedInPassword(String name) async => _setValue(AppConstants.loggedInPassword, name);

  // Getters
  String? getToken() => _getValue(AppConstants.tokenKey);
  String? getUserName() => _getValue(AppConstants.userName);
  String? getLoggedInUserName() => _getValue(AppConstants.loggedInUserName);
  String? getLoggedInPassword() => _getValue(AppConstants.loggedInPassword);
  String? getUserId() => _getValue(AppConstants.userIdKey);
  String? getRoleId() => _getValue(AppConstants.roleIdKey);
  bool? isLoggedIn() => _getValue(AppConstants.isLoggedInKey);
  List<String>? getItems() => _getValue(AppConstants.itemsKey);
  Map<String, dynamic>? getProfile() => _getValue(AppConstants.profileKey);
  String? getLatitude() => _getValue(AppConstants.latitudeKey);
  String? getLongitude() => _getValue(AppConstants.longitudeKey);

  bool getLocationPermission() {
    final storedValue = _getValue(AppConstants.locationPermission);
    if (storedValue is String) {
      return storedValue.toLowerCase() == 'true' ? true : false;
    }
    return false;
  }

  bool getNotificationPermission() {
    final storedValue = _getValue(AppConstants.notificationPermission);
    if (storedValue is String) {
      return storedValue.toLowerCase() == 'true' ? true : false;
    }
    return false;
  }

  bool getFirstTimeLogin() {
    final storedValue = _getValue(AppConstants.firstTimeLoginKey);
    if (storedValue is String) {
      return storedValue.toLowerCase() == 'true';
    }
    return true;
  }


  dynamic _getValue(String key) {
    if (isWeb) {
      // Retrieve value from cookies in web
      return _getCookie(key);
    } else {
      // Retrieve from GetStorage in mobile and other platforms
      return _storage.read(key);
    }
  }

  // Method to retrieve a cookie by key
  String? _getCookie(String key) {
    final cookies = html.document.cookie?.split('; ') ?? [];
    for (final cookie in cookies) {
      final cookiePair = cookie.split('=');
      if (cookiePair[0] == key) {
        return cookiePair[1];
      }
    }
    return null;
  }


  // Clear all user data
  Future<void> clearUserData() async {
    if (isWeb) {
      // Clear cookies for web
      final cookies = html.document.cookie?.split('; ') ?? [];
      for (final cookie in cookies) {
        final cookiePair = cookie.split('=');
        html.document.cookie = '${cookiePair[0]}=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/';
      }
      await LocalDB.clearUser();

      if (Get.isRegistered<UserModel>()) {
        Get.delete<UserModel>(force: true); // Removes permanently registered instance
      }

      Get.delete<UserModel>();
    } else {
      // Clear GetStorage for mobile
      await _storage.erase();
    }
  }

  Future<void> _setValue(String key, dynamic value) async {
    if (isWeb) {
      // Use cookies for storage in web
      html.document.cookie = '$key=$value; path=/';
    } else {
      // Use GetStorage for mobile and other platforms
      await _storage.write(key, value);
    }
  }
}