import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/api_url.dart';

import '../../features/dashboard/controller/session_controller.dart';

class ApiClient {
  late Dio _dio;
  late String _baseUrl;

  final sessionController = Get.find<SessionController>();

  void setBaseUrl(String baseUrl) {
    _dio = _dio.clone(
      options: BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
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
        headers: {
          'Content-Type': 'application/json',
        },
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
            // if (Get.routing.current != AppRouter.login)
            // Get.find<SessionController>().logout();
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
}
