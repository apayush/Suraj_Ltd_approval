import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/widgets/no_data_found.dart';
import 'package:suraj_approval/features/finance/model/bank_payment_model.dart';
import 'package:suraj_approval/features/purchase/view/widgets/tabs/widgets/purchase_search_and_refresh_widget.dart';
import 'package:suraj_approval/features/purchase/view/widgets/tabs/widgets/purchase_voucher_list.dart';

import '../../../../controller/purchase_controller.dart';

class PurchaseTabletView extends GetView<PurchaseController> {
  PurchaseTabletView({super.key, required this.subMenuType});
  final SubMenuType subMenuType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PurchaseSearchAndRefreshWidget(),
        10.heightGap,
        Obx(() {
          List<VoucherModel> purchaseDataList = switch (subMenuType) {
            SubMenuType.purchaseInvoice =>
              controller.filteredPurchaseInvoiceList,
            SubMenuType.purchaseOrder =>
              controller.filteredPurchaseOrderListList,
            SubMenuType.purchaseIndent =>
              controller.filteredPurchaseIndentList,
            SubMenuType.goodsReceiptNote =>
              controller.filteredGoodsReceiptNoteList,
            SubMenuType.purchaseDebitNote =>
              controller.filteredPurchaseDebitNoteList,
            _ => [],
          };
          return purchaseDataList.isNotEmpty
              ? Expanded(
                child: PurchaseVoucherList(
                  purchaseVoucherList: purchaseDataList,
                ),
              )
              : const Center(child: NoDataFound());
        }),
      ],
    );
  }
}
