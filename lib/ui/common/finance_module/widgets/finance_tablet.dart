import 'package:flutter/material.dart';
import 'package:suraj_approval/ui/common/finance_module/widgets/view/finance_tabbar_view.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../features/finance/controller/finance_controller.dart';

class FinanceTablet extends StatelessWidget {
  FinanceTablet({super.key});

  final controller = FinanceController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottom: TabBar(
        controller: controller.tabController,
        tabs: controller.myTabs,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
        child: FinanceTabView(controller: controller),
      ),
    );
  }
}