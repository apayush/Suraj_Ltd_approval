import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/api_url.dart';
import '../../features/dashboard/controller/session_controller.dart';
import '../router/app_router.dart';
import '../utills/app_module_container.dart';
import '../widgets/app_dialog.dart';
import '../constants/app_strings.dart';

class ApiClient {
  late Dio _dio;
  late String _baseUrl;

  final sessionController = Get.find<SessionController>();

  void setBaseUrl(String baseUrl) {
    _dio = _dio.clone(
      options: BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: Duration(seconds: 45),
        receiveTimeout: Duration(seconds: 45),
      ),
    );
  }

  ApiClient() {
    _baseUrl = ApiUrl.baseUrlGlobal;
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: Duration(seconds: 45),
        receiveTimeout: Duration(seconds: 45),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Ensure latest baseUrl is used
          if (_baseUrl != options.baseUrl) {
            options.baseUrl = _baseUrl;
          }

          return handler.next(options); // continue
        },
        onError: (DioException e, handler) {
          if (e.type == DioExceptionType.connectionError) {
            if (Get.routing.current != AppRouter.login)
              Get.find<SessionController>().logout();
          }
          return handler.next(e);
        },
      ),
    );
  }

  void updateBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    _dio.options.baseUrl = baseUrl;
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
