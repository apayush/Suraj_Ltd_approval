import 'package:flutter/material.dart';
import 'package:suraj_approval/ui/common/finance_module/widgets/view/finance_tabbar_view.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../feature/controller/finance_controllers/finance_controller.dart';

class FinanceMobile extends StatelessWidget {
  FinanceMobile({super.key});

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
      body: FinanceTabView(controller: controller),
    );
  }
}
