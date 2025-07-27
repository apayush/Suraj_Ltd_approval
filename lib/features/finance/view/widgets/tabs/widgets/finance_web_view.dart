import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/core/widgets/no_data_found.dart';
import 'package:suraj_approval/core/widgets/sfdatagrid.dart';
import 'package:suraj_approval/features/finance/controller/finance_controller.dart';
import 'package:suraj_approval/features/finance/model/bank_payment_model.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/finance_search_and_refresh_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class FinanceWebView extends GetView<FinanceController> {
  FinanceWebView({super.key, required this.subMenuType});
  final SubMenuType subMenuType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FinanceSearchAndRefreshWidget(),
        10.heightGap,
        Obx(() {
          List<FinancePaymentModel> financeDataList = switch (subMenuType) {
            SubMenuType.bankPayment => controller.bankPaymentList,
            SubMenuType.bankReceipt => controller.bankReceiptList,
            SubMenuType.cashPayment => controller.cashPaymentList,
            SubMenuType.cashReceipt => controller.cashReceiptList,
            _ => [],
          };

          final dataSource = switch (subMenuType) {
            SubMenuType.bankPayment => controller.bankPaymentDataSource,
            SubMenuType.bankReceipt => controller.bankReceiptDataSource,
            SubMenuType.cashPayment => controller.cashPaymentDataSource,
            SubMenuType.cashReceipt => controller.cashReceiptDataSource,
            _ => null,
          };
          return financeDataList.isNotEmpty
              ? Expanded(
                child: Obx(() {
                  return SfDataGridPaginationWithAllData(
                    controller: controller,
                    source: dataSource!,
                    totalItems: financeDataList.length,
                    rowsPerPage: controller.rowsPerPage.value,
                    dynamicColumns: [
                      GridColumn(
                        columnName: '',
                        columnWidthMode: ColumnWidthMode.auto,
                        label: appGridLabel(''),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Branch',
                        columnWidthMode: ColumnWidthMode.auto,
                        label: appGridLabel('Branch'),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Type',
                        columnWidthMode: ColumnWidthMode.auto,
                        label: appGridLabel('Type'),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Srl',
                        columnWidthMode: ColumnWidthMode.auto,
                        label: appGridLabel('Srl'),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Docdate',
                        columnWidthMode: ColumnWidthMode.auto,
                        label: appGridLabel('Docdate'),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Party',
                        columnWidthMode: ColumnWidthMode.fill,
                        label: appGridLabel('Party'),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Debit',
                        columnWidthMode: ColumnWidthMode.auto,
                        label: appGridLabel('Debit'),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Credit',
                        columnWidthMode: ColumnWidthMode.auto,
                        label: appGridLabel('Credit'),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'AuthIds',
                        columnWidthMode: ColumnWidthMode.auto,
                        label: appGridLabel('AuthIds'),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Narr',
                        columnWidthMode: ColumnWidthMode.fill,
                        label: appGridLabel('Narr'),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Action',
                        minimumWidth: 210,
                        // columnWidthMode: ColumnWidthMode.auto,
                        label: appGridLabel('Action'),
                        allowSorting: false,
                      ),
                    ],
                    onPageNavigationStart: (pageIndex) {},
                    onPageNavigationEnd: (pageIndex) {},
                    onRowsPerPageChanged: (int? value) {
                      controller.changeRowsPerPage(value!);
                    },
                  );
                }),
              )
              : const Center(child: NoDataFound());
        }),
      ],
    );
  }
}
