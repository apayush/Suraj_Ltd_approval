import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/service/local_db.dart';
import 'package:suraj_approval/core/widgets/app_scaffold.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/features/sales/controller/sales_controller.dart';
import '../../../../core/constants/app_enum.dart';
import '../../../../core/utills/app_module_container.dart';

class SalesWeb extends GetView<SalesController> {
  SalesWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppText('Sales', style: TextStyles.extraLarge(context)),
      tabs: controller.myTabs,
      selectedTabIndex: controller.selectedTabIndex,
      onTabChanged: (index) {
        final subMenuTypeList =
            LocalDB.getUserModel()?.getSubMenusFor(MenuType.sales) ?? [];
        if (index < subMenuTypeList.length) {
          controller.searchController.clear();
          controller.isHoldVoucherModelEnabled.value = false;
          controller.isSearchActive.value = false;
          controller.currentSubMenu.value = subMenuTypeList[index];
          controller.selectedTabIndex.value = index;
          controller.getAllData(mainType: subMenuTypeList[index]);
        }
      },
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: Obx(() => controller.tabViews.isEmpty
            ? const SizedBox.shrink()
            : controller.tabViews[controller.selectedTabIndex.value]),
      ),
    );
  }
}
