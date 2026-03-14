import 'package:flutter/material.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/features/hourly/view/report_tab_content.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../controller/hourly_report_controller.dart';
import '../entry_tab_content.dart';

class HourlyReportWeb extends StatelessWidget {
  HourlyReportWeb({super.key});

  final controller = HourlyReportController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Row(
        children: const [
          Icon(Icons.factory_outlined, color: Colors.white70, size: 20),
          SizedBox(width: 10),
          Text('Hourly Production Report', style: TextStyle(color: Colors.white)),
        ],
      ),
      bottom: TabBar(
        controller: controller.tabController,
        indicatorColor: AppColors.blue,
        indicatorWeight: 3,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: AppColors.blue,
        unselectedLabelColor: Colors.white54,
        tabs: const [
          Tab(text: 'Data Entry'),
          Tab(text: 'View Reports'),
        ],
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          _WebConstrainedContent(
            child: EntryTabContent(controller: controller, columns: 3),
          ),
          _WebConstrainedContent(
            child: ReportTabContent(controller: controller),
            maxWidth: 1200,
          ),
        ],
      ),
    );
  }
}

class _WebConstrainedContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const _WebConstrainedContent({required this.child, this.maxWidth = 900});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
