import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/widgets/custom_tab_bar.dart';
import '../../../controller/lg30_pilger_controller.dart';
import 'lg30_entry_tab_content.dart';
import 'lg30_report_tab_content.dart';

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
    return Column(
      children: [
        const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
        // ── Inner CustomTabBar: Data Entry | View Report ─────────────────────
        CustomTabBar(
          tabs: const ['Data Entry', 'View Report'],
          selectedIndex: _controller.selectedInnerTab,
          onTap: (i) {
            _controller.selectedInnerTab.value = i;
            if (i == 1) _controller.getReportData();
          },
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
        // ── Content ──────────────────────────────────────────────────────────
        Expanded(
          child: Obx(
            () =>
                _controller.selectedInnerTab.value == 0
                    ? LG30EntryTabContent(
                      controller: _controller,
                      columns: widget.columns,
                    )
                    : LG30ReportTabContent(
                      controller: _controller,
                      compact: widget.columns == 1,
                    ),
          ),
        ),
      ],
    );
  }
}
