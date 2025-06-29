import 'package:get/get.dart';
// import 'package:shared_component/auth_middleware/auth_middleware.dart';
import 'package:suraj_approval/bindings/dashboard_bindings.dart';

import 'app_drawer.dart';

class AppRoutes {
  static const String dashboardScreen = '/dashboard_screen';
  static const String financeScreen = '/finance_screen';
  static const String productionScreen = '/production_screen';
  static const String purchaseScreen = '/purchase_screen';
  static const String salesScreen = '/sales_screen';

  static final routes = _getRoutes();

  static List<GetPage> _getRoutes() {

    final List<GetPage> baseRoutes = [
      _getPage(dashboardScreen, DashboardBinding()),
      _getPage(financeScreen, DashboardBinding()),
      _getPage(productionScreen, DashboardBinding()),
      _getPage(purchaseScreen, DashboardBinding()),
      _getPage(salesScreen, DashboardBinding()),

 ];

    return [
      ...baseRoutes
    ];
  }

  static GetPage _getPage(String name, Bindings binding) {
    return GetPage(
        name: name,
        page: () => const ResponsiveLayout(
          mobile: MobileScreen(),
          tablet: MobileScreen(),
          desktop: WebScreen(),
        ),
        binding: binding,);
  }
}
