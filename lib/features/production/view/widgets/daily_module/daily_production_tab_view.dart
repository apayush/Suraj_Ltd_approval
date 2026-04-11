import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';

import '../../../controller/daily_production_controller.dart';
import 'entry_tab_content.dart';
import 'report_tab_content.dart';

class DailyProductionTabView extends StatefulWidget {
  final int columns;

  const DailyProductionTabView({super.key, this.columns = 1});

  @override
  State<DailyProductionTabView> createState() => _DailyProductionTabViewState();
}

class _DailyProductionTabViewState extends State<DailyProductionTabView> {
  late DailyProductionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(DailyProductionController(), tag: 'production_daily');
  }

  @override
  void dispose() {
    Get.delete<DailyProductionController>(tag: 'production_daily');
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
                compact: widget.columns == 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
