import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../mobile/dashboard_mobile.dart';
import '../utills/constants/app_drawer.dart';
import '../utills/constants/app_routes.dart';
import '../utills/constants/app_strings.dart';
import '../web/dashboard_web.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put(HomeController());
    return const GetXNavigationController();
  }
}

class WebLayout extends StatelessWidget {
  const WebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put(HomeController());
    return const Scaffold(
      body: Row(
        children: [
          // AppDrawer(),
          Expanded(
            child: GetXNavigationController(),
          ),
        ],
      ),
    );
  }
}

class GetXNavigationController extends StatelessWidget {
  const GetXNavigationController({super.key});

  @override
  Widget build(BuildContext context) {
    var currentRoute = Get.currentRoute;
    switch (currentRoute) {
      case AppRoutes.dashboardScreen:
        return ResponsiveLayout(
          mobile: DashboardMobile(),
          tablet: DashboardMobile(),
          desktop: DashboardWeb(),
        );

      default:
        return const Center(child: Text(AppStrings.selectScreen));
    }
  }
}
