import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/router/app_router.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/models/user_model.dart';
import '../../../core/service/local_db.dart';
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

  void showSettingsDialog(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    Get.dialog(
      GenericDialogBox(
        headerText: AppStrings.confirmation,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child:
              isMobile
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'Enter New Base URL:',
                        style: TextStyles.medium(context),
                      ),
                      10.heightGap,
                      AppTextField(hint: 'Base Url'),
                    ],
                  )
                  : Row(
                    children: [
                      AppText(
                        'Enter New Base URL:',
                        style: TextStyles.medium(context),
                      ),
                      10.widthGap,
                      Flexible(child: AppTextField(hint: 'Base Url')),
                    ],
                  ),
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
