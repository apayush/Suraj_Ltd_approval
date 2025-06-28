import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/controllers/deliver_drawer_controller.dart';
import 'package:shared_component/widgets/sidebarx_drawer.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suraj_ltd_approval/suraj_ltd_approval/ui/utills/constants/App_routes.dart';


class AppDrawer extends Drawer {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerController = Get.find<DeliverDrawerController>();
    return SidebarXDrawer(
      controller: drawerController.sideBarXController,
      items: [
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
