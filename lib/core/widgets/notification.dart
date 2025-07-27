import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/router/app_router.dart';

import '../../features/notifications/controller/notification_controller.dart' show NotificationController;

class NotificationBell extends StatefulWidget {
  final List<String> notifications;
  final int unreadCount;

  const NotificationBell({
    super.key,
    required this.notifications,
    required this.unreadCount,
  });

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  final LayerLink _layerLink = LayerLink();

  void _toggleOverlay() {
    Get.toNamed(AppRouter.notification);
    return;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleOverlay,
        child: Badge.count(
          count: controller.unreadCount.value,
          isLabelVisible: widget.unreadCount > 0,
          child: const Icon(Icons.notifications, color: Colors.black),
        ),
      ),
    );
  }
}
