import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/api_url.dart';
import 'package:suraj_approval/core/service/notification_service.dart';
import 'core/router/app_router.dart';
import 'core/service/dependencies.dart';
import 'core/service/local_db.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/page_not_found.dart';
import 'features/dashboard/controller/app_drawer_controller.dart';
import 'features/dashboard/controller/sidebarx_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Suraj Ltd Approval',
      initialRoute: AppRouter.splash,
      getPages: AppRouter.routes,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      defaultTransition: Transition.noTransition,
      transitionDuration: Duration.zero,
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const PageNotFound(),
      ),
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<SidebarController>(() => SidebarController());
        Get.lazyPut<AppDrawerController>(() => AppDrawerController());
      }),
    );
  }
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();

  setupDependencies(baseUrl: ApiUrl.baseUrl2);
  await LocalDB.init();
}
