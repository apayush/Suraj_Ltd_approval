import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/features/dashboard/view/widgets/widget/dashboard_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../features/dashboard/controller/dashboard_controller.dart';

class DashboardWeb extends StatelessWidget {
  DashboardWeb({super.key});

  final controller = DashboardController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppText('Dashboard', style: TextStyles.extraLarge(context)),
      body:  Obx(() {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.dashboardData.length,
          itemBuilder: (context, index) {
            final item = controller.dashboardData[index];
            return DashboardCard(model: item);
          },
        );
      }),
    );
  }
}
