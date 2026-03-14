import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/features/hourly/controller/hourly_report_controller.dart';
import 'package:suraj_approval/features/hourly/model/hourly_report_model.dart';
// ─── Date Picker Field ────────────────────────────────────────────────────────


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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) onChanged(picked);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
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
                  DateFormat('dd MMM yyyy').format(date),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Time Slot Dropdown ───────────────────────────────────────────────────────

class TimeSlotDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const TimeSlotDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Slot',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(
              Icons.access_time_outlined,
              size: 18,
              color: AppColors.blue,
            ),
          ),
          items:
              kShiftHours
                  .map(
                    (slot) => DropdownMenuItem(
                      value: slot,
                      child: Text(slot, style: const TextStyle(fontSize: 13)),
                    ),
                  )
                  .toList(),
          onChanged: (v) => onChanged(v!),
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
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            color: valueColor ?? (isDark ? Colors.white : Colors.black87),
            fontWeight:
                valueColor != null ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
          validator:
              validator ??
              (required
                  ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
                  : null),
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

// ─── Recent Entries Table ─────────────────────────────────────────────────────

class RecentEntriesCard extends StatelessWidget {
  final HourlyReportController controller;
  const RecentEntriesCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.history, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              final recent = controller.recentEntries;
              if (recent.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No entries yet. Add your first production record.',
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 36,
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 48,
                  columnSpacing: 20,
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                  columns: const [
                    DataColumn(label: Text('TYPE')),
                    DataColumn(label: Text('TIME')),
                    DataColumn(label: Text('TARGET'), numeric: true),
                    DataColumn(label: Text('ACTUAL'), numeric: true),
                    DataColumn(label: Text('ACTION')),
                  ],
                  rows:
                      recent.map((e) {
                        final ok = e.actual >= e.target;
                        return DataRow(
                          cells: [
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.blue.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  e.type.label,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.timeSlot,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.target.toString(),
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.actual.toString(),
                                style: TextStyle(
                                  color: ok ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                  color: Colors.red,
                                ),
                                onPressed: () => _confirmDelete(context, e.id),
                                tooltip: 'Delete',
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete Entry'),
            content: const Text('Are you sure you want to delete this entry?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  controller.deleteEntry(id);
                  Get.back();
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
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
                    type.reportTitle,
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Builder(
                builder: (context) {
                  // Reset cumulative on rebuild
                  cumTarget = 0;
                  cumActual = 0;
                  return DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                    ),
                    columnSpacing: 16,
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.grey.shade800,
                    ),
                    columns: _buildColumns(type),
                    rows: List.generate(kShiftHours.length, (i) {
                      final entry = rows[i];
                      if (entry != null) {
                        cumTarget += entry.target;
                        cumActual += entry.actual;
                      }
                      final localTarget = entry?.target ?? 0;
                      final localActual = entry?.actual ?? 0;
                      final localCumTarget = entry != null ? cumTarget : null;
                      final localCumActual = entry != null ? cumActual : null;
                      final ok = localActual >= localTarget;

                      return DataRow(
                        cells: _buildCells(
                          type: type,
                          slot: kShiftHours[i],
                          entry: entry,
                          target: localTarget,
                          actual: localActual,
                          cumTarget: localCumTarget,
                          cumActual: localCumActual,
                          ok: ok,
                          isDark: isDark,
                        ),
                      );
                    }),
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
                    value: controller.reportTotalTarget,
                    color: AppColors.blue,
                  ),
                  const SizedBox(width: 16),
                  _TotalChip(
                    label: 'Total Actual',
                    value: controller.reportTotalActual,
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

  List<DataColumn> _buildColumns(ReportType type) {
    switch (type) {
      case ReportType.expansion:
        return const [
          DataColumn(label: Text('DIA No.')),
          DataColumn(label: Text('Grade')),
          DataColumn(label: Text('Time')),
          DataColumn(label: Text('Target/Hr'), numeric: true),
          DataColumn(label: Text('Cum. Target'), numeric: true),
          DataColumn(label: Text('Actual/Hr'), numeric: true),
          DataColumn(label: Text('Cum. Actual'), numeric: true),
          DataColumn(label: Text('Size Wise')),
        ];
      case ReportType.pilger:
      case ReportType.dispatch:
        return const [
          DataColumn(label: Text('Time')),
          DataColumn(label: Text('Target/Hr'), numeric: true),
          DataColumn(label: Text('Cum. Target'), numeric: true),
          DataColumn(label: Text('Actual/Hr'), numeric: true),
          DataColumn(label: Text('Cum. Actual'), numeric: true),
        ];
    }
  }

  List<DataCell> _buildCells({
    required ReportType type,
    required String slot,
    required HourlyEntry? entry,
    required int target,
    required int actual,
    required int? cumTarget,
    required int? cumActual,
    required bool ok,
    required bool isDark,
  }) {
    final dash = Text(
      '-',
      style: TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade400),
    );
    final cumBg = isDark
        ? AppColors.blue.withValues(alpha: 0.15)
        : const Color(0xFFE1EAF0); // AppColors.blue50
    final cumGreenBg = isDark
        ? Colors.green.withValues(alpha: 0.15)
        : Colors.green.shade50;

    switch (type) {
      case ReportType.expansion:
        return [
          DataCell(
            Text(
              entry?.dia.isEmpty == true ? '-' : (entry?.dia ?? '-'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          DataCell(
            Text(entry?.grade ?? '-', style: const TextStyle(fontSize: 12)),
          ),
          DataCell(
            Text(
              slot,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ),
          DataCell(
            entry != null
                ? Text(target.toString(), style: const TextStyle(fontSize: 12))
                : dash,
          ),
          DataCell(
            Container(
              color: cumBg,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child:
                  entry != null
                      ? Text(
                        cumTarget.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.blue500,
                          fontSize: 12,
                        ),
                      )
                      : dash,
            ),
          ),
          DataCell(
            entry != null
                ? Text(
                  actual.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ok ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                )
                : dash,
          ),
          DataCell(
            Container(
              color: cumGreenBg,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child:
                  entry != null
                      ? Text(
                        cumActual.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                          fontSize: 12,
                        ),
                      )
                      : dash,
            ),
          ),
          DataCell(
            Text(entry?.size ?? '-', style: const TextStyle(fontSize: 11)),
          ),
        ];
      case ReportType.pilger:
      case ReportType.dispatch:
        return [
          DataCell(
            Text(
              slot,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ),
          DataCell(
            entry != null
                ? Text(target.toString(), style: const TextStyle(fontSize: 12))
                : dash,
          ),
          DataCell(
            Container(
              color: cumBg,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child:
                  entry != null
                      ? Text(
                        cumTarget.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.blue500,
                          fontSize: 12,
                        ),
                      )
                      : dash,
            ),
          ),
          DataCell(
            entry != null
                ? Text(
                  actual.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ok ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                )
                : dash,
          ),
          DataCell(
            Container(
              color: cumGreenBg,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child:
                  entry != null
                      ? Text(
                        cumActual.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                          fontSize: 12,
                        ),
                      )
                      : dash,
            ),
          ),
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
    return compact
        ? _MobileFilterButton(controller: controller)
        : _WebFilterBar(controller: controller);
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
          OutlinedButton.icon(
            onPressed: () => _showFilterDialog(context),
            icon: const Icon(Icons.filter_alt_outlined, size: 16, color: AppColors.blue),
            label: Obx(() {
              final dept = controller.reportTypeFilter.value.label;
              final date = DateFormat('dd/MM/yy').format(controller.reportDate.value);
              return Text(
                '$dept • $date',
                style: const TextStyle(fontSize: 12, color: AppColors.blue),
              );
            }),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.blue,
              side: const BorderSide(color: AppColors.blue),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const Spacer(),
          // ── Print button ──
          ElevatedButton.icon(
            onPressed: () => Get.snackbar('Print', 'Print report coming soon',
                snackPosition: SnackPosition.BOTTOM),
            icon: const Icon(Icons.print_outlined, size: 16),
            label: const Text('Print'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    DateTime tempDate = controller.reportDate.value;
    ReportType tempType = controller.reportTypeFilter.value;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Row(
              children: [
                Icon(Icons.filter_alt_outlined, color: AppColors.blue, size: 20),
                SizedBox(width: 8),
                Text('Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date
                Text('Filter Date',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.grey.shade700)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.blue),
                        const SizedBox(width: 8),
                        Text(DateFormat('dd MMM yyyy').format(tempDate),
                            style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Department
                Text('Department',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.grey.shade700)),
                const SizedBox(height: 6),
                DropdownButtonFormField<ReportType>(
                  value: tempType,
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: ReportType.values
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.label, style: const TextStyle(fontSize: 13)),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => tempType = v);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.onReportDateChanged(tempDate);
                  controller.onReportTypeFilterChanged(tempType);
                  Navigator.of(ctx).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Web / Tablet: inline filter bar ──────────────────────────────────────────
// Layout: [Filter icon + label | Date field | Dept dropdown] | Spacer | [Print btn]
class _WebFilterBar extends StatelessWidget {
  final HourlyReportController controller;
  const _WebFilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Obx(
        () => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Left: filter label + date + dept ──
            const Icon(Icons.filter_alt_outlined, color: AppColors.blue, size: 18),
            const SizedBox(width: 6),
            Text(
              'Filter:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 14),

            // Date picker
            SizedBox(
              width: 190,
              child: DatePickerField(
                label: 'Date',
                date: controller.reportDate.value,
                onChanged: controller.onReportDateChanged,
              ),
            ),
            const SizedBox(width: 12),

            // Department dropdown
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<ReportType>(
                value: controller.reportTypeFilter.value,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Department',
                  labelStyle: const TextStyle(fontSize: 12),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                items: ReportType.values
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.label, style: const TextStyle(fontSize: 13)),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) controller.onReportTypeFilterChanged(v);
                },
              ),
            ),

            const Spacer(),

            // ── Right: Print button ──
            ElevatedButton.icon(
              onPressed: () => Get.snackbar(
                'Print',
                'Print report coming soon',
                snackPosition: SnackPosition.BOTTOM,
              ),
              icon: const Icon(Icons.print_outlined, size: 16),
              label: const Text('Print Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
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
