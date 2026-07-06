import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/core/widgets/loading_widget.dart';
import 'package:suraj_approval/core/widgets/no_data_found.dart';
import 'package:suraj_approval/core/widgets/app_dialog.dart';
import 'package:suraj_approval/core/widgets/sfdatagrid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../controller/lg30_pilger_controller.dart';
import 'package:suraj_approval/features/production/model/lg30_report_data_source.dart';
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
        // Filter bar앉
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
    if (compact) {
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
                  text: 'Filter • $dept • $date',
                  onPressed: () => _showFilterDialog(context),
                  backgroundColor: AppColors.blue,
                ),
              );
            }),
            const Spacer(),
            AppButton(
              text: 'Print',
              onPressed: () => controller.printReport(),
            ),
          ],
        ),
      );
    } else {
      // Desktop / Tablet Inline
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Department', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Obx(() {
                    final dummy = DropDownResponse(value: '', text: 'Select Department');
                    final matchingItem = controller.deptDropdownList.firstWhere(
                      (item) => item.value == controller.reportDeptFilter.value,
                      orElse: () => controller.deptDropdownList.isNotEmpty ? controller.deptDropdownList.first : dummy,
                    );
                    return CustomDropdownSingle(
                      width: double.infinity,
                      hintText: 'Select Department',
                      selectedItem: matchingItem.value == '' ? null : matchingItem,
                      items: controller.deptDropdownList,
                      onChanged: (v) {
                        if (v?.value != null) {
                          controller.reportDeptFilter.value = v!.value!;
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(() => DatePickerField(
                    label: 'Date',
                    date: controller.reportDate.value,
                    onChanged: (d) {
                      controller.reportDate.value = d;
                    },
                  )),
            ),
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  AppButton(
                    text: 'Search',
                    onPressed: () => controller.getReportData(),
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
        ),
      );
    }
  }

  Widget _buildReportTable(BuildContext context) {
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                Obx(() => Text(
                      '${controller.reportDeptFilter.value.toUpperCase()} REPORT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    )),
                const SizedBox(height: 4),
                Obx(() => Text(
                      'Date: ${DateFormat('dd MMM yyyy').format(controller.reportDate.value)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.grey,
                      ),
                    )),
              ],
            ),
          ),
          // Grid
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Obx(() {
              final dataSource = LG30ReportDataSource(
                entries: controller.reportEntries,
                isDark: isDark,
              );
              
              final gridWidthMode = compact ? ColumnWidthMode.auto : ColumnWidthMode.fill;

              return SfDataGridPaginationWithAllData<LG30PilgerController>(
                controller: controller,
                dynamicColumns: _buildGridColumns(gridWidthMode),
                totalItems: controller.reportEntries.length,
                hidePaging: true,
                isScrollbarAlwaysShown: false,
                rowsPerPage: controller.reportEntries.length,
                onPageNavigationStart: (pageIndex) {},
                onPageNavigationEnd: (pageIndex) {},
                onRowsPerPageChanged: (value) {},
                source: dataSource,
                columnWidthMode: gridWidthMode,
              );
            }),
          ),
        ],
      ),
    );
  }

  List<GridColumn> _buildGridColumns(ColumnWidthMode mode) {
    GridColumn textColumn(String name, String label, {Alignment align = Alignment.centerLeft}) {
      return GridColumn(
        columnName: name,
        columnWidthMode: mode,
        minimumWidth: 100,
        label: appGridLabel(
          label,
          align: align,
        ),
      );
    }

    return [
      textColumn('dept', 'DEPARTMENT'),
      textColumn('machine', 'MACHINE NAME'),
      textColumn('date', 'DATE'),
      textColumn('shift', 'SHIFT'),
      textColumn('nos', 'NOS', align: Alignment.centerRight),
      textColumn('kgs', 'KGS', align: Alignment.centerRight),
      textColumn('mtr', 'MTR', align: Alignment.centerRight),
      textColumn('maint', 'MAINT.'),
      textColumn('rm', 'NO RM'),
      textColumn('man', 'MANPOWER'),
      textColumn('other', 'OTHER'),
      textColumn('createdBy', 'CREATED BY'),
    ];
  }

  void _showFilterDialog(BuildContext context) {
    DateTime tempDate = controller.reportDate.value;
    String tempDept = controller.reportDeptFilter.value;

    Get.dialog(
      StatefulBuilder(
        builder: (ctx, setState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;

          final dummy = DropDownResponse(value: '', text: 'Select Department');
          final matchingDDLValue = controller.deptDropdownList.firstWhere(
            (t) => t.value == tempDept,
            orElse: () => controller.deptDropdownList.isNotEmpty ? controller.deptDropdownList.first : dummy,
          );

          return GenericDialogBox(
            headerText: 'Filters',
            primaryButtonText: 'Apply',
            secondaryButtonText: 'Cancel',
            onPrimaryButtonPressed: () {
              controller.reportDate.value = tempDate;
              controller.reportDeptFilter.value = tempDept;
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
                // Date
                Text(
                  'Filter Date',
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
                      initialDate: tempDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setState(() => tempDate = picked);
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
                        const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.blue),
                        const SizedBox(width: 8),
                        Text(DateFormat('dd MMM yyyy').format(tempDate), style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Department
                Text(
                  'Department',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 6),
                CustomDropdownSingle(
                  width: double.infinity,
                  hintText: 'Select Department',
                  selectedItem: matchingDDLValue.value == '' ? null : matchingDDLValue,
                  items: controller.deptDropdownList,
                  onChanged: (v) {
                    if (v != null && v.value != null) {
                      setState(() => tempDept = v.value!);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TotalChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _TotalChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
