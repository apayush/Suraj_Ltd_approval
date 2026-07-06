import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:suraj_approval/features/production/model/lg30_pilger_model.dart';

class LG30ReportDataSource extends DataGridSource {
  final bool isDark;
  List<DataGridRow> _dataGridRows = [];

  LG30ReportDataSource({
    required List<LG30ReportEntry> entries,
    required this.isDark,
  }) {
    _buildDataGridRows(entries);
  }

  void _buildDataGridRows(List<LG30ReportEntry> entries) {
    _dataGridRows = entries.map((entry) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'dept', value: entry.dept),
        DataGridCell<String>(columnName: 'machine', value: entry.machineName),
        DataGridCell<String>(columnName: 'date', value: entry.date),
        DataGridCell<String>(columnName: 'shift', value: entry.shift),
        DataGridCell<int>(columnName: 'nos', value: entry.nos),
        DataGridCell<double>(columnName: 'kgs', value: entry.kgs),
        DataGridCell<double>(columnName: 'mtr', value: entry.mtr),
        DataGridCell<String>(columnName: 'maint', value: entry.maint),
        DataGridCell<String>(columnName: 'rm', value: entry.rm),
        DataGridCell<String>(columnName: 'man', value: entry.man),
        DataGridCell<String>(columnName: 'other', value: entry.other),
        DataGridCell<String>(columnName: 'createdBy', value: entry.createdBy),
      ]);
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
        final String text = e.value?.toString() ?? '-';
        final isDash = text == '0' || text == '0.0' || text.isEmpty;

        return Container(
          alignment: (e.columnName == 'nos' ||
                  e.columnName == 'kgs' ||
                  e.columnName == 'mtr')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            isDash ? '-' : text,
            style: TextStyle(
              fontSize: 12,
              color: isDash ? dashStyle.color : null,
              fontWeight:
                  e.columnName == 'machine' ? FontWeight.bold : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
