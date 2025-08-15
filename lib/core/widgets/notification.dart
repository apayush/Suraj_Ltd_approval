import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/router/app_router.dart';
import 'package:suraj_approval/features/notifications/controller/notification_controller.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  final LayerLink _layerLink = LayerLink();

  void onTap(NotificationController controller) async {
    await controller.fetchNotifications();
    // await controller.markAsRead();
    // controller.unreadCount.value = 0;
    Get.toNamed(AppRouter.notification);
    return;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
    return Obx(
      () => CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: () => onTap(controller),
          child: Badge.count(
            count: controller.unreadCount.value,
            isLabelVisible: controller.unreadCount.value > 0,
            child: const Icon(
              Icons.notifications,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
