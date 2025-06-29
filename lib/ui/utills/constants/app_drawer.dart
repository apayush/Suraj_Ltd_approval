import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sidebarx/src/models/sidebarx_item.dart';
import 'package:suraj_approval/ui/utills/constants/app_routes.dart';
import '../../../controllers/app_drawer_controller.dart';
import '../../mobile/dashboard_mobile.dart';
import '../../web/dashboard_web.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';

import 'common_widgets.dart';


class AppDrawer extends Drawer {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerController = Get.find<AppDrawerController>();
    return SidebarXDrawer(
      controller: drawerController.sideBarXController,
      items: [
        _buildListTile(false, context: context, icon: FontAwesomeIcons.gauge, title: 'Dashboard', route: AppRoutes.dashboardScreen),
        _buildListTile(false, context: context, icon: FontAwesomeIcons.gauge, title: 'Dashboard', route: AppRoutes.dashboardScreen),
        _buildListTile(false, context: context, icon: FontAwesomeIcons.gauge, title: 'Dashboard', route: AppRoutes.dashboardScreen),
        _buildListTile(false, context: context, icon: FontAwesomeIcons.gauge, title: 'Dashboard', route: AppRoutes.dashboardScreen),
        ],
    );
  }
  SidebarXItem _buildListTile(bool isMobile,
      {required BuildContext context,
        required IconData icon,
        required String title,
        required String route}) {
    return SidebarXItem(
        label: title,
        icon: icon,
        onTap: () {
          Get.offAllNamed(route);
        });
  }
}


class WebScreen extends StatelessWidget {
  const WebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppDrawer(),
          const Expanded(
            child: GetXNavigationController(),
          ),
        ],
      ),
    );
  }
}

class MobileScreen extends StatelessWidget {
  const MobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetXNavigationController();
  }
}

class GetXNavigationController extends StatelessWidget {
  const GetXNavigationController({super.key});

  @override
  Widget build(BuildContext context) {
    var currentRoute = Get.currentRoute;
    switch (currentRoute) {
    /// Dashboard
      case AppRoutes.dashboardScreen:
        return ResponsiveLayout(
          mobile: DashboardMobile(),
          tablet: DashboardMobile(),
          desktop: DashboardWeb(),
        );

      default:
        return const Center(child: Text('Select a screen from the drawer'));
    }
  }
}


class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => mobile,
      tablet: (BuildContext context) => tablet,
      desktop: (BuildContext context) => desktop,
      breakpoints:
      const ScreenBreakpoints(tablet: 600, desktop: 950, watch: 300),
    );
  }
}
