import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/features/finance/model/bank_payment_model.dart';
import 'package:suraj_approval/features/purchase/controller/purchase_controller.dart';
import '../../../../../finance/view/widgets/tabs/widgets/finance_payment_card.dart';

class PurchaseVoucherList extends GetView<PurchaseController> {
  const PurchaseVoucherList({super.key, required this.financePaymentList});
  final List<VoucherModel> financePaymentList;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh:
          () async =>
          controller.getAllData(mainType: controller.currentSubMenu.value),
      child: AnimationLimiter(
        child: ListView.builder(
          itemCount: financePaymentList.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final payments = financePaymentList[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: VoucherCard(
                    payment: payments,
                    primaryColor: AppColors.blue,
                    onTap: () {
                      controller.handleMenuSelection('View', payments);
                    },
                    onApprove: () {
                      controller.handleMenuSelection('Approve', payments);
                    },
                    onHold: () {
                      controller.handleMenuSelection('Hold', payments);
                    },
                    onReject: () {
                      controller.handleMenuSelection('Reject', payments);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
