import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/app_constants.dart';

import 'core/constants/app_enum.dart';
import 'core/router/app_router.dart';
import 'core/service/local_db.dart';
import 'features/finance/controller/finance_controller.dart';

({String route, dynamic argument}) prepareInitialRoute(RemoteMessage? message) {
  final isLoggedIn = LocalDB.getUserModel() != null;
  String route;
  dynamic argument;

  if (isLoggedIn) {
    route = AppRouter.dashboardScreen;
    if (message != null) {
      final data = message.data;

      final menuType = MenuType.fromKey(data['mainType']);
      final subMenuType = SubMenuType.fromKey(data['subType']);

      route = switch (menuType) {
        MenuType.finance => AppRouter.financeScreen,
        MenuType.purchase => AppRouter.purchaseScreen,
        MenuType.production => AppRouter.productionScreen,
        MenuType.sales => AppRouter.salesScreen,
        _ => AppRouter.dashboardScreen,
      };
      argument = {'subMenuType': subMenuType, 'Srl': data['Srl'] ?? ''};
    }
  } else {
    if (LocalDB.getBool(AppConstants.isOnBoardingComplete)) {
      route = AppRouter.login;
    } else {
      route = AppRouter.onboardingScreen;
    }
  }
  return (route: route, argument: argument);
}

void gotToSubMenuFromRoute(
  String routeName,
  SubMenuType? subMenuType,
  String srl,
) {
  switch (routeName) {
    case AppRouter.financeScreen:
      Get.find<FinanceController>().goTOSubMenu(subMenuType, srl);
      break;
    case AppRouter.purchaseScreen:
      // Get.find<PurchaseController>().goTOSubMenu(subMenuType);
      break;
    case AppRouter.salesScreen:
      // Get.find<SalesController>().goTOSubMenu(subMenuType);
      break;
    case AppRouter.productionScreen:
      // Get.find<ProductionController>().goTOSubMenu(subMenuType);
      break;
  }
}
