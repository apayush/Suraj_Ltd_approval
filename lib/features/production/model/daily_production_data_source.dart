import 'package:flutter/material.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:get/get.dart';
import 'daily_production_model.dart';

class DailyProductionDataSource extends DataGridSource {
  final bool isDark;
  List<DataGridRow> _dataGridRows = [];

  DailyProductionDataSource({
    required List<DailyProductionEntry> entries,
    required this.isDark,
  }) {
    _dataGridRows = entries.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'date', value: e.date),
        DataGridCell<int>(columnName: 'cutting', value: e.cutting),
        DataGridCell<int>(columnName: 'forming', value: e.forming),
        DataGridCell<int>(columnName: 'bevelling', value: e.bevelling),
        DataGridCell<int>(columnName: 'total', value: e.dailyTotal),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: isDark ? Colors.grey.shade900 : Colors.white,
      cells: row.getCells().map<Widget>((dataGridCell) {
        final val = dataGridCell.value;

        // Custom styling for total column.
        if (dataGridCell.columnName == 'total') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            color: isDark ? Colors.green.withValues(alpha: 0.2) : Colors.green.withValues(alpha: 0.1),
            child: AppText(
              val.toString(),
              style: TextStyles.small(Get.context!).copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          );
        }

        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: AppText(
            val.toString(),
            style: TextStyles.small(Get.context!).copyWith(
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }
}
