import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/api_url.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/enum/page_state.dart';
import 'package:suraj_approval/core/router/app_router.dart';
import 'package:suraj_approval/core/service/api_service.dart';
import 'package:suraj_approval/core/service/local_db.dart';

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

  // Refresh notifications
  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  // Handle notification tap
  void onNotificationTap(NotificationModel notification) {
    // Navigate to detail screen based on notification type
    if (notification.mainType == MenuType.finance) {
      Get.offAllNamed(AppRouter.financeScreen, arguments: notification.subType);
    } else {}
  }

  Future<void> markAsRead(String notificationId) async {}
}
