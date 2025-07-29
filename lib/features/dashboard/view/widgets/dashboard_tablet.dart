import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/features/dashboard/view/widgets/widget/dashboard_card.dart';
import '../../../../core/models/dashboard_model.dart';
import '../../../../core/utills/app_module_container.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../controller/dashboard_controller.dart';

class DashboardTablet extends StatelessWidget {
  DashboardTablet({super.key});

  final controller = DashboardController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppText('Dashboard', style: TextStyles.extraLarge(context)),
      body:  Obx(() {
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: controller.dashboardData.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final item = controller.dashboardData[index];
            return DashboardCard(model: item);
          },
        );
      }),
    );
  }
}

