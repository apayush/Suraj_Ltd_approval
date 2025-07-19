import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/finance_tabbar_view.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../controller/finance_controller.dart';

class FinanceMobile extends GetView<FinanceController> {
  FinanceMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text('Finance'),
      bottom: TabBar(
        controller: controller.tabController,
        tabs: controller.myTabs,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: FinanceTabView(),
      ),
    );
  }
}
