import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/api_url.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/enum/page_state.dart';
import 'package:suraj_approval/core/router/app_router.dart';
import 'package:suraj_approval/core/service/api_service.dart';
import 'package:suraj_approval/core/service/local_db.dart';
import 'package:suraj_approval/core/service/notification_service.dart';
import 'package:suraj_approval/features/finance/controller/finance_controller.dart';
import 'package:suraj_approval/features/notifications/model/notification_model.dart';
import 'package:suraj_approval/features/purchase/controller/purchase_controller.dart';
import 'package:suraj_approval/features/sales/controller/sales_controller.dart';

class NotificationController extends GetxController {
  // Observable variables
  Rx<PageState> pageState = PageState.loading.obs;
  var notifications = <NotificationModel>[].obs;
  var errorMessage = ''.obs;
  RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      pageState.value = PageState.loading;

      final user = LocalDB.getUserModel()?.mUser;
      final response = await ApiService.getData(
        ApiUrl.getNotificationLogs + '?mUser=$user',
      );
      final data = response.data;
      print(response.data);
      if (response.statusCode == 200) {
        notifications.value =
            (data as List)
                .map((json) => NotificationModel.fromJson(json))
                .where((e) => e.isSuccess == true)
                .toList();
        unreadCount.value = notifications.length;
        NotificationService.updateBadgeCount(unreadCount.value);
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

  Future<void> updateNotificationLogs({NotificationModel? notification}) async {
    try {
      pageState.value = PageState.loading;
      // final nidListString = notifications.map((n) => n.nid).join(',');
      // if (nidListString.isEmpty) {
      //   pageState.value = PageState.idle;
      //   return;
      // }
      final response = await ApiService.postData(
        ApiUrl.updateNotificationLogsSingle,
        queryParams: {
          'Nid': notification?.nid,
          'mUser': LocalDB.getUserModel()?.mUser ?? '',
        },
      );
      final data = response.data;
      if (response.statusCode == 200) {
        fetchNotifications();
        if(data['status']=='success'){
          int? unReadNotificationCount = data['ncount'];
          if(unReadNotificationCount!=null)
          NotificationService.updateBadgeCount(unReadNotificationCount);
        }
      }
      if (isClosed) return;
    } catch (e) {
      print('Error updating notification logs: $e');
      pageState.value = PageState.error;
    } finally {
      pageState.value = PageState.idle;
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
        arguments: {
          'subMenuType': notification.subType,
          'Srl': notification.srl,
        },
        onExistingRouteNavigate: () {
          Get.find<FinanceController>().goTOSubMenu(
            notification.subType,
            notification.srl ?? '',
          );
        },
      );
    } else if (notification.mainType == MenuType.production) {
      redirectToNotificationTypeScreen(
        route: AppRouter.productionScreen,
        arguments: {
          'subMenuType': notification.subType,
          'Srl': notification.srl,
        },
        onExistingRouteNavigate: () {
          // Get.find<ProductionController>().goTOSubMenu(notification.subType);
        },
      );
    } else if (notification.mainType == MenuType.purchase) {
      redirectToNotificationTypeScreen(
        route: AppRouter.purchaseScreen,
        arguments: {
          'subMenuType': notification.subType,
          'Srl': notification.srl,
        },
        onExistingRouteNavigate: () {
          Get.find<PurchaseController>().goTOSubMenu(
            notification.subType,
            notification.srl ?? '',
          );
        },
      );
    } else if (notification.mainType == MenuType.sales) {
      redirectToNotificationTypeScreen(
        route: AppRouter.salesScreen,
        arguments: {
          'subMenuType': notification.subType,
          'Srl': notification.srl,
        },
        onExistingRouteNavigate: () {
          Get.find<SalesController>().goTOSubMenu(notification.subType,notification.srl??'');
        },
      );
    } else {
      Get.offAndToNamed(AppRouter.dashboardScreen);
    }
  }

  void redirectToNotificationTypeScreen({
    required String route,
    Map? arguments,
    required VoidCallback onExistingRouteNavigate,
  }) {
    bool targetRouteExists = Get.routing.previous == route;
    if (targetRouteExists) {
      Get.back();
      Future.microtask(() {
        onExistingRouteNavigate();
      });
    } else {
      Get.offAllNamed(route, arguments: arguments);
    }
  }

  // Future<void> markAsRead() async {
  //   unreadCount.value = 0;
  //   updateNotificationLogs();
  // }
}
