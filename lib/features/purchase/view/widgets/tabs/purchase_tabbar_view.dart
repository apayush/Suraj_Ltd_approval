import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/widgets/loading_widget.dart';
import '../../../controller/purchase_controller.dart';

class PurchaseTabBarView extends GetView<PurchaseController> {
  PurchaseTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.myTabs.isEmpty || controller.tabController.length == 0) {
      return const Center(child: LoadingIndicator());
    }

    return TabBarView(
      controller: controller.tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: controller.tabViews,
    );
  }
}
