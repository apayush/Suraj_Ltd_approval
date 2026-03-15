import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';

import '../../../controller/hourly_report_controller.dart';
import 'entry_tab_content.dart';
import 'report_tab_content.dart';

/// Embeds the Hourly Report module (Entry + Report inner tabs) inside the
/// Production screen — no separate route needed.
///
/// [columns] controls the entry form field layout:
///   1 = mobile (one field per row)
///   2 = tablet (two fields per row)
///   3 = web   (three fields per row)
class HourlyTabView extends StatefulWidget {
  final int columns;

  const HourlyTabView({super.key, this.columns = 1});

  @override
  State<HourlyTabView> createState() => _HourlyTabViewState();
}

class _HourlyTabViewState extends State<HourlyTabView> {
  late HourlyReportController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(HourlyReportController(), tag: 'production_hourly');
  }

  @override
  void dispose() {
    Get.delete<HourlyReportController>(tag: 'production_hourly');
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
              if(value == 1) {
                _controller.getHourlyReportData();
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
              EntryTabContent(controller: _controller, columns: widget.columns),
              ReportTabContent(
                controller: _controller,
                compact: widget.columns == 1, // mobile = compact (dialog)
              ),
            ],
          ),
        ),
      ],
    );
  }
}
