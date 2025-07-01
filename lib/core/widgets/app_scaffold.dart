import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sidebarx/sidebarx.dart';
import '../../feature/controller/dashboard_controllers/app_drawer_controller.dart';
import '../router/app_router.dart';
import 'app_footer.dart';
import 'app_header.dart';
import 'common_widgets.dart';
import 'package:get/get.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? bottom;

  AppScaffold({
    super.key,
    required this.body,
    this.bottom,
  });

  final drawerController = Get.find<AppDrawerController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: AnimatedBuilder(
          animation: drawerController,
          builder: (context, _) {
            return Row(
              children: [
                SidebarXDrawer(
                  controller: drawerController.sideBarXController,
                  items: [
                    _buildListTile(
                      false,
                      context: context,
                      icon: FontAwesomeIcons.gaugeHigh,
                      title: 'Dashboard',
                      route: AppRouter.dashboardScreen,
                    ),
                    _buildListTile(
                      false,
                      context: context,
                      icon: FontAwesomeIcons.moneyBillTrendUp,
                      title: 'Finance',
                      route: AppRouter.financeScreen,
                    ),
                    _buildListTile(
                      false,
                      context: context,
                      icon: FontAwesomeIcons.industry,
                      title: 'Production',
                      route: AppRouter.productionScreen,
                    ),
                    _buildListTile(
                      false,
                      context: context,
                      icon: FontAwesomeIcons.cartShopping,
                      title: 'Purchase',
                      route: AppRouter.purchaseScreen,
                    ),
                    _buildListTile(
                      false,
                      context: context,
                      icon: FontAwesomeIcons.bagShopping,
                      title: 'Sales',
                      route: AppRouter.salesScreen,
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      CustomHeader(),
                      if (bottom != null) bottom!,
                      Expanded(child: body),
                    ],
                  ),
                ),
              ],
            );
          }
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width > 950 ? AppFooter() : const SizedBox.shrink(),
    );
  }

  SidebarXItem _buildListTile(
      bool isMobile, {
        required BuildContext context,
        required IconData icon,
        required String title,
        required String route,
      }) {
    return SidebarXItem(
      label: title,
      icon: icon,
      onTap: () {
        Get.offAllNamed(route);
      },
    );
  }
}
