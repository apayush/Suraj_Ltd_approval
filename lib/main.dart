import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    );
  }
}
