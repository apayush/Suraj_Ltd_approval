import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_ltd_approval/ui/utills/constants/app_routes.dart';
import 'bindings/dashboard_bindings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Suraj Ltd Approval',
      initialRoute: AppRoutes.dashboardScreen,
      getPages: AppRoutes.routes,
      initialBinding: DashboardBinding(),
      debugShowCheckedModeBanner: false,
    );
    }
}