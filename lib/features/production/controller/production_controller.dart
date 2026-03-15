import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/service/local_db.dart';
import 'package:suraj_approval/features/production/view/widgets/tabs/widgets/production_view.dart';

import '../../../core/constants/app_enum.dart';

class ProductionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static ProductionController get instance => Get.find();

  RxBool isLoading = false.obs;

  // ─── Outer Tab Controller (Production sub-menu tabs) ──────────────────────
  late TabController tabController;
  List<Tab> myTabs = [];
  List<Widget> tabViews = [];

  /// The currently active production sub-menu (e.g. hourlyProductionEntry)
  final Rx<SubMenuType> currentSubMenu = SubMenuType.hourlyProductionEntry.obs;

  @override
  void onInit() {
    super.onInit();
    final userModel = LocalDB.getUserModel();
    final subMenus = userModel?.getSubMenusFor(MenuType.production) ?? [];

    // Build one Tab per sub-menu the user has access to.
    for (var sm in subMenus) {
      myTabs.add(Tab(text: sm.key));
      tabViews.add(ProductionView(subMenuType: sm));
    }

    tabController = TabController(length: myTabs.length, vsync: this);

    if (subMenus.isNotEmpty) {
      currentSubMenu.value = subMenus.first;
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
