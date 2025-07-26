import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../features/dashboard/controller/session_controller.dart';
import '../../features/dashboard/controller/sidebarx_controller.dart';
import '../utills/storage_utills.dart';
import 'api_client.dart';

// final GetIt getIt = GetIt.instance;

void setupDependencies({required String baseUrl}) {
  Get.lazyPut<StorageUtils>(() => StorageUtils());
  Get.lazyPut<SessionController>(() => SessionController());
  Get.lazyPut<SidebarController>(() => SidebarController());
  Get.lazyPut<ApiClient>(() => ApiClient(baseUrl));

  // getIt.registerLazySingleton<StorageUtils>(() => StorageUtils());
  // getIt.registerLazySingleton<SessionController>(() => SessionController());
  // getIt.registerLazySingleton<SidebarController>(() => SidebarController());
  // getIt.registerLazySingleton<ApiClient>(() => ApiClient(baseUrl));
}
