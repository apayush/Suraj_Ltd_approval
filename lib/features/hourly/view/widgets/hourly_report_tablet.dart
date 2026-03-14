import 'package:flutter/material.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../controller/hourly_report_controller.dart';
import '../entry_tab_content.dart';
import '../report_tab_content.dart';

class HourlyReportTablet extends StatelessWidget {
  HourlyReportTablet({super.key});

  final controller = HourlyReportController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: const Text('Hourly Production Report', style: TextStyle(color: Colors.white)),
      bottom: TabBar(
        controller: controller.tabController,
        indicatorColor: AppColors.blue,
        indicatorWeight: 3,
        isScrollable: false,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_circle_outline, size: 18),
                SizedBox(width: 8),
                Text('Data Entry', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.table_chart_outlined, size: 18),
                SizedBox(width: 8),
                Text('View Report', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          // Tablet uses 2-column layout for the form
          EntryTabContent(controller: controller, columns: 2),
          ReportTabContent(controller: controller),
        ],
      ),
    );
  }
}
