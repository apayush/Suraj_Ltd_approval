import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sidebarx/sidebarx.dart';
import '../../features/dashboard/controller/app_drawer_controller.dart';
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
    final screenType = getDeviceType(MediaQuery.of(context).size);
    final headerHeight = CustomHeader(bottom: bottom).preferredSize.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: screenType == DeviceScreenType.mobile ? SidebarXDrawer(
        controller: drawerController.sideBarXController,
        items: [
          _buildListTile(
            context: context,
            icon: FontAwesomeIcons.gaugeHigh,
            title: 'Dashboard',
            route: AppRouter.dashboardScreen,
            index: 0,
          ),
          _buildListTile(
            context: context,
            icon: FontAwesomeIcons.moneyBillTrendUp,
            title: 'Finance',
            route: AppRouter.financeScreen,
            index: 1,
          ),
          _buildListTile(
            context: context,
            icon: FontAwesomeIcons.industry,
            title: 'Production',
            route: AppRouter.productionScreen,
            index: 2,
          ),
          _buildListTile(
            context: context,
            icon: FontAwesomeIcons.cartShopping,
            title: 'Purchase',
            route: AppRouter.purchaseScreen,
            index: 3,
          ),
          _buildListTile(
            context: context,
            icon: FontAwesomeIcons.bagShopping,
            title: 'Sales',
            route: AppRouter.salesScreen,
            index: 4,
          ),
        ],
      ) : null,
      body: Row(
        children: [
          if (screenType != DeviceScreenType.mobile)
            SidebarXDrawer  (
              controller: drawerController.sideBarXController,
              items: [
                _buildListTile(
                  context: context,
                  icon: FontAwesomeIcons.gaugeHigh,
                  title: 'Dashboard',
                  route: AppRouter.dashboardScreen,
                  index: 0,
                ),
                _buildListTile(
                  context: context,
                  icon: FontAwesomeIcons.moneyBillTrendUp,
                  title: 'Finance',
                  route: AppRouter.financeScreen,
                  index: 1,
                ),
                _buildListTile(
                  context: context,
                  icon: FontAwesomeIcons.industry,
                  title: 'Production',
                  route: AppRouter.productionScreen,
                  index: 2,
                ),
                _buildListTile(
                  context: context,
                  icon: FontAwesomeIcons.cartShopping,
                  title: 'Purchase',
                  route: AppRouter.purchaseScreen,
                  index: 3,
                ),
                _buildListTile(
                  context: context,
                  icon: FontAwesomeIcons.bagShopping,
                  title: 'Sales',
                  route: AppRouter.salesScreen,
                  index: 4,
                ),
              ],
            ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: headerHeight,
                  child: CustomHeader(
                    bottom: bottom,
                  ),
                ),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width > 950 ? AppFooter() : const SizedBox.shrink(),
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
}
