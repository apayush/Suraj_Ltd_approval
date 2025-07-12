import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/router/app_router.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/utills/app_module_container.dart';

class SidebarController extends GetxController {
  RxString appVersion = 'Loading...'.obs;
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
        onPrimaryButtonPressed: () {
          Get.offAndToNamed(AppRouter.login);
        },
        onSecondaryButtonPressed: () {
          Get.back();
        },
      ),
    );
  }

  void showSettingsDialog(BuildContext context) {
    Get.dialog(
      GenericDialogBox(
        headerText: AppStrings.settings,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(children: [
            AppText('Enter New Base URL :', style: TextStyles.medium(Get.context!)),
            10.widthGap,
            Flexible(child: AppTextField(hint: 'Base Url'))
          ],)
        ),
        primaryButtonText: AppStrings.confirm,
        secondaryButtonText: AppStrings.cancel,
        onPrimaryButtonPressed: () {
          Get.back();
        },
        onSecondaryButtonPressed: () {
          Get.back();
        },
      ),
    );
  }
}
