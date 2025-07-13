import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/features/finance/controller/bank_payment_controller.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/bank_payment_card_list.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../../../core/constants/app_strings.dart';
import '../../../../../../core/widgets/app_text_field.dart';
import '../../../../../../core/widgets/common_widgets.dart';
import '../../../../../../core/widgets/no_data_found.dart';
import '../../../../../../core/widgets/sfdatagrid.dart';

class BankPayment extends StatelessWidget {
  BankPayment({super.key});

  final controller = Get.find<BankPaymentController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSearchFieldRow(context),
        10.heightGap,
        Obx(() => buildPaymentTable(context)),
      ],
    );
  }

  Widget buildPaymentTable(BuildContext context) {
    final isMobile =
        getDeviceType(MediaQuery.of(context).size) == DeviceScreenType.mobile;

    return controller.bankPaymentList.isNotEmpty
        ? Expanded(
          child:
              isMobile
                  ? BankPaymentCardList()
                  : Obx(() {
                    return SfDataGridPaginationWithAllData(
                      controller: controller,
                      source: controller.bankPaymentDataSource,
                      totalItems: controller.bankPaymentList.length,
                      rowsPerPage: controller.rowsPerPage.value,
                      dynamicColumns: [
                        GridColumn(
                          columnName: 'Authorise',
                          columnWidthMode: ColumnWidthMode.auto,
                          label: appGridLabel('Authorise'),
                        ),
                        GridColumn(
                          columnName: 'Amount',
                          columnWidthMode: ColumnWidthMode.auto,
                          label: appGridLabel('Amount'),
                        ),
                        GridColumn(
                          columnName: 'Srl',
                          columnWidthMode: ColumnWidthMode.auto,
                          label: appGridLabel('Srl'),
                        ),
                        GridColumn(
                          columnName: 'Docdate',
                          columnWidthMode: ColumnWidthMode.auto,
                          label: appGridLabel('Docdate'),
                        ),
                        GridColumn(
                          columnName: 'Party',
                          columnWidthMode: ColumnWidthMode.fill,
                          label: appGridLabel('Party'),
                        ),
                        GridColumn(
                          columnName: 'Type',
                          columnWidthMode: ColumnWidthMode.fill,
                          label: appGridLabel('Type'),
                        ),
                        GridColumn(
                          columnName: 'Narr',
                          columnWidthMode: ColumnWidthMode.fill,
                          label: appGridLabel('Narr'),
                        ),
                        GridColumn(
                          columnName: 'Link',
                          columnWidthMode:
                              isMobile
                                  ? ColumnWidthMode.auto
                                  : ColumnWidthMode.fill,
                          label: appGridLabel('Link'),
                        ),
                        GridColumn(
                          columnName: 'Action',
                          columnWidthMode: ColumnWidthMode.auto,
                          label: appGridLabel('Action'),
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
      // controller: controller.searchController,
      // onChanged: (value) {
      //   controller.filterData(value);
      // },
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
