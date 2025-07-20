import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../features/finance/controller/finance_controller.dart';
import '../../../../features/finance/model/bank_payment_model.dart';
import '../../../widgets/common_widgets.dart';
import '../../app_module_container.dart';
import '../../app_utills.dart';

class BankPaymentDataSource extends DataGridSource {
  List<BankPaymentModel> bankPaymentList = [];
  List<BankPaymentModel> paginatedItems = [];
  int rowsPerPage;
  int currentPageIndex = 0;

  BankPaymentDataSource(this.bankPaymentList, {required this.rowsPerPage}) {
    _loadInitialPage();
  }

  List<DataGridRow> _dataGridRows = [];

  void _loadInitialPage() {
    paginatedItems = bankPaymentList.take(rowsPerPage).toList();
    _buildDataGridRows();
  }

  void setRowsPerPage(int newRowsPerPage) {
    if (rowsPerPage != newRowsPerPage) {
      rowsPerPage = newRowsPerPage;
      currentPageIndex = 0;
      _loadInitialPage();
      notifyListeners();
    }
  }

  void _buildDataGridRows() {
    _dataGridRows = paginatedItems
        .map<DataGridRow>((e) {
          return DataGridRow(cells: _buildDataGridCells(e));
        })
        .toList(growable: false);
  }

  List<DataGridCell<dynamic>> _buildDataGridCells(BankPaymentModel e) {
    List<DataGridCell<dynamic>> cells = [
      _createCell('', (e.sno ?? '').toString()),
      _createCell('Branch', (e.mBranch ?? '').toString()),
      _createCell('Type', (e.type ?? '').toString()),
      _createCell('Srl', e.srl ?? ''),
      _createCell('DocDate', e.docDate ?? ''),
      _createCell('Party', e.party ?? ''),
      _createCell('Debit', e.debit?.toString() ?? '0'),
      _createCell('Credit', e.credit?.toString() ?? '0'),
      _createCell('AuthIds', e.authIds ?? ''),
      _createCell('Narr', e.narr ?? ''),
    ];
    cells.add(DataGridCell(columnName: 'Action', value: e));
    return cells;
  }

  DataGridCell<String> _createCell(String columnName, String value) {
    return DataGridCell<String>(columnName: columnName, value: value);
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Color backgroundColor;
    final int rowIndex = _dataGridRows.indexOf(row);
    backgroundColor = AppUtils.getDataGridRowColor(rowIndex);

    return DataGridRowAdapter(
      color: backgroundColor,
      cells:
          row.getCells().map<Widget>((dataGridCell) {
            if (dataGridCell.columnName == 'Action') {
              return buildActionIcons(dataGridCell.value as BankPaymentModel);
            } else {
              return Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: AppText(
                  dataGridCell.value.toString(),
                  style: TextStyles.small(Get.context!),
                  overflow: TextOverflow.ellipsis,
                  alignment: Alignment.centerLeft,
                ),
              );
            }
          }).toList(),
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    currentPageIndex = newPageIndex;
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;

    if (startIndex < bankPaymentList.length) {
      paginatedItems =
          bankPaymentList
              .getRange(
                startIndex,
                endIndex > bankPaymentList.length
                    ? bankPaymentList.length
                    : endIndex,
              )
              .toList();

      _buildDataGridRows();
      notifyListeners();
    } else {
      paginatedItems = [];
      _buildDataGridRows();
      notifyListeners();
    }
    return true;
  }

  Widget buildActionIcons(BankPaymentModel model) {
    final controller = Get.find<FinanceController>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: IconButton(
            icon: const Icon(Icons.visibility, color: Colors.blue),
            tooltip: 'View',
            onPressed: () => controller.handleMenuSelection('View', model),
          ),
        ),
        Flexible(
          child: IconButton(
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
            tooltip: 'Approve',
            onPressed: () => controller.handleMenuSelection('Approve', model),
          ),
        ),
        Flexible(
          child: IconButton(
            icon: const Icon(Icons.cancel_outlined, color: Colors.red),
            tooltip: 'Reject',
            onPressed: () => controller.handleMenuSelection('Reject', model),
          ),
        ),
      ],
    );
  }

  void updateDataSource(List<BankPaymentModel> updateList) {
    bankPaymentList = updateList;
    currentPageIndex = 0;
    // paginatedItems = updateList.take(rowsPerPage).toList();
    _buildDataGridRows();
    notifyListeners();
  }
}
