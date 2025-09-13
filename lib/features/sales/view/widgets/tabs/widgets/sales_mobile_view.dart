import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/widgets/no_data_found.dart';
import 'package:suraj_approval/features/finance/model/bank_payment_model.dart';
import 'package:suraj_approval/features/sales/controller/sales_controller.dart';
import 'package:suraj_approval/features/sales/view/widgets/tabs/widgets/sales_search_and_refresh_widget.dart';
import 'package:suraj_approval/features/sales/view/widgets/tabs/widgets/sales_voucher_list.dart';

class SalesMobileView extends GetView<SalesController> {
  SalesMobileView({super.key, required this.subMenuType});

  final SubMenuType subMenuType;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      RxList<VoucherModel> salesDataList = switch (subMenuType) {
        SubMenuType.salesOrder => controller.filteredSalesOrderList,
        SubMenuType.salesQuotation => controller.filteredSalesQuotationList,
        SubMenuType.salesEnquiry => controller.filteredSalesEnquiryList,
        SubMenuType.salesCreditNote => controller.filteredSalesCreditNoteList,
        _ => RxList<VoucherModel>.empty(),
      };
      return salesDataList.isNotEmpty
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SalesSearchAndRefreshWidget(),
              10.heightGap,
              Expanded(
                child: SalesVoucherList(salesVoucherList: salesDataList),
              ),
            ],
          )
          : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SalesSearchAndRefreshWidget(),
                10.heightGap,
                const Center(child: NoDataFound()),
              ],
            ),
          );
    });
  }
}
