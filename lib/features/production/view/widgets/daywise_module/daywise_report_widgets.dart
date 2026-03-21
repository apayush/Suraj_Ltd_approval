import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/features/production/controller/daywise_report_controller.dart';
import 'package:suraj_approval/features/production/model/daywise_report_model.dart';
import '../hourly_module/hourly_report_widgets.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';
import 'package:suraj_approval/core/widgets/app_dialog.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';

import 'package:suraj_approval/features/production/model/daywise_report_data_source.dart';
import 'package:suraj_approval/core/widgets/sfdatagrid.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DaywiseReportTable extends StatelessWidget {
  final List<DaywiseEntry> entries;
  final bool isFullType;
  final DaywiseProductionController controller;

  const DaywiseReportTable({
    super.key,
    required this.entries,
    required this.isFullType,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dataSource = DaywiseReportDataSource(
      entries: entries,
      isFullType: isFullType,
      isDark: isDark,
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: SfDataGridPaginationWithAllData<DaywiseProductionController>(
        controller: controller,
        dynamicColumns: _buildGridColumns(isFullType),
        totalItems: entries.length,
        hidePaging: true,
        isScrollbarAlwaysShown: false,
        rowsPerPage: entries.isEmpty ? 10 : entries.length,
        onPageNavigationStart: (pageIndex) {},
        onPageNavigationEnd: (pageIndex) {},
        onRowsPerPageChanged: (value) {},
        source: dataSource,
      ),
    );
  }

  List<GridColumn> _buildGridColumns(bool isFullType) {
    GridColumn textColumn(String name, String label, {bool isNumeric = false}) {
      return GridColumn(
        columnName: name,
        columnWidthMode: isNumeric ? ColumnWidthMode.auto : ColumnWidthMode.fill,
        label: appGridLabel(
          label,
          align: isNumeric ? Alignment.centerRight : Alignment.centerLeft,
        ),
      );
    }

    return [
      textColumn('date', 'DATE'),
      textColumn('target', 'TARGET (DAY)', isNumeric: true),
      textColumn('cum_target', 'TARGET (TOTAL)', isNumeric: true),
      textColumn('nos', 'PROD NOS (DAY)', isNumeric: true),
      textColumn('cum_nos', 'PROD NOS (TOTAL)', isNumeric: true),
      if (isFullType) ...[
        textColumn('kgs', 'WEIGHT KGS (DAY)', isNumeric: true),
        textColumn('cum_kgs', 'WEIGHT KGS (TOTAL)', isNumeric: true),
      ],
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
                CustomDropdownSingle(
                  width: double.infinity,
                  hintText: 'Select Department',
                  selectedItem: matchingItem.value == '' ? null : matchingItem,
                  items: controller.deptDropdownList,
                  onChanged: (v) {
                    if (v?.value != null) setState(() => tempDept = v!.value!);
                  },
                ),
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
