import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/finance_tabbar_view.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../controller/finance_controller.dart';


class FinanceWeb extends GetView<FinanceController> {
  FinanceWeb({super.key});


  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottom: TabBar(
        controller: controller.tabController,
        tabs: controller.myTabs,
        onTap: (index) {
          controller.getAllData();
        },
        tabAlignment: TabAlignment.start,
        isScrollable: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
        child: FinanceTabView(),
      ),
    );
  }
}