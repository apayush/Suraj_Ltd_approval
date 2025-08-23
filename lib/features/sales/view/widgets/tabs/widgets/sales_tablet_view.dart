import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/widgets/no_data_found.dart';
import 'package:suraj_approval/features/finance/model/bank_payment_model.dart';
import 'package:suraj_approval/features/sales/controller/sales_controller.dart';
import 'package:suraj_approval/features/sales/view/widgets/tabs/widgets/sales_search_and_refresh_widget.dart';
import 'package:suraj_approval/features/sales/view/widgets/tabs/widgets/sales_voucher_list.dart';

class SalesTabletView extends GetView<SalesController> {
  SalesTabletView({super.key, required this.subMenuType});
  final SubMenuType subMenuType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalesSearchAndRefreshWidget(),
        10.heightGap,
        Obx(() {
          List<VoucherModel> salesDataList = switch (subMenuType) {
            SubMenuType.salesOrder =>
            controller.filteredSalesOrderList,
            _ => [],
          };
          return salesDataList.isNotEmpty
              ? Expanded(
            child: SalesVoucherList(
              salesVoucherList: salesDataList,
            ),
          )
              : const Center(child: NoDataFound());
        }),
      ],
    );
  }
}
