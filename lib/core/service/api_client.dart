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
        // headers: {
        //   'Content-Type': 'application/json',
        //   'Accept': 'application/json',
        // },
        connectTimeout: Duration(seconds: 45),
        receiveTimeout: Duration(seconds: 45),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = storageUtils.getToken();
          if (token != null) {
            options.headers['Authorization'] = token;
          }

          if (kDebugMode) {
            logger.i('Request: ${options.method} ${options.uri}');
            if (options.headers.isNotEmpty) {
              logger.d('Headers: ${jsonEncode(options.headers)}');
            }
            if (options.queryParameters.isNotEmpty) {
              logger.d('Query Parameters: ${options.queryParameters}');
            }
            if (options.data != null) {
              logger.d('Request Body: ${options.data}');
            }
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            logger.w('Response: ${jsonEncode(response.data)}');
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          final apiName = error.requestOptions.uri.toString();

          if (error.response != null) {
            final statusCode = error.response?.statusCode;
            final errorData = error.response?.data;

            logger.e('[ERROR] API: $apiName - ${jsonEncode(errorData)}');

            switch (statusCode) {
              case 401:
              case 403:
                _handleInvalidToken(errorData['message'].toString());
                break;
              case 440:
                _handleSessionExpired();
                break;
              case 500:
                AppUtils.showSnackBar(errorData['message'].toString());
                break;
              default:
                logger.e('Unhandled status code: $statusCode');
                break;
            }
          }

          print(error.response);
          print('statusCode');
          if (error.type == DioExceptionType.connectionError) {
            logger.e(
              '[ERROR] Network error: Please check your internet connection.',
            );
          } else if (error.type == DioExceptionType.connectionTimeout) {
            logger.e('[ERROR] API: $apiName - Connection Timeout');
          }

          return handler.next(error);
        },
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
