import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/core/widgets/loading_widget.dart';
import 'package:suraj_approval/core/widgets/no_data_found.dart';
import '../../../controller/lg30_pilger_controller.dart';
import '../hourly_module/hourly_report_widgets.dart';

class LG30ReportTabContent extends StatelessWidget {
  final LG30PilgerController controller;
  final bool compact;

  const LG30ReportTabContent({
    super.key,
    required this.controller,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter bar
        _buildFilterBar(context),
        // Report table
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: LoadingIndicator(),
                ));
              }
              if (controller.reportEntries.isEmpty) {
                return const NoDataFound();
              }
              return _buildReportTable(context);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Obx(() {
            final dept = controller.reportDeptFilter.value;
            final date =
                DateFormat('dd/MM/yy').format(controller.reportDate.value);
            return Flexible(
              child: AppButton(
                text: '$dept • $date',
                onPressed: () => _showFilterDialog(context),
                backgroundColor: AppColors.blue,
              ),
            );
          }),
          const Spacer(),
          // Refresh/Show Report button
          AppButton(
            text: 'Show Report',
            onPressed: controller.getReportData,
            width: compact ? 110 : 120,
          ),
          8.widthGap,
          // Print button
          AppButton(
            text: 'Print',
            onPressed: () => controller.printReport(),
            width: 80,
          ),
        ],
      ),
    );
  }

  Widget _buildReportTable(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: isDark ? Colors.grey.shade900 : Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            height: 3,
            decoration: const BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Obx(() => Text(
                      '${controller.reportDeptFilter.value} — ${DateFormat('dd MMM yyyy').format(controller.reportDate.value)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    )),
                12.heightGap,
                // Table
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(() => DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          const Color(0xFFCFE2FF),
                        ),
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                        dataTextStyle: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        border: TableBorder.all(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        columns: const [
                          DataColumn(label: Text('MACHINE NAME')),
                          DataColumn(label: Text('NOS'), numeric: true),
                          DataColumn(label: Text('KGS'), numeric: true),
                          DataColumn(label: Text('MAINT.')),
                          DataColumn(label: Text('NO RM')),
                          DataColumn(label: Text('MANPOWER')),
                          DataColumn(label: Text('OTHER')),
                        ],
                        rows: [
                          // Data rows
                          ...controller.reportEntries.map((entry) {
                            return DataRow(cells: [
                              DataCell(Text(entry.machineName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))),
                              DataCell(Text(
                                  entry.nos == 0 ? '-' : '${entry.nos}')),
                              DataCell(Text(entry.kgs == 0
                                  ? '-'
                                  : entry.kgs.toStringAsFixed(1))),
                              DataCell(Text(entry.maint)),
                              DataCell(Text(entry.rm)),
                              DataCell(Text(entry.man)),
                              DataCell(Text(entry.other)),
                            ]);
                          }),
                          // Total row
                          DataRow(
                            color: WidgetStateProperty.all(AppColors.blue),
                            cells: [
                              const DataCell(Text('TOTAL',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                              DataCell(Text(
                                  '${controller.totalReportNos.value}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                              DataCell(Text(
                                  controller.totalReportKgs.value
                                      .toStringAsFixed(1),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                              const DataCell(Text('')),
                              const DataCell(Text('')),
                              const DataCell(Text('')),
                              const DataCell(Text('')),
                            ],
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _LG30FilterDialog(controller: controller),
    );
  }
}

// ── Filter Dialog ─────────────────────────────────────────────────────────────

class _LG30FilterDialog extends StatelessWidget {
  final LG30PilgerController controller;
  const _LG30FilterDialog({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.filter_list, color: AppColors.blue, size: 20),
          8.widthGap,
          const Text('Filter Report',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('Department',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600)),
          8.heightGap,
          Obx(() {
            final dummy =
                DropDownResponse(value: '', text: 'Select Department');
            final matchingItem = controller.deptDropdownList.firstWhere(
              (item) => item.value == controller.reportDeptFilter.value,
              orElse: () => controller.deptDropdownList.isNotEmpty
                  ? controller.deptDropdownList.first
                  : dummy,
            );
            return CustomDropdownSingle(
              width: double.infinity,
              hintText: 'Select Department',
              selectedItem: matchingItem.value == '' ? null : matchingItem,
              items: controller.deptDropdownList,
              onChanged: (v) {
                if (v?.value != null) {
                  controller.onReportDeptFilterChanged(v!.value!);
                }
              },
            );
          }),
          16.heightGap,
          Obx(() => DatePickerField(
                label: 'Date',
                date: controller.reportDate.value,
                onChanged: controller.onReportDateChanged,
              )),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue),
          onPressed: () {
            Navigator.of(context).pop();
            controller.getReportData();
          },
          child:
              const Text('Apply', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
