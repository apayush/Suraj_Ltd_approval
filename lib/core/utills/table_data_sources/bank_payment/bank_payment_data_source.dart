import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../features/finance/controller/bank_payment_controller.dart';
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
      _createCell('Authorise', (e.authorise ?? '').toString()),
      _createCell('Amount', (e.amount ?? 0).toString()),
      _createCell('Srl', (e.srl ?? '').toString()),
      _createCell('Docdate', e.docdate ?? ''),
      _createCell('Party', e.party ?? ''),
      _createCell('Type', e.type ?? ''),
      _createCell('Narr', e.narr ?? ''),
      _createCell('Link', e.link ?? ''),
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
              return showPopupMenuAction(
                dataGridCell.value as BankPaymentModel,
              );
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
      _buildDataGridRows(); // Update rows to show empty when there are no items
      notifyListeners();
    }
    return true;
  }

  Widget showPopupMenuAction(BankPaymentModel e) {
    final controller = Get.find<BankPaymentController>();
    return PopupMenuButton<String>(
      onSelected: (value) {
        controller.handleMenuSelection(value, e);
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: 'View', child: Text('View')),
            const PopupMenuItem<String>(
              value: 'Approve',
              child: Text('Approve'),
            ),
            const PopupMenuItem<String>(value: 'Reject', child: Text('Reject')),
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
