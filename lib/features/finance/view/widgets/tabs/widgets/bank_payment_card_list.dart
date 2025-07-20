import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/bank_payment_detail_screen.dart';
import '../../../../controller/finance_controller.dart';
import 'bank_payment_card.dart';

class BankPaymentCardList extends GetView<FinanceController> {
  const BankPaymentCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.bankPaymentList.length,
      itemBuilder: (context, index) {
        final payments = controller.bankPaymentList[index];
        return PaymentCard(
          payment: payments,
          primaryColor: AppColors.blue,
          onTap: () {
            Get.to(
              PaymentDetailScreen(
                payment: payments,
                primaryColor: AppColors.blue,
              ),
            );
          },
          onApprove: () {},
          onReject: () {},
        );
      },
    );
  }
}
