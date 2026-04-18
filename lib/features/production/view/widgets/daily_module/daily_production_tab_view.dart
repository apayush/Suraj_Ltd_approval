import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/widgets/custom_tab_bar.dart';
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
    return Column(
      children: [
        const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
        // ── Inner CustomTabBar: Data Entry | View Report ─────────────────────
        CustomTabBar(
          tabs: const ['Data Entry', 'View Report'],
          selectedIndex: _controller.selectedInnerTab,
          onTap: (i) => _controller.selectedInnerTab.value = i,
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
        // ── Content ──────────────────────────────────────────────────────────
        Expanded(
          child: Obx(
            () =>
                _controller.selectedInnerTab.value == 0
                    ? EntryTabContent(
                      controller: _controller,
                      columns: widget.columns,
                    )
                    : ReportTabContent(
                      controller: _controller,
                      compact: widget.columns == 1,
                    ),
          ),
        ),
      ],
    );
  }
}
