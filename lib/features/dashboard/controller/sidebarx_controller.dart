import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/router/app_router.dart';
import 'package:suraj_approval/core/utills/device_type.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';

import '../../../core/constants/api_url.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/models/user_model.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/local_db.dart';
import '../../../core/utills/app_module_container.dart';
import '../../../core/utills/app_utills.dart';
import '../../../core/widgets/app_dialog.dart';
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

  void navigateToSettingDialog(BuildContext context) {
    showSettingsDialog(context);
  }

  void toggleProfileExpanded() {
    isProfileExpanded.value = !isProfileExpanded.value;
  }

  void showAlertLogoutDialog(BuildContext context) {
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
          await LocalDB.clearUser(); // clear any saved storage
          Get.delete<UserModel>();
          Get.offAndToNamed(AppRouter.login);
        },
        onSecondaryButtonPressed: () {
          Get.back();
        },
      ),
    );
  }

  TextEditingController baseUrlController = TextEditingController();

  void showSettingsDialog(BuildContext context) async {
    Get.dialog(
      GenericDialogBox(
        headerText: AppStrings.confirmation,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child:
              DeviceType.isMobile(context) || DeviceType.isTablet(context)
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'Enter New Base URL:',
                        style: TextStyles.medium(context),
                      ),
                      10.heightGap,
                      AppTextField(
                        hint: 'Base Url',
                        controller: baseUrlController,
                      ),
                    ],
                  )
                  : Row(
                    children: [
                      AppText(
                        'Enter New Base URL:',
                        style: TextStyles.medium(context),
                      ),
                      10.widthGap,
                      Flexible(
                        child: AppTextField(
                          hint: 'Base Url',
                          controller: baseUrlController,
                        ),
                      ),
                    ],
                  ),
        ),
        primaryButtonText: AppStrings.confirm,
        secondaryButtonText: AppStrings.cancel,
        onPrimaryButtonPressed: () async {
          final trimmedUrl = baseUrlController.text.trim();
          if (trimmedUrl.isEmpty) {
            AppUtils.showSnackBar('Base URL cannot be empty');
            return;
          }

          if (!isValidBaseUrl(trimmedUrl)) {
            AppUtils.showSnackBar('Please enter a valid URL');
            return;
          }

          await postFinanceVoucher(newBaseUrl: trimmedUrl);
        },
        onSecondaryButtonPressed: () {
          Get.back();
        },
      ),
    );
  }

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
      final response = await ApiService.getData(
        ApiUrl.getBaseUrl,
      );
      if (response.statusCode == 200) {
        final baseURL = (response.data);
        final jsonString = jsonEncode(baseURL);
        await LocalDB.setString(AppConstants.baseUrl, jsonString);
        final newBase = baseURL['data']['mUrl'];
        ApiUrl.baseUrl = newBase;
        print('Base URL updated: $newBase');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  bool isValidBaseUrl(String url) {
    final urlPattern =
        r'^(https?:\/\/)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(:\d+)?(\/.*)?$';
    final regex = RegExp(urlPattern);
    return regex.hasMatch(url);
  }

}
