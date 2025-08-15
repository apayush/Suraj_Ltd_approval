import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/widgets/no_data_found.dart';
import 'package:suraj_approval/features/finance/model/bank_payment_model.dart';
import 'package:suraj_approval/features/purchase/controller/purchase_controller.dart';
import 'package:suraj_approval/features/purchase/view/widgets/tabs/widgets/purchase_search_and_refresh_widget.dart';
import 'package:suraj_approval/features/purchase/view/widgets/tabs/widgets/purchase_voucher_list.dart';

class PurchaseMobileView extends GetView<PurchaseController> {
  PurchaseMobileView({super.key, required this.subMenuType});

  final SubMenuType subMenuType;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      RxList<VoucherModel> financeDataList = switch (subMenuType) {
        SubMenuType.purchaseInvoice => controller.filteredPurchaseInvoiceList,
        SubMenuType.purchaseOrder => controller.filteredPurchaseOrderListList,
        _ => RxList<VoucherModel>.empty(),
      };
      return financeDataList.isNotEmpty
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PurchaseSearchAndRefreshWidget(),
              10.heightGap,
              Expanded(
                child: PurchaseVoucherList(financePaymentList: financeDataList),
              ),
            ],
          )
          : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PurchaseSearchAndRefreshWidget(),
                10.heightGap,
                const Center(child: NoDataFound()),
              ],
            ),
          );
    });
  }
}
