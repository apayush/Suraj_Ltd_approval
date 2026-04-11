import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/features/production/controller/ffd_controller.dart';
import 'ffd_entry_tab_content.dart';
import 'ffd_report_tab_content.dart';

/// Outer shell for the FFD Forming Production module.
/// Embeds two inner tabs: Data Entry and View Report.
///
/// [columns] controls form layout:
///   1 = mobile  |  2 = tablet  |  3 = web
class FFDTabView extends StatefulWidget {
  final int columns;
  const FFDTabView({super.key, this.columns = 1});

  @override
  State<FFDTabView> createState() => _FFDTabViewState();
}

class _FFDTabViewState extends State<FFDTabView> {
  late FFDController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(FFDController(), tag: 'production_ffd');
  }

  @override
  void dispose() {
    Get.delete<FFDController>(tag: 'production_ffd');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // ── Inner TabBar ──────────────────────────────────────────────────
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
            tabs: const [
              Tab(text: 'Data Entry'),
              Tab(text: 'View Report'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller.tabController,
            children: [
              FFDEntryTabContent(
                controller: _controller,
                columns: widget.columns,
              ),
              FFDReportTabContent(
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
