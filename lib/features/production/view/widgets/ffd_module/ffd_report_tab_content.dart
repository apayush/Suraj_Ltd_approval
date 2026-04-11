import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/core/widgets/loading_widget.dart';
import 'package:suraj_approval/core/widgets/no_data_found.dart';
import 'package:suraj_approval/core/widgets/sfdatagrid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:suraj_approval/features/production/controller/ffd_controller.dart';
import 'package:suraj_approval/features/production/model/ffd_report_data_source.dart';

class FFDReportTabContent extends StatelessWidget {
  final FFDController controller;
  final bool compact;

  const FFDReportTabContent({
    super.key,
    required this.controller,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Filter bar ────────────────────────────────────────────────────
        _buildFilterBar(context),
        // ── Report data grid ──────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: LoadingIndicator(),
                  ),
                );
              }
              if (controller.reportEntries.isEmpty) {
                return const NoDataFound();
              }
              return _buildReportCard(context);
            }),
          ),
        ),
      ],
    );
  }

  // ── Filter bar ────────────────────────────────────────────────────────────
  Widget _buildFilterBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          // Filter button shows current date range
          Flexible(
            child: Obx(() {
              final fmt = DateFormat('dd/MM/yy');
              final start = fmt.format(controller.reportStartDate.value);
              final end = fmt.format(controller.reportEndDate.value);
              return AppButton(
                text: '$start  →  $end',
                onPressed: () => _showFilterDialog(context),
                backgroundColor: AppColors.blue,
              );
            }),
          ),
          8.widthGap,
          // Refresh
          AppButton(
            text: 'Refresh',
            onPressed: () => controller.getReportData(),
            width: 90,
          ),
        ],
      ),
    );
  }

  // ── Report Card ───────────────────────────────────────────────────────────
  Widget _buildReportCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                const Text(
                  'FFD FORMING PRODUCTION REPORT',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() {
                  final fmt = DateFormat('dd MMM yyyy');
                  final start = fmt.format(controller.reportStartDate.value);
                  final end = fmt.format(controller.reportEndDate.value);
                  return Text(
                    '$start  –  $end',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.grey,
                    ),
                  );
                }),
              ],
            ),
          ),
          // Grid
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Obx(() {
              final dataSource = FFDReportDataSource(
                entries: controller.reportEntries,
                isDark: isDark,
              );

              return SfDataGridPaginationWithAllData<FFDController>(
                controller: controller,
                dynamicColumns: _buildGridColumns(),
                totalItems: controller.reportEntries.length,
                hidePaging: true,
                isScrollbarAlwaysShown: false,
                rowsPerPage: controller.reportEntries.length,
                onPageNavigationStart: (pageIndex) {},
                onPageNavigationEnd: (pageIndex) {},
                onRowsPerPageChanged: (value) {},
                source: dataSource,
                columnWidthMode: ColumnWidthMode.auto,
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Grid columns ──────────────────────────────────────────────────────────
  List<GridColumn> _buildGridColumns() {
    GridColumn col(String name, String label,
        {Alignment align = Alignment.center, double minWidth = 90}) {
      return GridColumn(
        columnName: name,
        minimumWidth: minWidth,
        columnWidthMode: ColumnWidthMode.fitByColumnName,
        label: appGridLabel(label, align: align),
      );
    }

    return [
      col('date', 'DATE', align: Alignment.centerLeft, minWidth: 110),
      col('elbow', 'ELBOW\nNOS'),
      col('elbowTotal', 'ELBOW\nTOTAL'),
      col('tee', 'TEE\nNOS'),
      col('teeTotal', 'TEE\nTOTAL'),
      col('reducer', 'REDUCER\nNOS'),
      col('reducerTotal', 'REDUCER\nTOTAL'),
      col('cap', 'CAP\nNOS'),
      col('capTotal', 'CAP\nTOTAL'),
    ];
  }

  // ── Filter Dialog ─────────────────────────────────────────────────────────
  void _showFilterDialog(BuildContext context) {
    DateTime tempStart = controller.reportStartDate.value;
    DateTime tempEnd = controller.reportEndDate.value;

    Get.dialog(
      StatefulBuilder(
        builder: (ctx, setState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;

          Future<void> pickDate({required bool isStart}) async {
            final picked = await showDatePicker(
              context: ctx,
              initialDate: isStart ? tempStart : tempEnd,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              setState(() {
                if (isStart) {
                  tempStart = picked;
                } else {
                  tempEnd = picked;
                }
              });
            }
          }

          Widget dateTile(String label, DateTime date, {required bool isStart}) {
            return InkWell(
              onTap: () => pickDate(isStart: isStart),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: AppColors.blue),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('dd MMM yyyy').format(date),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            title: const Text('Filter Report'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Start Date',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white70
                            : Colors.grey.shade700)),
                const SizedBox(height: 6),
                dateTile('Start Date', tempStart, isStart: true),
                const SizedBox(height: 16),
                Text('End Date',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white70
                            : Colors.grey.shade700)),
                const SizedBox(height: 6),
                dateTile('End Date', tempEnd, isStart: false),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white),
                onPressed: () {
                  controller.onReportStartDateChanged(tempStart);
                  controller.onReportEndDateChanged(tempEnd);
                  controller.getReportData();
                  Get.back();
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }
}
