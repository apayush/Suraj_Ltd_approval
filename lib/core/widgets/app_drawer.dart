import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/dashboard/view/dashboard_screen.dart';
import '../../features/finance/view/finance_screen.dart';
import '../../features/production/view/production_screen.dart';
import '../../features/purchase/view/purchase_screen.dart';
import '../../features/sales/view/sales_screen.dart';
import '../router/app_router.dart';

// class AppDrawer extends Drawer {
//   const AppDrawer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final drawerController = Get.find<AppDrawerController>();
//     return SidebarXDrawer(
//       controller: drawerController.sideBarXController,
//       items: [
//         _buildListTile(
//           false,
//           context: context,
//           icon: FontAwesomeIcons.gauge,
//           title: 'Dashboard',
//           route: AppRouter.dashboardScreen,
//         ),
//         _buildListTile(
//           false,
//           context: context,
//           icon: FontAwesomeIcons.gauge,
//           title: 'Finance',
//           route: AppRouter.financeScreen,
//         ),
//         _buildListTile(
//           false,
//           context: context,
//           icon: FontAwesomeIcons.gauge,
//           title: 'Production',
//           route: AppRouter.productionScreen,
//         ),
//         _buildListTile(
//           false,
//           context: context,
//           icon: FontAwesomeIcons.gauge,
//           title: 'Purchase',
//           route: AppRouter.purchaseScreen,
//         ),
//         _buildListTile(
//           false,
//           context: context,
//           icon: FontAwesomeIcons.gauge,
//           title: 'Sales',
//           route: AppRouter.salesScreen,
//         ),
//       ],
//     );
//   }
//
//   SidebarXItem _buildListTile(
//     bool isMobile, {
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required String route,
//   }) {
//     return SidebarXItem(
//       label: title,
//       icon: icon,
//       onTap: () {
//         Get.offAllNamed(route);
//       },
//     );
//   }
// }

// class GetXNavigationController extends StatelessWidget {
//   const GetXNavigationController({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     var currentRoute = Get.currentRoute;
//     switch (currentRoute) {
//       case AppRouter.dashboardScreen:
//         return DashboardScreen();
//       case AppRouter.financeScreen:
//         return FinanceScreen();
//       case AppRouter.productionScreen:
//         return ProductionScreen();
//       case AppRouter.purchaseScreen:
//         return PurchaseScreen();
//       case AppRouter.salesScreen:
//         return SalesScreen();
//       default:
//         return const Center(child: Text('Select a screen from the drawer'));
//     }
//   }
// }
//
