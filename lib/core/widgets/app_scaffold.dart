import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/service/local_db.dart';
import 'package:suraj_approval/core/utills/device_type.dart';

import '../../features/dashboard/controller/app_drawer_controller.dart';
import '../router/app_router.dart';
import 'app_footer.dart';
import 'app_header.dart';
import 'common_widgets.dart';
import 'custom_tab_bar.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Widget? title;

  // ── Custom Tab Bar params (optional) ──────────────────────────────────────
  final List<String>? tabs;
  final RxInt? selectedTabIndex;
  final void Function(int)? onTabChanged;

  AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.tabs,
    this.selectedTabIndex,
    this.onTabChanged,
  });

  final drawerController = Get.find<AppDrawerController>();
  final userModel = LocalDB.getUserModel();

  @override
  Widget build(BuildContext context) {
    final screenType = getDeviceType(MediaQuery.of(context).size);;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      // Drawer stays on Scaffold so Scaffold.of(context).openDrawer() works
      drawer: screenType == DeviceScreenType.mobile
          ? SidebarXDrawer(
              controller: drawerController.sideBarXController,
              items: userModel == null
                  ? []
                  : userModel!.allowedMenus.mapIndexed((i, mainMenu) {
                      return _buildListTile(
                        context: context,
                        icon: _getMenuIcon(mainMenu.key),
                        title: mainMenu.key,
                        route: _getRoute(mainMenu.key),
                        index: i,
                      );
                    }).toList(),
            )
          : null,
      body: Row(
        children: [
          // Persistent sidebar on tablet/web
          if (screenType != DeviceScreenType.mobile)
            SidebarXDrawer(
              controller: drawerController.sideBarXController,
              items: userModel == null
                  ? []
                  : userModel!.allowedMenus.mapIndexed((i, mainMenu) {
                      return _buildListTile(
                        context: context,
                        icon: _getMenuIcon(mainMenu.key),
                        title: mainMenu.key,
                        route: _getRoute(mainMenu.key),
                        index: i,
                      );
                    }).toList(),
            ),
          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  // ── Custom header (no AppBar) ──────────────────────────
                  CustomHeader(title: title),

                  // ── Thin divider below header ──────────────────────────
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),

                  // ── Custom tab bar (only if tabs are provided) ─────────
                  if (tabs != null &&
                      selectedTabIndex != null &&
                      onTabChanged != null)
                    CustomTabBar(
                      tabs: tabs!,
                      selectedIndex: selectedTabIndex!,
                      onTap: onTabChanged!,
                    ),

                  // ── Body fills remaining height ────────────────────────
                  Expanded(child: body),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width > 950
          ? AppFooter()
          : const SizedBox.shrink(),
    );
  }

  SidebarXItem _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required int index,
  }) {
    return SidebarXItem(
      label: title,
      icon: icon,
      onTap: () {
        drawerController.sideBarXController.selectIndex(index);
        Get.offAllNamed(route);
      },
    );
  }

  IconData _getMenuIcon(String title) {
    switch (title) {
      case 'Finance':
        return FontAwesomeIcons.moneyBillTrendUp;
      case 'Sales':
        return FontAwesomeIcons.bagShopping;
      case 'Purchase':
        return FontAwesomeIcons.cartShopping;
      case 'Production':
        return FontAwesomeIcons.industry;
      case 'Dashboard':
        return FontAwesomeIcons.gaugeHigh;
      default:
        return FontAwesomeIcons.circle;
    }
  }

  String _getRoute(String title) {
    switch (title) {
      case 'Finance':
        return AppRouter.financeScreen;
      case 'Sales':
        return AppRouter.salesScreen;
      case 'Purchase':
        return AppRouter.purchaseScreen;
      case 'Production':
        return AppRouter.productionScreen;
      case 'Dashboard':
        return AppRouter.dashboardScreen;
      default:
        return AppRouter.dashboardScreen;
    }
  }
}
