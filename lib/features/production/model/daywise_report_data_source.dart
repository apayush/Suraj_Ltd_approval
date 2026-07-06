import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:suraj_approval/features/production/model/daywise_report_model.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';

class DaywiseReportDataSource extends DataGridSource {
  final bool isFullType;
  final bool isDark;
  List<DataGridRow> _dataGridRows = [];

  DaywiseReportDataSource({
    required List<DaywiseEntry> entries,
    required this.isFullType,
    required this.isDark,
  }) {
    _buildDataGridRows(entries);
  }

  void _buildDataGridRows(List<DaywiseEntry> entries) {
    _dataGridRows = entries.map((entry) {
      List<DataGridCell> cells = [
        DataGridCell<String>(
          columnName: 'date',
          value: DateFormat('dd/MM/yyyy').format(entry.date),
        ),
        DataGridCell<String>(columnName: 'shift', value: entry.shift),
        DataGridCell<int>(columnName: 'target', value: entry.target),
        DataGridCell<int>(columnName: 'cum_target', value: entry.cumulativeTarget),
      ];

      if (isFullType) {
        cells.addAll([
          DataGridCell<double>(columnName: 'kgs', value: entry.actualKgs),
          DataGridCell<double>(columnName: 'cum_kgs', value: entry.cumulativeKgs),
        ]);
      }

      cells.addAll([
        DataGridCell<int>(columnName: 'nos', value: entry.actualNos),
        DataGridCell<int>(columnName: 'cum_nos', value: entry.cumulativeNos),
        DataGridCell<double>(columnName: 'mtr', value: entry.actualMtr),
        DataGridCell<double>(columnName: 'cum_mtr', value: entry.cumulativeMtr),
      ]);

      return DataGridRow(cells: cells);
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

    return DataGridRowAdapter(
      color: getRowBackgroundColor(),
      cells: row.getCells().map<Widget>((e) {
        bool isCumulative = e.columnName.startsWith('cum_');
        
        Alignment alignment = Alignment.center;
        if (e.columnName == 'date' || e.columnName == 'shift') {
          alignment = Alignment.centerLeft;
        }

        return Container(
          alignment: alignment,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: isCumulative 
              ? (isDark ? AppColors.blue.withValues(alpha: 0.1) : const Color(0xFFE1EAF0))
              : null,
          child: Text(
            e.value.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCumulative ? FontWeight.bold : FontWeight.normal,
              color: isCumulative ? AppColors.blue : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
