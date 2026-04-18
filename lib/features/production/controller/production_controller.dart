import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/service/local_db.dart';
import 'package:suraj_approval/features/production/view/widgets/tabs/widgets/production_view.dart';

import '../../../core/constants/app_enum.dart';

class ProductionController extends GetxController {
  static ProductionController get instance => Get.find();

  RxBool isLoading = false.obs;

  // ─── Outer Tab (no TabController needed) ──────────────────────────────────
  RxInt selectedTabIndex = 0.obs;
  List<String> myTabs = [];
  List<Widget> tabViews = [];

  /// The currently active production sub-menu (e.g. hourlyProductionEntry)
  final Rx<SubMenuType> currentSubMenu = SubMenuType.hourlyProductionEntry.obs;

  @override
  void onInit() {
    super.onInit();
    final userModel = LocalDB.getUserModel();
    final subMenus = userModel?.getSubMenusFor(MenuType.production) ?? [];

    // Build one tab label + view per sub-menu the user has access to.
    for (var sm in subMenus) {
      myTabs.add(sm.key);
      tabViews.add(ProductionView(subMenuType: sm));
    }

    if (subMenus.isNotEmpty) {
      currentSubMenu.value = subMenus.first;
    }
  }

  void onOuterTabTapped(int index) {
    if (selectedTabIndex.value == index) return; // guard against same-tab tap
    selectedTabIndex.value = index;
    final userModel = LocalDB.getUserModel();
    final subMenus = userModel?.getSubMenusFor(MenuType.production) ?? [];
    if (index < subMenus.length) {
      currentSubMenu.value = subMenus[index];
    }
  }
}
