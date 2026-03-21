import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/features/production/controller/daywise_report_controller.dart';
import 'entry_tab_content.dart';
import 'report_tab_content.dart';

class DaywiseTabView extends StatefulWidget {
  final int columns;

  const DaywiseTabView({super.key, this.columns = 1});

  @override
  State<DaywiseTabView> createState() => _DaywiseTabViewState();
}

class _DaywiseTabViewState extends State<DaywiseTabView> {
  late DaywiseProductionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(DaywiseProductionController(), tag: 'production_daywise');
  }

  @override
  void dispose() {
    Get.delete<DaywiseProductionController>(tag: 'production_daywise');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // ── Inner TabBar: Data Entry | View Report ───────────────────────────
        Material(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          elevation: 1,
          child: TabBar(
            controller: _controller.tabController,
            indicatorColor: AppColors.blue,
            indicatorWeight: 3,
            onTap: (value) {
              if (value == 1) {
                _controller.getDaywiseReportData();
              }
            },
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.zero,
            unselectedLabelColor: isDark ? Colors.white54 : Colors.grey,
            tabs: const [Tab(text: "Data Entry"), Tab(text: "View Report")],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller.tabController,
            children: [
              DaywiseEntryTabContent(controller: _controller, columns: widget.columns),
              DaywiseReportTabContent(
                controller: _controller,
                compact: widget.columns == 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
