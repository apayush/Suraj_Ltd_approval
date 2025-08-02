import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as AppUtil;
import 'package:get/get.dart';
import 'package:suraj_approval/features/dashboard/controller/session_controller.dart';

import '../../../core/constants/api_url.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/local_db.dart';
import '../../../core/utills/app_module_container.dart';
import '../../../core/utills/app_utills.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/common_text_field.dart';
import '../../../core/widgets/common_widgets.dart';

class SidebarController extends GetxController {
  RxString appVersion = 'Loading...'.obs;
  RxBool isLoading = false.obs;
  final ValueNotifier<bool> isProfileExpanded = ValueNotifier(false);

  @override
  void onInit() {
    super.onInit();
  }

  void navigateToLoginScreen(BuildContext context) {
    isProfileExpanded.value = false;
    showAlertLogoutDialog(context);
  }

  void toggleProfileExpanded() {
    isProfileExpanded.value = !isProfileExpanded.value;
  }

  void showAlertLogoutDialog(BuildContext context) {
    final sessionController = Get.find<SessionController>();
    Get.dialog(
      GenericDialogBox(
        headerText: AppStrings.confirmation,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: AppText(
            'Are you sure you want to log out?',
            softWrap: true,
            style: TextStyles.medium(Get.context!),
          ),
        ),
        primaryButtonText: AppStrings.yes,
        secondaryButtonText: AppStrings.no,
        onPrimaryButtonPressed: () async {
          isLoading.value = true;
          await sessionController.logout();
          await LocalDB.clearUser(); // clear any saved storage
          isLoading.value = false;
        },
        onSecondaryButtonPressed: () {
          Get.back();
        },
        isLoading: isLoading,
      ),
    );
  }

  TextEditingController baseUrlController = TextEditingController();

  // ! Approve Reject Finance Voucher
  Future<void> postFinanceVoucher({required String newBaseUrl}) async {
    isLoading.value = true;
    try {
      final response = await ApiService.postData(
        ApiUrl.saveBaseURL,
        queryParams: {'mUrlString': baseUrlController.text},
      );
      if (response.statusCode == 200) {
        Get.back();
        if (response.data['status'] == 'success') {
          AppUtils.showSnackBar('BaseUrl Updated Successfully');
          getBaseUrl();
        }
        baseUrlController.clear();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ! GET Base URL
  Future<void> getBaseUrl() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(ApiUrl.getBaseUrl);
      if (response.statusCode == 200) {
        final baseURL = (response.data);
        final jsonString = jsonEncode(baseURL);
        await LocalDB.setString(AppConstants.baseUrl, jsonString);
        final newBase = baseURL['data']['mUrl'];
        ApiUrl.baseUrlGlobal = newBase;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ! Update Password
  void showUpdatePwdDialog(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    Get.dialog(
      GenericDialogBox(
        headerText: 'Reset Password',
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonTextField(
                controller: passwordController,
                hintText: 'New Password',
                labelText: 'New Password',
              ),
              const SizedBox(height: 10),
              CommonTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                labelText: 'Confirm Password',
              ),
            ],
          ),
        ),
        primaryButtonText: AppStrings.yes,
        secondaryButtonText: AppStrings.no,
        onPrimaryButtonPressed: () async {
          final password = passwordController.text.trim();
          final confirmPassword = confirmPasswordController.text.trim();

          if (password.isEmpty || confirmPassword.isEmpty) {
            AppUtils.showSnackBar(
                'All fields are required.'
            );
            return;
          }
          if (password != confirmPassword) {
            AppUtils.showSnackBar(
                'Passwords do not match.'
            );
            return;
          }

          await updatePwd(password: password);
        },
        onSecondaryButtonPressed: () {
          Get.back();
        },
        isLoading: isLoading,
      ),
    );
  }

  Future<void> updatePwd({required String password}) async {
    final userModel = LocalDB.getUserModel();
    isLoading.value = true;
    try {
      final response = await ApiService.postData(ApiUrl.updatePwd,queryParams: {
        'mUser' : userModel?.mUser,
        'mPwd' : password
      });
      if (response.statusCode == 200) {
        Get.back();
        AppUtils.showSnackBar(
            'Password Updated Successfully'
        );
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
