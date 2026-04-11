import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:suraj_approval/features/production/model/ffd_model.dart';

class FFDReportDataSource extends DataGridSource {
  final bool isDark;
  List<DataGridRow> _dataGridRows = [];

  FFDReportDataSource({
    required List<FFDReportEntry> entries,
    required this.isDark,
  }) {
    _buildDataGridRows(entries);
  }

  void _buildDataGridRows(List<FFDReportEntry> entries) {
    _dataGridRows = entries.map((e) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'date', value: e.date),
        DataGridCell<int>(columnName: 'elbow', value: e.elbowQty),
        DataGridCell<int>(columnName: 'elbowTotal', value: e.elbowTotal),
        DataGridCell<int>(columnName: 'tee', value: e.teeQty),
        DataGridCell<int>(columnName: 'teeTotal', value: e.teeTotal),
        DataGridCell<int>(columnName: 'reducer', value: e.reducerQty),
        DataGridCell<int>(columnName: 'reducerTotal', value: e.reducerTotal),
        DataGridCell<int>(columnName: 'cap', value: e.capQty),
        DataGridCell<int>(columnName: 'capTotal', value: e.capTotal),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  // "Total" columns get a blue accent background to match the HTML demo
  static const _totalColumns = {
    'elbowTotal',
    'teeTotal',
    'reducerTotal',
    'capTotal',
  };

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color getRowBg() {
      final idx = _dataGridRows.indexOf(row);
      if (idx % 2 != 0) {
        return isDark ? Colors.grey[850]! : Colors.grey[100]!;
      }
      return Colors.transparent;
    }

    final dashStyle =
        TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade400);

    return DataGridRowAdapter(
      color: getRowBg(),
      cells: row.getCells().map<Widget>((cell) {
        final text = cell.value?.toString() ?? '-';
        final isDash = text == '0' || text.isEmpty;
        final isTotal = _totalColumns.contains(cell.columnName);

        return Container(
          alignment: cell.columnName == 'date'
              ? Alignment.centerLeft
              : Alignment.center,
          padding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          color: isTotal
              ? (isDark
                  ? const Color(0xFF0D3158).withOpacity(0.4)
                  : const Color(0xFFDDEBF7))
              : null,
          child: Text(
            isDash ? '-' : text,
            style: TextStyle(
              fontSize: 12,
              color: isTotal
                  ? (isDark ? Colors.lightBlueAccent : const Color(0xFF0D6EFD))
                  : (isDash ? dashStyle.color : null),
              fontWeight:
                  isTotal ? FontWeight.bold : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
