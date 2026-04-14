import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/core/widgets/app_dialog.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/core/widgets/sfdatagrid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controller/daily_production_controller.dart';
import '../../../model/daily_production_data_source.dart';
import '../hourly_module/hourly_report_widgets.dart'; // Using DatePickerField

class ReportTabContent extends StatelessWidget {
  final DailyProductionController controller;
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
        // Filter bar sits at top
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: _DailyReportFilterBar(
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
                _DailyReportTable(controller: controller, compact: compact),
                const SizedBox(height: 24),
                // Reusing signature row from hourly widgets if applicable, otherwise simple spacer
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

class _DailyReportFilterBar extends StatelessWidget {
  final DailyProductionController controller;
  final bool compact;

  const _DailyReportFilterBar({
    required this.controller,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Row(
          children: [
            Obx(() {
              final start = controller.filterStartDate.value;
              final end = controller.filterEndDate.value;
              String dateStr = 'All Dates';
              if (start != null && end != null) {
                dateStr = '${DateFormat('dd/MM').format(start)} - ${DateFormat('dd/MM').format(end)}';
              } else if (start != null) {
                dateStr = 'From ${DateFormat('dd/MM').format(start)}';
              } else if (end != null) {
                dateStr = 'Until ${DateFormat('dd/MM').format(end)}';
              }
              return Flexible(
                child: AppButton(
                  text: 'Filter • $dateStr',
                  onPressed: () => _showFilterDialog(context),
                  backgroundColor: AppColors.blue,
                ),
              );
            }),
            10.widthGap,
            AppButton(
              text: 'Print',
              onPressed: () => controller.printReport(),
            ),
          ],
        ),
      );
    } else {
      // Desktop / Tablet Inline
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Obx(() => DatePickerField(
              label: 'Start Date',
              date: controller.filterStartDate.value ?? DateTime.now(),
              onChanged: controller.onFilterStartDateChanged,
            )),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Obx(() => DatePickerField(
              label: 'End Date',
              date: controller.filterEndDate.value ?? DateTime.now(),
              onChanged: controller.onFilterEndDateChanged,
            )),
          ),
          const SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              children: [
                AppButton(
                  text: 'Search',
                  onPressed: controller.getReportData,
                  backgroundColor: AppColors.blue,
                ),
                const SizedBox(width: 8),
                AppButton(
                  text: 'Print',
                  onPressed: () => controller.printReport(),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  void _showFilterDialog(BuildContext context) {
    DateTime? tempStart = controller.filterStartDate.value;
    DateTime? tempEnd = controller.filterEndDate.value;

    Get.dialog(
      StatefulBuilder(
        builder: (ctx, setState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;

          return GenericDialogBox(
            headerText: 'Filters',
            primaryButtonText: 'Apply',
            secondaryButtonText: 'Cancel',
            onPrimaryButtonPressed: () {
              controller.filterStartDate.value = tempStart;
              controller.filterEndDate.value = tempEnd;
              controller.getReportData();
              Get.back();
            },
            onSecondaryButtonPressed: () {
              Get.back();
            },
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Pickers simplified
                _buildDialogDate(
                  ctx,
                  label: 'Start Date',
                  date: tempStart,
                  isDark: isDark,
                  onChanged: (d) => setState(() => tempStart = d),
                ),
                const SizedBox(height: 16),
                _buildDialogDate(
                  ctx,
                  label: 'End Date',
                  date: tempEnd,
                  isDark: isDark,
                  onChanged: (d) => setState(() => tempEnd = d),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDialogDate(BuildContext ctx, {required String label, required DateTime? date, required bool isDark, required Function(DateTime) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: ctx,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) onChanged(picked);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  date != null ? DateFormat('dd MMM yyyy').format(date) : 'Select Date',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyReportTable extends StatelessWidget {
  final DailyProductionController controller;
  final bool compact;

  const _DailyReportTable({required this.controller, required this.compact});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Report Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                Text(
                  'DAILY PRODUCTION REPORT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() {
                  final start = controller.filterStartDate.value;
                  final end = controller.filterEndDate.value;
                  String dateRange = 'All Dates';
                  if (start != null && end != null) {
                    dateRange = '${DateFormat('dd MMM').format(start)} to ${DateFormat('dd MMM yyyy').format(end)}';
                  } else if (start != null || end != null) {
                    dateRange = DateFormat('dd MMM yyyy').format(start ?? end!);
                  }
                  return Text(
                    'Dates: $dateRange',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white54 : Colors.grey,
                    ),
                  );
                }),
              ],
            ),
          ),
          
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Obx(() {
              final rows = controller.filteredEntries;
              if (rows.isEmpty) {
                return const Center(child: Text("No data found. Please add entries."));
              }
              final dataSource = DailyProductionDataSource(
                entries: rows,
                isDark: isDark,
              );

              final gridWidthMode = compact ? ColumnWidthMode.auto : ColumnWidthMode.fill;

              return SfDataGridPaginationWithAllData<DailyProductionController>(
                controller: controller,
                onPageNavigationStart: (pageIndex) {},
                onPageNavigationEnd: (pageIndex) {},
                onRowsPerPageChanged: (value) {},
                source: dataSource,
                dynamicColumns: _buildGridColumns(gridWidthMode),
                totalItems: rows.length,
                hidePaging: true,
                isScrollbarAlwaysShown: false,
                columnWidthMode: gridWidthMode,
                tableSummaryRows: [
                  GridTableSummaryRow(
                    showSummaryInRow: false,
                    title: 'Total',
                    columns: [
                      const GridSummaryColumn(
                        name: 'cuttingSummary',
                        columnName: 'cutting',
                        summaryType: GridSummaryType.sum,
                      ),
                      const GridSummaryColumn(
                        name: 'formingSummary',
                        columnName: 'forming',
                        summaryType: GridSummaryType.sum,
                      ),
                      const GridSummaryColumn(
                        name: 'bevellingSummary',
                        columnName: 'bevelling',
                        summaryType: GridSummaryType.sum,
                      ),
                      const GridSummaryColumn(
                        name: 'totalSummary',
                        columnName: 'total',
                        summaryType: GridSummaryType.sum,
                      ),
                    ],
                    position: GridTableSummaryRowPosition.bottom,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  List<GridColumn> _buildGridColumns(ColumnWidthMode mode) {
    return [
      GridColumn(
        columnName: 'date',
        label: appGridLabel('DATE',),
        columnWidthMode: mode
      ),
      GridColumn(
        columnName: 'cutting',
        label: appGridLabel('CUTTING QTY NOS.',),
        columnWidthMode: mode,
      ),
      GridColumn(
        columnName: 'forming',
        label: appGridLabel('FORMING QTY NOS.',),
        columnWidthMode: mode,
      ),
      GridColumn(
        columnName: 'bevelling',
        label: appGridLabel('BEVELLING QTY NOS.'),
        columnWidthMode: mode,
      ),
      GridColumn(
        columnName: 'total',
        label: appGridLabel('TOTAL QTY NOS.',),
        columnWidthMode: mode,
      ),
    ];
  }
}
