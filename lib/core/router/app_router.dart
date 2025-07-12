import 'package:get/get.dart';
import 'package:suraj_approval/features/finance/controller/bank_payment_controller.dart';
import 'package:suraj_approval/features/finance/controller/bank_receipt_controller.dart';
import 'package:suraj_approval/features/onboarding/view/onboarding_screen.dart';
import 'package:suraj_approval/features/sales/controller/sales_controller.dart';
import 'package:suraj_approval/features/onboarding/controller/onboarding_controller.dart';
import 'package:suraj_approval/features/sales/view/sales_screen.dart';
import '../../features/dashboard/controller/dashboard_controller.dart';
import '../../features/dashboard/controller/session_controller.dart';
import '../../features/finance/controller/finance_controller.dart';
import '../../features/production/controller/production_controller.dart';
import '../../features/purchase/controller/purchase_controller.dart';
import '../../features/auth/controller/login_controller.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../features/dashboard/view/dashboard_screen.dart';
import '../../features/finance/view/finance_screen.dart';
import '../../features/production/view/production_screen.dart';
import '../../features/purchase/view/purchase_screen.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String onboardingScreen = '/OnboardingScreen';
  static const String dashboardScreen = '/dashboard_screen';
  static const String financeScreen = '/finance_screen';
  static const String productionScreen = '/production_screen';
  static const String purchaseScreen = '/purchase_screen';
  static const String salesScreen = '/sales_screen';

  static final List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() {
        Get.put(SessionController(), permanent: true);
      }),
    ),
    GetPage(
      name: onboardingScreen,
      page: () => const OnboardingScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<OnboardingController>(() => OnboardingController());
      }),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.put(LoginController(), permanent: true);
      }),
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
      binding: BindingsBuilder(() {
        Get.put(OnboardingController());
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
        Get.lazyPut<BankPaymentController>(() => BankPaymentController());
        Get.lazyPut<BankReceiptController>(() => BankReceiptController());
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
