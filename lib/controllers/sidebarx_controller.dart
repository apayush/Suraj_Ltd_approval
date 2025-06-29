import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ui/utills/constants/app_dialog.dart';
import '../ui/utills/constants/app_strings.dart';
import '../ui/utills/constants/app_utills.dart';
import '../ui/utills/constants/common_widgets.dart';
import '../ui/widgets/app_module_container.dart';

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

  void toggleProfileExpanded() {
    isProfileExpanded.value = !isProfileExpanded.value;
  }

  void showAlertLogoutDialog(BuildContext context) {
    Get.dialog(
      GenericDialogBox(
        headerText: AppStrings.confirmation,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: AppText('Are you sure you want to log out?',
              softWrap: true, style: TextStyles.medium(Get.context!)),
        ),
        primaryButtonText: AppStrings.yes,
        secondaryButtonText: AppStrings.no,
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