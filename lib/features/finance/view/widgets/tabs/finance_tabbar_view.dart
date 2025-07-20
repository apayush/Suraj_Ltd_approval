import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/finance_controller.dart';

class FinanceTabView extends GetView<FinanceController> {
  FinanceTabView({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.myTabs.isEmpty || controller.tabController.length == 0) {
      return const Center(child: CircularProgressIndicator());
    }

    return TabBarView(
      controller: controller.tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: controller.tabViews,
    );
  }
}
