import 'package:get/get.dart';
import 'package:suraj_approval/feature/controller/sales_controllers/sales_controller.dart';
import 'package:suraj_approval/ui/common/sales_module/sales_screen.dart';
import '../../feature/controller/dashboard_controllers/dashboard_controller.dart';
import '../../feature/controller/finance_controllers/finance_controller.dart';
import '../../feature/controller/production_controllers/production_controller.dart';
import '../../feature/controller/purchase_controllers/purchase_controller.dart';
import '../../features/auth/controller/login_controller.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../ui/common/dashboard/dashboard_screen.dart';
import '../../ui/common/finance_module/finance_screen.dart';
import '../../ui/common/production_module/production_screen.dart';
import '../../ui/common/purchase_module/purchase_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboardScreen = '/dashboard_screen';
  static const String financeScreen = '/finance_screen';
  static const String productionScreen = '/production_screen';
  static const String purchaseScreen = '/purchase_screen';
  static const String salesScreen = '/sales_screen';

  static final List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.put(LoginController(),permanent: true);
      }),
    ),
    GetPage(
      name: dashboardScreen,
      page: () => DashboardScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DashboardController>(() => DashboardController());
      }),
    ),
    GetPage(
      name: financeScreen,
      page: () => FinanceScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<FinanceController>(() => FinanceController());
      }),
    ),
    GetPage(
      name: productionScreen,
      page: () => ProductionScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProductionController>(() => ProductionController());
      }),
    ),
    GetPage(
      name: purchaseScreen,
      page: () => PurchaseScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PurchaseController>(() => PurchaseController());
      }),
    ),
    GetPage(
      name: salesScreen,
      page: () => SalesScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SalesController>(() => SalesController());
      }),
    ),
  ];
}
