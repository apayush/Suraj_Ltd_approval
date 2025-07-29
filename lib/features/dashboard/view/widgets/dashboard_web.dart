import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import '../../../../core/models/dashboard_model.dart';
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
            return _DashboardCard(model: item);
          },
        );
      }),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final DashboardModel model;

  const _DashboardCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              model.period,
              style: TextStyles.large(context),
              alignment: Alignment.center,
              // style: const TextStyle(
              //   fontSize: 16,
              //   fontWeight: FontWeight.bold,
              //   color: Color(0xFF00457A),
              // ),
            ),
            Divider(height: 10,thickness: 2.0,),
            Row(
              children: [
                _countBox(color: Colors.green, label: 'Approved', count: model.approveCount),
                const SizedBox(width: 8),
                _countBox(color: Colors.red, label: 'Rejected', count: model.rejectCount),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _countBox({required Color color, required String label, required int count}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
