import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/api_url.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/enum/page_state.dart';
import 'package:suraj_approval/core/router/app_router.dart';
import 'package:suraj_approval/core/service/api_service.dart';
import 'package:suraj_approval/core/service/local_db.dart';
import 'package:suraj_approval/features/finance/controller/finance_controller.dart';
import 'package:suraj_approval/features/notifications/model/notification_model.dart';

class NotificationController extends GetxController {
  // Observable variables
  Rx<PageState> pageState = PageState.loading.obs;
  var notifications = <NotificationModel>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      pageState.value = PageState.loading;

      final user = LocalDB.getUserModel()?.mUser;
      // Replace with your actual API endpoint
      final response = await ApiService.getData(
        ApiUrl.notificationsList + '?mUser=$user',
      );
      final data = response.data;

      if (response.statusCode == 200) {
        notifications.value =
            (data as List)
                .map((json) => NotificationModel.fromJson(json))
                .toList();
        pageState.value = PageState.idle;
      } else {
        pageState.value = PageState.error;

        errorMessage.value = 'Failed to load notifications';
      }
    } catch (e) {
      pageState.value = PageState.error;

      errorMessage.value = 'Network error: ${e.toString()}';
    }
  }

  Future<void> updateNotificationLogs({required NotificationModel notification}) async {
    try {
      await ApiService.postData(
        ApiUrl.updateFCMId,
        queryParams: {
          'Nid' : notification?.nid
        },
      );
      if (isClosed) return;
    } catch (e) {
      print('Error updating FCM ID: $e');
    } finally {
    }
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  void onNotificationTap(NotificationModel notification) {
    updateNotificationLogs(notification: notification);
    if (notification.mainType == MenuType.finance) {
      redirectToNotificationTypeScreen(
        route: AppRouter.financeScreen,
        subMenuType: notification.subType,
        onExistingRouteNavigate: () {
          Get.find<FinanceController>().goTOSubMenu(notification.subType);
        },
      );
    } else if (notification.mainType == MenuType.production) {
      redirectToNotificationTypeScreen(
        route: AppRouter.productionScreen,
        subMenuType: notification.subType,
        onExistingRouteNavigate: () {
          // Get.find<ProductionController>().goTOSubMenu(notification.subType);
        },
      );
    } else if (notification.mainType == MenuType.purchase) {
      redirectToNotificationTypeScreen(
        route: AppRouter.purchaseScreen,
        subMenuType: notification.subType,
        onExistingRouteNavigate: () {
          // Get.find<PurchaseController>().goTOSubMenu(notification.subType);
        },
      );
    } else if (notification.mainType == MenuType.sales) {
      redirectToNotificationTypeScreen(
        route: AppRouter.salesScreen,
        subMenuType: notification.subType,
        onExistingRouteNavigate: () {
          // Get.find<SalesController>().goTOSubMenu(notification.subType);
        },
      );
    }
  }

  void redirectToNotificationTypeScreen({
    required String route,
    SubMenuType? subMenuType,
    required VoidCallback onExistingRouteNavigate,
  }) {
    bool targetRouteExists = Get.routing.previous == route;
    if (targetRouteExists) {
      Get.back();
      Future.microtask(() {
        onExistingRouteNavigate();
      });
    } else {
      Get.offAllNamed(route, arguments: subMenuType);
    }
  }

  Future<void> markAsRead(String notificationId) async {}
}
