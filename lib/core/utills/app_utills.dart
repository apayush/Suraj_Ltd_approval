import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_module_container.dart';
import '../theme/app_colors.dart';

class AppUtils {
  // Show a simple Snackbar
  static void showSnackBar(
    String message, {
    Color? background,
    String? title,
    SnackPosition? position,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        title: title ?? 'Alert',
        message: message,
        snackPosition: position ?? SnackPosition.BOTTOM,
        isDismissible: true,
        backgroundColor: background ?? Colors.black,
        animationDuration: const Duration(milliseconds: 500),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Convert a DateTime to a formatted string
  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  static void hideKeyboard() {
    Get.focusScope?.unfocus();
  }

  static Color getDataGridRowColor(int rowIndex) {
    Color? backgroundColor = Theme.of(Get.context!).drawerTheme.backgroundColor;
    if ((rowIndex % 2) == 0) {
      // backgroundColor = Colors.grey.withOpacity(0.04);
      backgroundColor = AppColors.blue.withOpacity(0.03);
    }
    return backgroundColor ?? AppColors.blue.withOpacity(0.03);
  }

  static void showDialog({
    required BuildContext context,
    required String title,
    Widget? content,
    String? middleText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'OK',
    String? cancelText,
    Color confirmTextColor = Colors.white,
    Color cancelTextColor = Colors.black,
    Color buttonColor = AppColors.blue,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyles.medium(context),
      content: SizedBox(
        width:
            GetPlatform.isWeb
                ? Get.width *
                    0.3 // 30% of the screen width for web
                : Get.width * 0.8, // 80% of the screen width for mobile
        child: content ?? Container(),
      ),
      middleText: middleText ?? '',
      textConfirm: confirmText,
      contentPadding: const EdgeInsets.all(24),
      // textCancel: cancelText,
      confirmTextColor: confirmTextColor,
      cancelTextColor: cancelTextColor,
      buttonColor: buttonColor,
      onConfirm: onConfirm ?? Get.back,
      // Default action is to close the dialog
      onCancel:
          cancelText != null
              ? onCancel
              : null, // Default action is to close the dialog
    );
  }

  static void showActionBottomSheet(
    BuildContext context,
    Widget content, {
    bool isScrollControlled = false,
  }) {
    Get.bottomSheet(
      content,
      isScrollControlled: isScrollControlled,
      backgroundColor: Theme.of(context).canvasColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      enableDrag: true,
      isDismissible: true,
    );
  }
}

// void openLink(String url) async {
//   final Uri uri = Uri.parse(url);
//   // Check if the link can be opened
//   if (await canLaunchUrl(uri)) {
//     await launchUrl(
//       uri,
//       mode: LaunchMode.externalApplication,
//     );
//   } else {
//     throw 'Could not launch $url';
//   }
// }
