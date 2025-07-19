import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';

import '../../features/dashboard/controller/app_drawer_controller.dart';
import '../models/user_model.dart';
import '../router/app_router.dart';
import 'app_footer.dart';
import 'app_header.dart';
import 'common_widgets.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? bottom;

  AppScaffold({super.key, required this.body, this.bottom});

  final drawerController = Get.find<AppDrawerController>();
  final userModel = Get.find<UserModel>();

  @override
  Widget build(BuildContext context) {
    final screenType = getDeviceType(MediaQuery.of(context).size);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      drawer:
          screenType == DeviceScreenType.mobile
              ? SidebarXDrawer(
                controller: drawerController.sideBarXController,
                items:
                    userModel.allowedMenus.mapIndexed((i, mainMenu) {
                      return _buildListTile(
                        context: context,
                        icon: _getMenuIcon(mainMenu?.key ?? ''),
                        title: mainMenu?.key ?? '',
                        route: _getRoute(mainMenu?.key ?? ''),
                        index: i,
                      );
                    }).toList(),
              )
              : null,
      body: Row(
        children: [
          if (screenType != DeviceScreenType.mobile)
            SidebarXDrawer(
              controller: drawerController.sideBarXController,
              items:
                  userModel.allowedMenus.mapIndexed((i, mainMenu) {
                    return _buildListTile(
                      context: context,
                      icon: _getMenuIcon(mainMenu?.key ?? ''),
                      title: mainMenu?.key ?? '',
                      route: _getRoute(mainMenu?.key ?? ''),
                      index: i,
                    );
                  }).toList(),
            ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height:
                      bottom != null
                          ? kToolbarHeight + 45
                              // ((screenType == DeviceScreenType.desktop)
                              //     ? 40
                              //     : 40)
                          : null,
                  child: CustomHeader(bottom: bottom),
                ),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          MediaQuery.of(context).size.width > 950
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
        Get.toNamed(route);
      },
    );
  }

  IconData _getMenuIcon(String title) {
    print('title : $title');
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
        print('goin to purchase screen');
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
