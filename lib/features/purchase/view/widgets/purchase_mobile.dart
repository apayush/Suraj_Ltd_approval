import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/service/local_db.dart';
import 'package:suraj_approval/features/purchase/view/widgets/tabs/purchase_tabbar_view.dart';
import '../../../../core/constants/app_enum.dart';
import '../../../../core/utills/app_module_container.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../controller/purchase_controller.dart';

class PurchaseMobile extends GetView<PurchaseController> {
  PurchaseMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppText('Purchase', style: TextStyles.extraLarge(context)),
      bottom: TabBar(
        controller: controller.tabController,
        tabs: controller.myTabs,
        onTap: (index) {
          final subMenuTypeList =
              LocalDB.getUserModel()?.getSubMenusFor(MenuType.purchase) ?? [];
          SubMenuType type = subMenuTypeList[index];
          controller.searchController.clear();
          controller.currentSubMenu.value = type;
          controller.getAllData(mainType: type);
        },
        tabAlignment: TabAlignment.start,
        isScrollable: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: PurchaseTabBarView(),
      ),
    );
  }
}
