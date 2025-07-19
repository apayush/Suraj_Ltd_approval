import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:suraj_approval/core/router/app_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utills/app_module_container.dart';
import '../../../core/utills/storage_utills.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/common_widgets.dart';

class SessionController extends GetxController {
  Timer? _inactivityTimer;
  final int sessionTimeout = 30 * 60 * 1000; // 15 minutes for production
  // final int sessionTimeout = 10 * 1000; // 10 seconds for testing
  final storageUtils = GetIt.I<StorageUtils>();

  // @override
  // void onInit() {
  //   super.onInit();
  //   _startInactivityTimer(); // Start the inactivity timer on app load
  // }

  // Start the session timer when user logs in
  void startSessionTimer() {
    if (!kIsWeb) return;
    print('session timer started');

    _startInactivityTimer();
  }

  // Stop the session timer when user logs out
  void stopSessionTimer() {
    print('session timer stopped');
    _inactivityTimer?.cancel();
  }

  // Start the inactivity timer
  void _startInactivityTimer() {
    print('Starting inactivity timer');
    _inactivityTimer?.cancel(); // Cancel any existing timer
    _inactivityTimer = Timer(
      Duration(milliseconds: sessionTimeout),
      _showSessionExpiredDialog,
    );
  }

  // Reset the timer whenever the user interacts with the app
  void resetInactivityTimer() {
    print('Resetting inactivity timer');
    if (Get.currentRoute != AppRouter.login) {
      _startInactivityTimer();
    }
  }

  // Logout function that logs the user out and redirects to the login page
  Future<void> _logout() async {
    stopSessionTimer(); // Stop the timer upon logout
    Get.back(); // Close the dialog
    await storageUtils.clearUserData();
    Get.offAllNamed(AppRouter.login);
  }

  @override
  void onClose() {
    _inactivityTimer
        ?.cancel(); // Cancel the timer when the controller is disposed
    super.onClose();
  }

  // Show session expired dialog box
  void _showSessionExpiredDialog() {
    Get.dialog(
      barrierDismissible: false,
      GenericDialogBox(
        headerText: AppStrings.youHaveLoggedOut,
        showCloseIcon: false,
        content: AppText(
          AppStrings.sessionHasExpired2,
          softWrap: true,
          style: TextStyles.medium(Get.context!),
        ),
        primaryButtonText: AppStrings.loginAgain,
        onPrimaryButtonPressed: () {
          _logout();
        },
      ),
    );
  }
}
