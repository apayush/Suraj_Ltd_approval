import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:suraj_approval/core/constants/api_url.dart';
import 'package:suraj_approval/core/constants/app_constants.dart';
import 'package:suraj_approval/core/router/app_router.dart';
import 'package:suraj_approval/core/service/api_service.dart';
import 'package:suraj_approval/core/service/local_db.dart';
import 'package:suraj_approval/core/service/notification_service.dart';
import 'package:suraj_approval/core/utills/app_utills.dart';
import '../../../core/models/user_model.dart';
import '../../../core/utills/device_type.dart';
import '../../dashboard/controller/session_controller.dart';

class LoginController extends GetxController {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;
  final sessionController = Get.find<SessionController>();
  RxInt ipType = 1.obs;
  RxInt selectIPType = 1.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final fcmId = await NotificationService.getFcmId();
      final response = await ApiService.postData(
        ApiUrl.loginApi,
        queryParams: {
          'mUser': userIdController.text.trim(),
          'mPasswords': passwordController.text.trim(),
          'fcmid': fcmId,
          'mDeviceType': DeviceType.isMobile(Get.context!) ? 'mobile' : 'web',
        },
      );

      if (isClosed) return;
      final data = response.data;
      if (data['status'] == 'success') {
        AppUtils.showSnackBar('Login successful!');
        final userData = (data['data'] as Map);
        final jsonString = jsonEncode(userData);
        await LocalDB.setString(AppConstants.currentUser, jsonString);
        final userModel = UserModel.fromJson(data['data']);
        Get.put(userModel, permanent: true);
        Get.find<SessionController>().startSessionTimer();
        Get.offAllNamed(AppRouter.dashboardScreen);
      } else {
        errorMessage.value = 'Invalid credentials. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'Login failed. Please try again.$e';
    } finally {
      isLoading.value = false;
    }
  }

  // ! GET Base URL
  void ipTypeChanged(int? value) {
    if (value != null) {
      ipType.value = value;
    }
  }
  Future<void> getBaseUrl() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(
        ApiUrl.getBaseUrl,
        queryParams: {
          'mType': ipType.value == 1 ? 'Global': 'Local',
        },
      );
      if (response.statusCode == 200) {
        final baseURL = (response.data);
        final jsonString = jsonEncode(baseURL);
        await LocalDB.setString(AppConstants.baseUrl, jsonString);
        final newBase = baseURL['data']['mUrl'];
        ApiUrl.baseUrl = newBase;
        login();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  String? validateUserId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your User ID';
    }
    if (value.length < 3) {
      return 'User ID must be at least 3 characters';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 3) {
      return 'Password must be at least 3 characters';
    }
    return null;
  }

  @override
  void onClose() {
    userIdController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
