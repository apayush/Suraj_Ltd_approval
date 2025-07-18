import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../../features/dashboard/controller/session_controller.dart';
import '../router/app_router.dart';
import '../utills/app_module_container.dart';
import '../utills/app_utills.dart';
import '../utills/storage_utills.dart';
import '../widgets/app_dialog.dart';
import '../constants/app_strings.dart';

class ApiClient {
  late Dio _dio;
  late String _baseUrl;

  final storageUtils = GetIt.I<StorageUtils>();
  final sessionController = GetIt.I<SessionController>();

  final Logger logger = Logger(
    filter: ProductionFilter(),
    printer: PrettyPrinter(
      methodCount: 0,
      colors: true,
      printEmojis: false,
      noBoxingByDefault: true,
    ),
  );

  ApiClient(String initialBaseUrl) {
    _baseUrl = initialBaseUrl;
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: Duration(seconds: 45),
        receiveTimeout: Duration(seconds: 45),
      ),
    );
  }

  void updateBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    _dio.options.baseUrl = baseUrl;
  }

  void printBaseUrl() {
    print('Current Base URL: $_baseUrl');
  }

  Dio get client => _dio;

  void _handleSessionExpired() {
    if (Get.isDialogOpen != true) {
      Get.dialog(
        barrierDismissible: false,
        GenericDialogBox(
          headerText: AppStrings.youHaveLoggedOut,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Someone logged in with your credentials on another device. You will be logged out.',
              style: TextStyles.medium(Get.context!),
            ),
          ),
          primaryButtonText: AppStrings.loginAgain,
          onPrimaryButtonPressed: () {
            _logoutUser();
          },
        ),
      );
    }
  }

  void _handleInvalidToken(String? message) {
    if (Get.isDialogOpen != true) {
      Get.dialog(
        barrierDismissible: false,
        GenericDialogBox(
          headerText: 'Invalid Token',
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              message ??
                  'Your session is no longer valid. Please log in again.',
              style: TextStyles.medium(Get.context!),
            ),
          ),
          primaryButtonText: AppStrings.close,
          onPrimaryButtonPressed: () {
            _logoutUser();
          },
        ),
      );
    }
  }

  void _logoutUser() async {
    sessionController.stopSessionTimer();
    Get.back(); // Close dialog
    await storageUtils.clearUserData();
    Get.offAllNamed(AppRouter.login);
  }
}
