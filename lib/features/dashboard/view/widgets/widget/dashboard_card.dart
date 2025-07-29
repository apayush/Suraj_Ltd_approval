import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/models/dashboard_model.dart';
import '../../../../../core/utills/app_module_container.dart';
import '../../../../../core/widgets/common_widgets.dart';


class DashboardCard extends StatelessWidget {
  final DashboardModel model;

  const DashboardCard({required this.model});

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
              model.displayPeriod,
              style: TextStyles.large(context),
              alignment: Alignment.center,
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
            AppText(
              '$count',
              style: TextStyles.large(Get.context!).copyWith(color: color),
              alignment: Alignment.center,
              softWrap: true,
            ),
            AppText(
              label,
              style: TextStyles.large(Get.context!).copyWith(color: color),
              alignment: Alignment.center,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
