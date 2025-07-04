import 'package:get/get.dart';
import 'package:suraj_approval/features/sales/controller/sales_controller.dart';
import 'package:suraj_approval/ui/common/sales_module/sales_screen.dart';
import '../../features/dashboard/controller/app_drawer_controller.dart';
import '../../features/dashboard/controller/dashboard_controller.dart';
import '../../features/dashboard/controller/sidebarx_controller.dart';
import '../../features/finance/controller/finance_controller.dart';
import '../../features/production/controller/production_controller.dart';
import '../../features/purchase/controller/purchase_controller.dart';
import '../../features/auth/controller/login_controller.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../ui/common/dashboard/dashboard_screen.dart';
import '../../ui/common/finance_module/finance_screen.dart';
import '../../ui/common/production_module/production_screen.dart';
import '../../ui/common/purchase_module/purchase_screen.dart';
import 'package:suraj_approval/features/onboarding/controller/onboarding_controller.dart';
import 'package:suraj_approval/features/onboarding/view/onboarding_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String onboarding = '/onboarding';
  static const String dashboardScreen = '/dashboard_screen';
  static const String financeScreen = '/finance_screen';
  static const String productionScreen = '/production_screen';
  static const String purchaseScreen = '/purchase_screen';
  static const String salesScreen = '/sales_screen';

  static final List<GetPage> routes = [
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
      binding: BindingsBuilder(() {
        Get.put(OnboardingController());
      }),
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
      binding: BindingsBuilder(() {
        Get.put(OnboardingController());
      }),
    ),
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.put(LoginController(), permanent: true);
      }),
    ),
    GetPage(
      name: dashboardScreen,
      page: () => DashboardScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SidebarController>(() => SidebarController());
        Get.lazyPut<AppDrawerController>(() => AppDrawerController());
        Get.lazyPut<DashboardController>(() => DashboardController());
      }),
    ),
    GetPage(
      name: financeScreen,
      page: () => FinanceScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SidebarController>(() => SidebarController());
        Get.lazyPut<AppDrawerController>(() => AppDrawerController());
        Get.lazyPut<FinanceController>(() => FinanceController());
      }),
    ),
    GetPage(
      name: productionScreen,
      page: () => ProductionScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SidebarController>(() => SidebarController());
        Get.lazyPut<AppDrawerController>(() => AppDrawerController());
        Get.lazyPut<ProductionController>(() => ProductionController());
      }),
    ),
    GetPage(
      name: purchaseScreen,
      page: () => PurchaseScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SidebarController>(() => SidebarController());
        Get.lazyPut<AppDrawerController>(() => AppDrawerController());
        Get.lazyPut<PurchaseController>(() => PurchaseController());
      }),
    ),
    GetPage(
      name: salesScreen,
      page: () => SalesScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SidebarController>(() => SidebarController());
        Get.lazyPut<AppDrawerController>(() => AppDrawerController());
        Get.lazyPut<SalesController>(() => SalesController());
      }),
    ),
  ];
}
