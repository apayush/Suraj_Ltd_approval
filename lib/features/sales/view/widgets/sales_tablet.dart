import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/service/local_db.dart';
import 'package:suraj_approval/features/sales/controller/sales_controller.dart';
import 'package:suraj_approval/features/sales/view/widgets/tabs/sales_tabbar_view.dart';
import '../../../../core/constants/app_enum.dart';
import '../../../../core/utills/app_module_container.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';

class SalesTablet extends GetView<SalesController> {
  SalesTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppText('Sales', style: TextStyles.extraLarge(context)),
      bottom: TabBar(
        controller: controller.tabController,
        tabs: controller.myTabs,
        onTap: (index) {
          final subMenuTypeList =
              LocalDB.getUserModel()?.getSubMenusFor(MenuType.sales) ?? [];

          SubMenuType type = subMenuTypeList[index];
          controller.searchController.clear();
          controller.isHoldVoucherModelEnabled.value = false;
          controller.isSearchActive.value = false;
          controller.currentSubMenu.value = type;
          controller.getAllData(mainType: type);
        },
        tabAlignment: TabAlignment.start,
        isScrollable: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: SalesTabbarView(),
      ),
    );
  }
}
