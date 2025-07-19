import 'package:get_it/get_it.dart';

import '../../features/dashboard/controller/session_controller.dart';
import '../../features/dashboard/controller/sidebarx_controller.dart';
import '../utills/storage_utills.dart';
import 'api_client.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies({required String baseUrl}) {
  getIt.registerLazySingleton<StorageUtils>(() => StorageUtils());
  getIt.registerLazySingleton<SessionController>(() => SessionController());
  getIt.registerLazySingleton<SidebarController>(() => SidebarController());
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(baseUrl));
}
