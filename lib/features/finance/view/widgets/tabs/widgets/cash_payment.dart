import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../../../../core/constants/app_strings.dart';
import '../../../../../../core/widgets/app_text_field.dart';
import '../../../../../../core/widgets/common_widgets.dart';
import '../../../../../../core/widgets/no_data_found.dart';
import '../../../../../../core/widgets/sfdatagrid.dart';
import '../../../../controller/finance_controller.dart';

class CashPayment extends GetView<FinanceController> {
  CashPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSearchFieldRow(context),
        10.heightGap,
        Obx(() => buildCashPaymentTable(context)),
      ],
    );
  }

  Widget buildCashPaymentTable(BuildContext context) {
    return controller.cashPaymentList.isNotEmpty
        ? Expanded(
      child: Obx(() {
        return SfDataGridPaginationWithAllData(
          controller: controller,
          source: controller.cashPaymentDataSource,
          totalItems: controller.cashPaymentList.length,
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
              minimumWidth: 130,
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
  }

  Widget buildSearchFieldRow(BuildContext context) {
    final screenType = getDeviceType(MediaQuery.of(context).size);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (screenType == DeviceScreenType.mobile)
          Expanded(child: buildSearchTextField())
        else
          buildSearchTextField(),
        10.widthGap,
        buildClearFilterButton(),
      ],
    );
  }

  Widget buildSearchTextField() {
    return AppTextField(
      hint: 'Search',
      controller: controller.searchController,
      onChanged: (value) {
        controller.filterData(value);
      },
    );
  }

  Widget buildClearFilterButton() {
    return AppIconButton(
      tooltip: AppStrings.reset,
      onPressed: controller.resetFilters,
      icon: CupertinoIcons.arrow_clockwise,
    );
  }
}
