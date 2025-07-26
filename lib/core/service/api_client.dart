import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../features/dashboard/controller/session_controller.dart';
import '../router/app_router.dart';
import '../utills/app_module_container.dart';
import '../widgets/app_dialog.dart';
import '../constants/app_strings.dart';

class ApiClient {
  late Dio _dio;
  late String _baseUrl;

  final sessionController = Get.find<SessionController>();

  ApiClient(String initialBaseUrl) {
    _baseUrl = initialBaseUrl;
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: Duration(seconds: 45),
        receiveTimeout: Duration(seconds: 45),
      ),
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Ensure latest baseUrl is used
        if (_baseUrl != options.baseUrl) {
          options.baseUrl = _baseUrl;
        }
        return handler.next(options); // continue
      },
      onError: (DioError e, handler) {
        // Optional: handle session errors or logging
        if (e.response?.statusCode == 401) {
          _handleSessionExpired();
        } else if (e.response?.statusCode == 403 || e.response?.statusCode == 440) {
          _handleInvalidToken(e.response?.data.toString());
        }
        return handler.next(e);
      },
    ));
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
    Get.offAllNamed(AppRouter.login);
  }
}
