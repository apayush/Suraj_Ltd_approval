import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/features/production/controller/daywise_report_controller.dart';
import 'package:suraj_approval/features/production/model/daywise_report_model.dart';
import '../hourly_module/hourly_report_widgets.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';
import 'package:suraj_approval/core/widgets/app_dialog.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';

import 'package:suraj_approval/core/widgets/loading_widget.dart';
import 'package:suraj_approval/features/production/model/daywise_report_data_source.dart';
import 'package:suraj_approval/core/widgets/sfdatagrid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DaywiseReportTable extends StatelessWidget {
  final List<DaywiseEntry> entries;
  final bool isFullType;
  final DaywiseProductionController controller;
  final bool compact;

  const DaywiseReportTable({
    super.key,
    required this.entries,
    required this.isFullType,
    required this.controller,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dataSource = DaywiseReportDataSource(
      entries: entries,
      isFullType: isFullType,
      isDark: isDark,
    );

    final gridWidthMode = compact ? ColumnWidthMode.auto : ColumnWidthMode.fill;

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
                  '${controller.reportDeptFilter.value.toUpperCase()} REPORT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'From: ${DateFormat('dd MMM').format(controller.startDate.value)} To: ${DateFormat('dd MMM yyyy').format(controller.endDate.value)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: SfDataGridPaginationWithAllData<DaywiseProductionController>(
              controller: controller,
              dynamicColumns: _buildGridColumns(isFullType, gridWidthMode),
              totalItems: entries.length,
              hidePaging: true,
              isScrollbarAlwaysShown: false,
              rowsPerPage: entries.isEmpty ? 10 : entries.length,
              onPageNavigationStart: (pageIndex) {},
              onPageNavigationEnd: (pageIndex) {},
              onRowsPerPageChanged: (value) {},
              source: dataSource,
              columnWidthMode: gridWidthMode,
            ),
          ),
        ],
      ),
    );
  }

  List<GridColumn> _buildGridColumns(bool isFullType, ColumnWidthMode mode) {
    GridColumn textColumn(String name, String label, {bool isNumeric = false}) {
      return GridColumn(
        columnName: name,
        minimumWidth: 100,
        columnWidthMode: mode,
        label: appGridLabel(
          label,
          align: Alignment.center,
        ),
      );
    }

    return [
      textColumn('date', 'Date'),
      textColumn('shift', 'Shift'),
      textColumn('target', 'Target (Day)', isNumeric: true),
      textColumn('cum_target', 'Target (Total)', isNumeric: true),
      if (isFullType) ...[
        textColumn('kgs', 'Weight Kgs (Day)', isNumeric: true),
        textColumn('cum_kgs', 'Weight Kgs (Total)', isNumeric: true),
      ],
      textColumn('nos', 'Prod Nos (Day)', isNumeric: true),
      textColumn('cum_nos', 'Prod Nos (Total)', isNumeric: true),
      textColumn('mtr', 'Mtr (Day)', isNumeric: true),
      textColumn('cum_mtr', 'Mtr (Total)', isNumeric: true),
    ];
  }
}

class DaywiseFilterDialog {
  static void show(BuildContext context, DaywiseProductionController controller) {
    DateTime tempStart = controller.startDate.value;
    DateTime tempEnd = controller.endDate.value;
    String tempDept = controller.reportDeptFilter.value;

    Get.dialog(
      StatefulBuilder(
        builder: (ctx, setState) {
          final dummy = DropDownResponse(value: '', text: 'Select Department');
          final matchingItem = controller.deptDropdownList.firstWhere(
            (item) => item.value == tempDept,
            orElse: () => controller.deptDropdownList.isNotEmpty ? controller.deptDropdownList.first : dummy,
          );

          return GenericDialogBox(
            headerText: 'Filters',
            primaryButtonText: 'Apply',
            secondaryButtonText: 'CANCEL',
            onPrimaryButtonPressed: () {
              controller.startDate.value = tempStart;
              controller.endDate.value = tempEnd;
              controller.reportDeptFilter.value = tempDept;
              controller.getDaywiseReportData();
              Get.back();
            },
            onSecondaryButtonPressed: () => Get.back(),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Department
                AppText('Department', style: TextStyles.small(context)),
                8.heightGap,
                Obx(() {
                  if (controller.isLoading.value && controller.deptDropdownList.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: LoadingIndicator(),
                      ),
                    );
                  }
                  return CustomDropdownSingle(
                    width: double.infinity,
                    hintText: 'Select Department',
                    selectedItem: matchingItem.value == '' ? null : matchingItem,
                    items: controller.deptDropdownList,
                    onChanged: (v) {
                      if (v?.value != null) setState(() => tempDept = v!.value!);
                    },
                  );
                }),
                16.heightGap,
                // Dates
                Row(
                  children: [
                    Expanded(
                      child: DatePickerField(
                        label: 'Start Date',
                        date: tempStart,
                        onChanged: (v) => setState(() => tempStart = v),
                      ),
                    ),
                    12.widthGap,
                    Expanded(
                      child: DatePickerField(
                        label: 'End Date',
                        date: tempEnd,
                        onChanged: (v) => setState(() => tempEnd = v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
