import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/core/widgets/app_scaffold.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import '../../controller/production_controller.dart';

class ProductionTablet extends StatelessWidget {
  ProductionTablet({super.key});

  final controller = ProductionController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppText('Production', style: TextStyles.extraLarge(context)),
      tabs: controller.myTabs,
      selectedTabIndex: controller.selectedTabIndex,
      onTabChanged: controller.onOuterTabTapped,
      body: Obx(() => controller.tabViews[controller.selectedTabIndex.value]),
    );
  }
}
