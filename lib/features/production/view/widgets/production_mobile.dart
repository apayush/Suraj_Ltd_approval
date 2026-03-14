import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/service/local_db.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';

import '../../../../core/constants/app_enum.dart';
import '../../../../core/utills/app_module_container.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../controller/production_controller.dart';
import 'hourly_tab_view.dart';

class ProductionMobile extends StatelessWidget {
  ProductionMobile({super.key});

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
        children: _buildTabViews(),
      ),
    );
  }

  List<Widget> _buildTabViews() {
    final subMenus =
        LocalDB.getUserModel()?.getSubMenusFor(MenuType.production) ?? [];

    if (subMenus.isEmpty) {
      // fallback during development
      return [const HourlyTabView(columns: 1)];
    }

    return subMenus.map((sm) {
      switch (sm) {
        case SubMenuType.hourlyProductionEntry:
          return const HourlyTabView(columns: 1);
        default:
          return Center(
            child: AppText(
              '${sm.key} — Coming Soon',
              style: TextStyles.normal(Get.context!),
            ),
          );
      }
    }).toList();
  }
}
