import 'package:flutter/material.dart';
import 'package:suraj_approval/features/production/controller/hourly_report_controller.dart';
import 'hourly_report_widgets.dart';

/// Shared report view content — used by mobile, tablet, web layouts.
/// [compact] = true on mobile → filter shows as dialog
/// [compact] = false on web/tablet → filter shows inline bar
class ReportTabContent extends StatelessWidget {
  final HourlyReportController controller;
  final bool compact;

  const ReportTabContent({
    super.key,
    required this.controller,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter bar sits at top (web: inline bar, mobile: icon button row)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: ReportFilterBar(
            controller: controller,
            compact: compact,
          ),
        ),
        // Scrollable report content below
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ReportTable(controller: controller),
                const SizedBox(height: 24),
                const SignatureRow(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
