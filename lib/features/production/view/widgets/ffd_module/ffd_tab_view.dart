import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/widgets/custom_tab_bar.dart';
import 'package:suraj_approval/features/production/controller/ffd_controller.dart';
import 'ffd_entry_tab_content.dart';
import 'ffd_report_tab_content.dart';

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
                    ? FFDEntryTabContent(
                      controller: _controller,
                      columns: widget.columns,
                    )
                    : FFDReportTabContent(
                      controller: _controller,
                      compact: widget.columns == 1,
                    ),
          ),
        ),
      ],
    );
  }
}
