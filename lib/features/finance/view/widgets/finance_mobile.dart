import 'package:flutter/material.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/finance_tabbar_view.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../controller/finance_controller.dart';

class FinanceMobile extends StatelessWidget {
  FinanceMobile({super.key});

  final controller = FinanceController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text('  Finance Module', style: TextStyles.heading1(context)),
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
