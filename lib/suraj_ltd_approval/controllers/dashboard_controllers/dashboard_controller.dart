import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../models/material_item_model.dart';
import '../../ui/utills/constants/app_routes.dart';
import '../../ui/utills/constants/app_strings.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static DashboardController get instance => Get.find();

  List<MaterialItem> appModules = [
    MaterialItem(
      AppStrings.dashboard,
      CupertinoIcons.plus_circle,
      route: AppRoutes.dashboardScreen,
    ),
    // MaterialItem(
    //   AppStrings.finance,
    //   CupertinoIcons.plus_circle,
    //   route: AppRoutes.expenseAdvanceAddScreen,
    // ),
    // MaterialItem(
    //   AppStrings.production,
    //   CupertinoIcons.plus_circle,
    //   route: AppRoutes.expenseAdvanceAddScreen,
    // ),
    // MaterialItem(
    //   AppStrings.purchase,
    //   CupertinoIcons.plus_circle,
    //   route: AppRoutes.expenseAdvanceAddScreen,
    // ),
    // MaterialItem(
    //   AppStrings.sales,
    //   CupertinoIcons.plus_circle,
    //   route: AppRoutes.expenseAdvanceAddScreen,
    // ),
  ];

  RxBool isLoading = false.obs;
}
