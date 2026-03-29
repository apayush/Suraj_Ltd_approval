import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import '../../../controller/lg30_pilger_controller.dart';
import 'lg30_entry_tab_content.dart';
import 'lg30_report_tab_content.dart';

/// Embeds the LG30 Pilger module (Entry + Report inner tabs) inside the
/// Production screen.
///
/// [columns] controls the layout:
///   1 = mobile, 2 = tablet, 3 = web
class LG30PilgerTabView extends StatefulWidget {
  final int columns;

  const LG30PilgerTabView({super.key, this.columns = 1});

  @override
  State<LG30PilgerTabView> createState() => _LG30PilgerTabViewState();
}

class _LG30PilgerTabViewState extends State<LG30PilgerTabView> {
  late LG30PilgerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(LG30PilgerController(), tag: 'production_lg30');
  }

  @override
  void dispose() {
    Get.delete<LG30PilgerController>(tag: 'production_lg30');
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
                _controller.getReportData();
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
              LG30EntryTabContent(
                  controller: _controller, columns: widget.columns),
              LG30ReportTabContent(
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
