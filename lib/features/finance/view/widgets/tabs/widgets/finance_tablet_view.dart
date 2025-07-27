import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/widgets/no_data_found.dart';
import 'package:suraj_approval/features/finance/controller/finance_controller.dart';
import 'package:suraj_approval/features/finance/model/bank_payment_model.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/finance_payment_list.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/finance_search_and_refresh_widget.dart';

class FinanceTabletView extends GetView<FinanceController> {
  FinanceTabletView({super.key, required this.subMenuType});
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
            SubMenuType.bankPayment => controller.filteredBankPaymentList,
            SubMenuType.bankReceipt => controller.filteredBankReceiptList,
            SubMenuType.cashPayment => controller.filteredCashPaymentList,
            SubMenuType.cashReceipt => controller.filteredCashReceiptList,
            _ => [],
          };
          return financeDataList.isNotEmpty
              ? Expanded(
                child: FinancePaymentList(financePaymentList: financeDataList),
              )
              : const Center(child: NoDataFound());
        }),
      ],
    );
  }
}
