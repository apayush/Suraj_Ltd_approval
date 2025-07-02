import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinanceController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static FinanceController get instance => Get.find();

  RxBool isLoading = false.obs;

  late TabController tabController;
  final List<Tab> myTabs = const <Tab>[
    Tab(text: 'Bank Payment'),
    Tab(text: 'Bank Receipt'),
    Tab(text: 'Cash Payment'),
    Tab(text: 'Cash Receipt'),
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: myTabs.length);
  }
}
