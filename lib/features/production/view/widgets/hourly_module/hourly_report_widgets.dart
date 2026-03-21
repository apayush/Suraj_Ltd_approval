import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/features/production/controller/hourly_report_controller.dart';
import 'package:suraj_approval/features/production/model/hourly_report_model.dart';
import 'package:suraj_approval/features/production/model/hourly_report_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/core/widgets/sfdatagrid.dart';
import 'package:suraj_approval/core/widgets/app_dialog.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const DatePickerField({
    super.key,
    required this.label,
    required this.date,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, style: TextStyles.small(context)),
        const SizedBox(height: 6),
        AppTextField(
          width: double.infinity,
          hint: DateFormat('dd MMM yyyy').format(date),
          prefixIcon: const Icon(
            Icons.calendar_today_outlined,
            size: 16,
            color: AppColors.blue,
          ),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) onChanged(picked);
          },
        ),
      ],
    );
  }
}

// ─── Time Slot Dropdown ───────────────────────────────────────────────────────

class TimeSlotDropdown extends StatelessWidget {
  final HourlyReportController controller;

  const TimeSlotDropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Time Slot', style: TextStyles.small(context)),
        const SizedBox(height: 6),
        Obx(
          () => CustomDropdownSingle(
            width: double.infinity,
            hintText: 'Select Time',
            selectedItem: controller.selectTimeSlotDropDown.value,
            items: controller.timeSlotDropdownList,
            onChanged: (val) {
              if (val != null && val.value != null) {
                controller.onTimeSlotChanged(val.value!);
                controller.selectTimeSlotDropDown.value = val;
              }
            },
          ),
        ),
      ],
    );
  }
}

// ─── Styled Text Field ────────────────────────────────────────────────────────

class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType keyboardType;
  final Color? valueColor;
  final String? Function(String?)? validator;
  final bool required;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.valueColor,
    this.validator,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText(label, style: TextStyles.small(context)),
            if (required)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
          ],
        ),
        const SizedBox(height: 6),
        AppTextField(
          width: double.infinity,
          controller: controller,
          keyboardType: keyboardType,
          textColor: valueColor ?? (isDark ? Colors.white : Colors.black87),
          fontWeight: valueColor != null ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
          hint: hint,
          isValidator: required,
          validator:
              validator ??
              (required
                  ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
                  : null),
        ),
      ],
    );
  }
}

// ─── Report Table ─────────────────────────────────────────────────────────────

