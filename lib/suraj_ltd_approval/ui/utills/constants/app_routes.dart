import 'package:get/get.dart';
import 'package:shared_component/widgets/responsive_layout.dart';
import '../../../bindings/dashboard_bindings.dart';
import '../../common/layout_base.dart';

class AppRoutes {
  static const String login = '/login';
  static final routes = _getRoutes();

  // ====================== DASHBOARD =============================

  static const String dashboardScreen = '/expense/dashboard';

  static List<GetPage> _getRoutes() {

    final List<GetPage> baseRoutes = [

      // ====================== DASHBOARD =================================
      GetPage(
        name: dashboardScreen,
        page: () => const ResponsiveLayout(
            mobile: MobileLayout(),
            tablet: MobileLayout(),
            desktop: WebLayout()),
        binding: DashboardBinding(),
      ),
    ];
      return baseRoutes;
  }
}
