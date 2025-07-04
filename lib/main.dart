import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/router/app_router.dart';
import 'core/service/local_db.dart';
import 'core/theme/app_theme.dart';
import 'core/utills/app_utills.dart';
import 'core/widgets/page_not_found.dart';
import 'features/dashboard/controller/app_drawer_controller.dart';
import 'features/dashboard/controller/sidebarx_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await LocalDB.init();
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
