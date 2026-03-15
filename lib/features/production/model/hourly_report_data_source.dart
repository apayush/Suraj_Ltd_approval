import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/features/production/model/hourly_report_model.dart';


class HourlyReportDataSource extends DataGridSource {
  final String reportType; // Changed from ReportType to String
  final bool isDark;
  List<DataGridRow> _dataGridRows = [];

  HourlyReportDataSource({
    required List<HourlyEntry?> entries,
    required this.reportType,
    required this.isDark,
  }) {
    _buildDataGridRows(entries);
  }

  void _buildDataGridRows(List<HourlyEntry?> entries) {
    _dataGridRows = entries.map((entry) {
      final localTarget = entry?.target;
      final localActual = entry?.actual;
      final ok = (localActual ?? 0) >= (localTarget ?? 0);
      final slot = entry?.timeSlot ?? '-';

      // Only add DIA/Grade/Size columns if expansion
      if (reportType.toLowerCase().contains('expansion')) { // Logic updated
        return DataGridRow(cells: [
          DataGridCell<String>(
              columnName: 'dia_no',
              value: entry?.dia.isEmpty == true ? '-' : (entry?.dia ?? '-')),
          DataGridCell<String>(
              columnName: 'grade', value: entry?.grade ?? '-'),
          DataGridCell<String>(columnName: 'time', value: slot),
          DataGridCell<int?>(columnName: 'target', value: entry?.target),
          DataGridCell<int?>(
              columnName: 'cum_target', value: entry?.cumulativeTarget),
          DataGridCell<int?>(
            columnName: 'actual', value: entry?.actual,
          ),
          DataGridCell<Map<String, dynamic>?>(
              columnName: 'cum_actual', value: entry?.cumulativeActual != null ? {'val': entry?.cumulativeActual, 'ok': ok} : null),
          DataGridCell<String>(
              columnName: 'size_wise', value: entry?.size ?? '-'),
        ]);
      } else {
        return DataGridRow(cells: [
          DataGridCell<String>(columnName: 'time', value: slot),
          DataGridCell<int?>(columnName: 'target', value: entry?.target),
          DataGridCell<int?>(
              columnName: 'cum_target', value: entry?.cumulativeTarget),
          DataGridCell<int?>(
            columnName: 'actual', value: entry?.actual,
          ),
          DataGridCell<Map<String, dynamic>?>(
              columnName: 'cum_actual', value: entry?.cumulativeActual != null ? {'val': entry?.cumulativeActual, 'ok': ok} : null),
        ]);
      }
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color getRowBackgroundColor() {
      final int index = _dataGridRows.indexOf(row);
      if (index % 2 != 0) {
        return isDark ? Colors.grey[850]! : Colors.grey[100]!;
      }
      return Colors.transparent;
    }

    final dashStyle =
        TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade400);

    return DataGridRowAdapter(
      color: getRowBackgroundColor(),
      cells: row.getCells().map<Widget>((e) {
        if (e.value == null) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text('-', style: dashStyle),
          );
        }

        if (e.columnName == 'cum_target') {
          return Container(
            alignment: Alignment.center,
            color: isDark
                ? AppColors.blue.withValues(alpha: 0.15)
                : const Color(0xFFE1EAF0),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text(
              e.value.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.blue500,
                fontSize: 12,
              ),
            ),
          );
        }

        if (e.columnName == 'cum_actual') {
          final map = e.value as Map<String, dynamic>;
          return Container(
            alignment: Alignment.center,
            color: isDark
                ? Colors.green.withValues(alpha: 0.15)
                : Colors.green.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text(
              map['val'].toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
                fontSize: 12,
              ),
            ),
          );
        }

        if (e.columnName == 'actual') {
          final actualVal = e.value as int;
          // To get 'ok' we need to find target in the row
          final targetCell =
              row.getCells().firstWhere((c) => c.columnName == 'target');
          final ok = actualVal >= ((targetCell.value as int?) ?? 0);
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text(
              actualVal.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ok ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
          );
        }

        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            e.value.toString(),
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
