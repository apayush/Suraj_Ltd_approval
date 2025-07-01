import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/router/app_router.dart';
import 'core/service/local_db.dart';
import 'core/theme/app_theme.dart';
import 'feature/controller/dashboard_controllers/app_drawer_controller.dart';
import 'feature/controller/dashboard_controllers/sidebarx_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<SidebarController>(() => SidebarController(), fenix: true);
        Get.lazyPut<AppDrawerController>(() => AppDrawerController(), fenix: true);
      }),
    );
  }
}
