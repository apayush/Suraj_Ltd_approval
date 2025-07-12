import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';

import '../../../core/constants/app_enum.dart';
import '../../../core/models/user_model.dart';
import '../view/widgets/tabs/screens/bank_payment.dart';
import '../view/widgets/tabs/screens/bank_receipt.dart';
import '../view/widgets/tabs/screens/cash_payment.dart';
//
// class FinanceController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   static FinanceController get instance => Get.find();
//
//   RxBool isLoading = false.obs;
//
//   late TabController tabController;
//   final List<Tab> myTabs = const <Tab>[
//     Tab(text: 'Bank Payment'),
//     Tab(text: 'Bank Receipt'),
//     Tab(text: 'Cash Payment'),
//     Tab(text: 'Cash Receipt'),
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//     tabController = TabController(vsync: this, length: myTabs.length);
//   }
// }

class FinanceController extends GetxController with GetTickerProviderStateMixin {
  static FinanceController get instance => Get.find();

  RxBool isLoading = false.obs;

  late TabController tabController;
  List<Tab> myTabs = [];
  List<Widget> tabViews = [];

  final UserModel userModel = Get.find<UserModel>();

  @override
  void onInit() {
    super.onInit();

    final subMenus = userModel.getSubMenusFor(MenuType.finance);

    final tabs = <Tab>[];
    final views = <Widget>[];

    if (subMenus.contains(SubMenuType.bankPayment)) {
      tabs.add(const Tab(text: 'Bank Payment'));
      views.add(BankPayment());
    }

    if (subMenus.contains(SubMenuType.bankReceipt)) {
      tabs.add(const Tab(text: 'Bank Receipt'));
      views.add(BankReceipt()); // Replace with real widget
    }

    if (subMenus.contains(SubMenuType.cashPayment)) {
      tabs.add(const Tab(text: 'Cash Payment'));
      views.add(CashPayment()); // Replace with real widget
    }

    if (subMenus.contains(SubMenuType.cashReceipt)) {
      tabs.add(const Tab(text: 'Cash Receipt'));
      views.add(CashPayment()); // Replace with real widget
    }

    myTabs = tabs;
    tabViews = views;
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
