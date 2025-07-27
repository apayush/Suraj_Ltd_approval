import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/features/finance/model/bank_payment_model.dart';

import '../../../../controller/finance_controller.dart';
import 'finance_payment_card.dart';

class FinancePaymentList extends GetView<FinanceController> {
  const FinancePaymentList({super.key, required this.financePaymentList});
  final List<FinancePaymentModel> financePaymentList;

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
                  child: FinancePaymentCard(
                    payment: payments,
                    primaryColor: AppColors.blue,
                    onTap: () {
                      controller.handleMenuSelection('View', payments);
                    },
                    onApprove: () {
                      controller.handleMenuSelection('Approve', payments);
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
