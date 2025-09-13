import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/core/widgets/no_data_found.dart';
import 'package:suraj_approval/core/widgets/sfdatagrid.dart';
import 'package:suraj_approval/features/finance/model/bank_payment_model.dart';
import 'package:suraj_approval/features/sales/controller/sales_controller.dart';
import 'package:suraj_approval/features/sales/view/widgets/tabs/widgets/sales_search_and_refresh_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesWebView extends GetView<SalesController> {
  SalesWebView({super.key, required this.subMenuType});
  final SubMenuType subMenuType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesSearchAndRefreshWidget(),
        10.heightGap,
        Obx(() {
          controller.isLoading.value;
          List<VoucherModel> financeDataList = switch (subMenuType) {
            SubMenuType.salesOrder => controller.filteredSalesOrderList,
            SubMenuType.salesQuotation => controller.filteredSalesQuotationList,
            SubMenuType.salesEnquiry => controller.filteredSalesEnquiryList,
            SubMenuType.salesCreditNote =>
              controller.filteredSalesCreditNoteList,
            _ => [],
          };

          final dataSource = switch (subMenuType) {
            SubMenuType.salesOrder => controller.salesOrderDataSource,
            SubMenuType.salesQuotation => controller.salesQuotationDataSource,
            SubMenuType.salesEnquiry => controller.salesEnquiryDataSource,
            SubMenuType.salesCreditNote => controller.salesCreditNoteDataSource,
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
                        columnWidthMode: ColumnWidthMode.auto,
                        label: appGridLabel('Party'),
                        allowSorting: false,
                      ),
                      GridColumn(
                        columnName: 'Amount',
                        columnWidthMode: ColumnWidthMode.auto,
                        label: appGridLabel('Amount'),
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
                        maximumWidth: 160,
                        columnWidthMode: ColumnWidthMode.auto,
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
