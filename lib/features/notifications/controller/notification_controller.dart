// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:suraj_approval/core/constants/api_url.dart';
// import 'package:suraj_approval/core/enum/page_state.dart';
// import 'dart:convert';
//
// import 'package:suraj_approval/features/notifications/model/notification_model.dart';
//
// class NotificationController extends GetxController {
//   // Observable variables
//   Rx<PageState> pageState = PageState.loading.obs;
//   var notifications = <NotificationModel>[].obs;
//   var errorMessage = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchNotifications();
//   }
//
//   Future<void> fetchNotifications() async {
//     try {
//       pageState.value = PageState.loading;
//
//       // Replace with your actual API endpoint
//       final response = await http.get(
//         Uri.parse(ApiUrl.notificationsList+"?mUser=${}"),
//         headers: {
//           'Content-Type': 'application/json',
//           // Add your authentication headers here if needed
//           // 'Authorization': 'Bearer your-token',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = json.decode(response.body);
//         notifications.value =
//             jsonData.map((json) => NotificationModel.fromJson(json)).toList();
//         pageState.value = PageState.idle;
//       } else {
//         pageState.value = PageState.error;
//
//         errorMessage.value = 'Failed to load notifications';
//       }
//     } catch (e) {
//       pageState.value = PageState.error;
//
//       errorMessage.value = 'Network error: ${e.toString()}';
//     }
//   }
//
//   // Refresh notifications
//   Future<void> refreshNotifications() async {
//     await fetchNotifications();
//   }
//
//   // Handle notification tap
//   void onNotificationTap(NotificationModel notification) {
//     // Navigate to detail screen based on notification type
//     if (notification.mainType == 'Purchase') {
//       Get.toNamed('/purchase-detail', arguments: notification);
//     } else {
//       Get.toNamed('/notification-detail', arguments: notification);
//     }
//   }
//
//   // Mark notification as read (if you have this functionality)
//   Future<void> markAsRead(String notificationId) async {
//     // Implement mark as read API call
//   }
// }
