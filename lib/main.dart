import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD
import 'package:suraj_approval/bindings/dashboard_bindings.dart';
import 'package:suraj_approval/ui/utills/constants/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '',
      initialRoute: AppRoutes.dashboardScreen,
      getPages: AppRoutes.routes,
      initialBinding: DashboardBinding(),
      debugShowCheckedModeBanner: false,
=======
import 'package:shared_component/controllers/app_config_service.dart';
import 'package:shared_component/dependency/dependency_setup.dart';
import 'package:shared_component/utils/enums/clients_enum.dart';
import 'package:shared_component/utils/enums/modules_enum.dart';
import 'package:shared_component/utils/storage_utils.dart';
import 'package:suraj_ltd_approval/suraj_ltd_approval/config/app_config.dart';
import 'package:suraj_ltd_approval/suraj_ltd_approval/dependencies/deliver_dependencies.dart';
import 'package:suraj_ltd_approval/suraj_ltd_approval/ui/utills/constants/app_routes.dart';
import 'package:suraj_ltd_approval/suraj_ltd_approval/ui/widgets/common_widgets/app_get_material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/src/storage_impl.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => AppConfigService().init(
      individualProject: false, module: 0, clientType: 0)); // Set true or false as needed.
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  await AppConfig.loadConfig();
  setupDependencies(environmentName: AppConfig.baseUrl);
  AppDependencies.init();
  String initialRoute = await determineInitialRoute();
  runApp(MyApp(initialRoute: initialRoute,));
}

Future<String> determineInitialRoute() async {
  final storageUtils = GetIt.I<StorageUtils>(); // Access shared AuthService
  String? token = storageUtils.getToken();
  print("TOKEN:::::  $token");

  if (token != null && token.isNotEmpty) {
    return AppRoutes.dashboardScreen; // Navigate to dashboard if token exists
  } else {
    return AppRoutes.login; // Navigate to login if token doesn't exist
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context, ) {
    return AppGetMaterial(
      title: '',
      initialRoute: AppRoutes.dashboardScreen,
      getPages: AppRoutes.routes,
>>>>>>> f772f8103b5a646c82881509b27274af2a448dea
    );
  }
}
