import 'package:flutter/material.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/service/local_db.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';

import '../../../../core/constants/app_enum.dart';
import '../../../../core/utills/app_module_container.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../controller/production_controller.dart';

class ProductionTablet extends StatelessWidget {
  ProductionTablet({super.key});

  final controller = ProductionController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppText(
        'Production',
        style: TextStyles.extraLarge(context),
      ),
      bottom: TabBar(
        controller: controller.tabController,
        tabs: controller.myTabs,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: AppColors.blue,
        indicatorWeight: 3,
        onTap: (index) {
          final subMenus =
              LocalDB.getUserModel()?.getSubMenusFor(MenuType.production) ?? [];
          if (subMenus.isNotEmpty && index < subMenus.length) {
            controller.currentSubMenu.value = subMenus[index];
          }
        },
      ),
      body: TabBarView(
        controller: controller.tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: controller.tabViews,
      ),
    );
  }
}
