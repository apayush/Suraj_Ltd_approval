import 'package:flutter/material.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/features/hourly/view/report_tab_content.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../controller/hourly_report_controller.dart';
import '../entry_tab_content.dart';

class HourlyReportMobile extends StatelessWidget {
  HourlyReportMobile({super.key});

  final controller = HourlyReportController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: const Text('Hourly Report', style: TextStyle(color: Colors.white)),
      bottom: TabBar(
        controller: controller.tabController,
        indicatorColor: AppColors.blue,
        indicatorWeight: 3,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_circle_outline, size: 16),
                SizedBox(width: 6),
                Text('Data Entry'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.table_chart_outlined, size: 16),
                SizedBox(width: 6),
                Text('View Report'),
              ],
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          EntryTabContent(controller: controller, columns: 1),
          ReportTabContent(controller: controller),
        ],
      ),
    );
  }
}