class ReportTable extends StatelessWidget {
  final HourlyReportController controller;
  const ReportTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      final rows = controller.reportRows;
      final type = controller.reportTypeFilter.value;
      int cumTarget = 0, cumActual = 0;

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
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                children: [
                  Text(
                    controller.reportTypeFilter.value.toUpperCase() + ' REPORT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${DateFormat('dd MMM yyyy').format(controller.reportDate.value)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white54 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: Builder(
                builder: (context) {
                  final dataSource = HourlyReportDataSource(
                    entries: rows,
                    reportType: type,
                    isDark: isDark,
                  );

                  return SfDataGridPaginationWithAllData<
                    HourlyReportController
                  >(
                    controller: controller,
                    dynamicColumns: _buildGridColumns(type, isDark),
                    totalItems: kShiftHours.length,
                    hidePaging: true,
                    isScrollbarAlwaysShown: false,
                    rowsPerPage: kShiftHours.length,
                    onPageNavigationStart: (pageIndex) {},
                    onPageNavigationEnd: (pageIndex) {},
                    onRowsPerPageChanged: (value) {},
                    source: dataSource,
                    tableSummaryRows: [
                      GridTableSummaryRow(
                        showSummaryInRow: false,
                        title: 'Total',
                        columns: [
                          const GridSummaryColumn(
                            name: 'targetSummary',
                            columnName: 'target',
                            summaryType: GridSummaryType.sum,
                          ),
                          const GridSummaryColumn(
                            name: 'actualSummary',
                            columnName: 'actual',
                            summaryType: GridSummaryType.sum,
                          ),
                        ],
                        position: GridTableSummaryRowPosition.bottom,
                      ),
                    ],
                  );
                },
              ),
            ),
            // Footer totals
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _TotalChip(
                    label: 'Total Target',
                    value: controller.totalReportTarget.value,
                    color: AppColors.blue,
                  ),
                  const SizedBox(width: 16),
                  _TotalChip(
                    label: 'Total Actual',
                    value: controller.totalReportActual.value,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  List<GridColumn> _buildGridColumns(String type, bool isDark) {
    GridColumn textColumn(String name, String label,
        {bool isNumeric = false, double? width}) {
      return GridColumn(
        columnName: name,
        width: width ?? double.nan,
        columnWidthMode:
        isNumeric ? ColumnWidthMode.auto : ColumnWidthMode.fill,
        label: appGridLabel(
          label,
          align: isNumeric ? Alignment.centerRight : Alignment.centerLeft,
        ),
      );
    }

    if (type.toLowerCase().contains('expansion')) {
      // Must match expansion cells: dia_no, grade, time, target, cum_target, actual, cum_actual, size_wise
      return [
        textColumn('dia_no', 'DIA No.'),
        textColumn('grade', 'Grade'),
        textColumn('time', 'Time Slot'),
        textColumn('target', 'Target/Hr', isNumeric: true),
        textColumn('cum_target', 'Cum. Target', isNumeric: true),
        textColumn('actual', 'Actual/Hr', isNumeric: true),
        textColumn('cum_actual', 'Cum. Actual', isNumeric: true),
        textColumn('size_wise', 'Size Wise'),
      ];
    } else {
      // Must match non-expansion cells: time, target, cum_target, actual, cum_actual
      return [
        textColumn('time', 'Time Slot'),
        textColumn('target', 'Target/Hr', isNumeric: true),
        textColumn('cum_target', 'Cum. Target', isNumeric: true),
        textColumn('actual', 'Actual/Hr', isNumeric: true),
        textColumn('cum_actual', 'Cum. Actual', isNumeric: true),
      ];
    }
  }
}

class _TotalChip extends StatelessWidget {
  final String label;
  final int value;
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
            value.toString(),
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

// ─── Report Filter Bar ────────────────────────────────────────────────────────
/// [compact] = true → mobile: filter icon button → opens a dialog
/// [compact] = false → web/tablet: inline filter bar
class ReportFilterBar extends StatelessWidget {
  final HourlyReportController controller;
  final bool compact;
  const ReportFilterBar({
    super.key,
    required this.controller,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return _MobileFilterButton(controller: controller);
  }
}

// ── Mobile: [Filter icon btn (opens dialog)] | Spacer | [Print btn] ──────────
class _MobileFilterButton extends StatelessWidget {
  final HourlyReportController controller;
  const _MobileFilterButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // ── Filter button (opens dialog) ──
          Obx(() {
            final dept = controller.reportTypeFilter.value;
            final date = DateFormat('dd/MM/yy').format(controller.reportDate.value);
            return AppButton(
              text: '$dept • $date',
              onPressed: () => _showFilterDialog(context),
              backgroundColor: AppColors.blue,
            );
          }),
          const Spacer(),
          // ── Print button ──
          AppButton(
            text: 'Print',
            onPressed: () => controller.printReport(),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    DateTime tempDate = controller.reportDate.value;
    String tempType = controller.reportTypeFilter.value;

    Get.dialog(
      StatefulBuilder(
        builder: (ctx, setState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;

          final dummy = DropDownResponse(
            value: '',
            text: 'Select Department',
          );
          DropDownResponse matchingDDLValue = controller
              .reportTypeDropdownList
              .firstWhere(
                (t) => t.value == tempType,
                orElse:
                    () =>
                        controller.reportTypeDropdownList.isNotEmpty
                            ? controller.reportTypeDropdownList.first
                            : dummy,
              );
          return GenericDialogBox(
            headerText: 'Filters',
            primaryButtonText: 'Apply',
            secondaryButtonText: 'Cancel',
            onPrimaryButtonPressed: () {
              controller.reportDate.value = tempDate;
              controller.reportTypeFilter.value = tempType;
              controller.getHourlyReportData();
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
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
                          DateFormat('dd MMM yyyy').format(tempDate),
                          style: const TextStyle(fontSize: 13),
                        ),
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
                Obx(() {
                  if (controller.isLoading.value) {
                    return const SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }
                  return CustomDropdownSingle(
                    width: double.infinity,
                    hintText: 'Select Department',
                    selectedItem:
                        matchingDDLValue.value == ''
                            ? null
                            : matchingDDLValue,
                    items: controller.reportTypeDropdownList,
                    onChanged: (v) {
                      if (v != null && v.value != null) {
                        setState(() => tempType = v.value!);
                      }
                    },
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Signature Footer ─────────────────────────────────────────────────────────

class SignatureRow extends StatelessWidget {
  const SignatureRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          [
            'Operator Signature',
            'Supervisor Signature',
            'Manager Signature',
          ].map((label) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const Divider(),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
