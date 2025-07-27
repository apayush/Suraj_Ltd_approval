import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:suraj_approval/core/widgets/app_pdf_viewer.dart';
import 'package:universal_html/html.dart' as html;

import '../theme/app_colors.dart';
import 'app_module_container.dart';

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
        title: title ?? null,
        messageText: Center(
          child: IntrinsicWidth(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 20.0,
              ),
              decoration: BoxDecoration(
                color: background ?? AppColors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        snackPosition: position ?? SnackPosition.BOTTOM,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.all(16),
        isDismissible: true,
        borderRadius: 0,
        duration: const Duration(seconds: 2),
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

  static Future<void> openPdf(
    String base64String, {
    String fileName = 'Report.pdf',
  }) async {
    try {
      final bytes = base64Decode(base64String);

      if (kIsWeb) {
        // ✅ Web: open in browser tab
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.window.open(url, '_blank');
        html.Url.revokeObjectUrl(url);
      } else {
        // ✅ Mobile/Desktop: save to file and open
        final dir = await getTemporaryDirectory();
        final file = io.File('${dir.path}/$fileName');
        await file.writeAsBytes(bytes);
        Get.to(AppPdfViewer(pdfFile: file));
        // final result = await OpenFile.open(file.path);
        // print('🟢 Opened PDF: ${result.message}');
      }
    } catch (e) {
      print('❌ Failed to open PDF: $e');
    }
  }

  static Future<File> base64ToPdfFile(String base64Str, String filename) async {
    final bytes = base64Decode(base64Str);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);
    return file;
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
