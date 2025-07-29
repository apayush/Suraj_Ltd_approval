import 'dart:convert';
import 'package:flutter/material.dart';
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
          sessionController.logout();
          await LocalDB.clearUser(); // clear any saved storage
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
}
