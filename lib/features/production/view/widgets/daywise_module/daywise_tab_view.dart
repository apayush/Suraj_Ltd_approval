import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/widgets/custom_tab_bar.dart';
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
    _controller = Get.put(
      DaywiseProductionController(),
      tag: 'production_daywise',
    );
  }

  @override
  void dispose() {
    Get.delete<DaywiseProductionController>(tag: 'production_daywise');
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
          onTap: (i) {
            _controller.selectedInnerTab.value = i;
            if (i == 1) _controller.getDaywiseReportData();
          },
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
        // ── Content ──────────────────────────────────────────────────────────
        Expanded(
          child: Obx(
            () =>
                _controller.selectedInnerTab.value == 0
                    ? DaywiseEntryTabContent(
                      controller: _controller,
                      columns: widget.columns,
                    )
                    : DaywiseReportTabContent(
                      controller: _controller,
                      compact: widget.columns == 1,
                    ),
          ),
        ),
      ],
    );
  }
}
