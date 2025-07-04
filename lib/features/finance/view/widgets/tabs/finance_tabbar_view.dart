import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/screens/bank_payment.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/screens/bank_receipt.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/screens/cash_payment.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/screens/cash_receipt.dart';
import '../../../../../features/finance/controller/finance_controller.dart';
import '../../../controller/bank_payment_controller.dart';
import '../../../controller/bank_receipt_controller.dart';
import '../../../controller/cash_payment_controller.dart';
import '../../../controller/cash_receipt_controller.dart';

class FinanceTabView extends StatelessWidget {
  final controller = FinanceController.instance;

  FinanceTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FinanceController>(
      builder: (controller)
      {
        return TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.tabController,
            children: [
              GetBuilder<BankPaymentController>(
                init: BankPaymentController(),
                autoRemove: false,
                builder: (_) => BankPayment(),
              ),
              GetBuilder<BankReceiptController>(
                init: BankReceiptController(),
                autoRemove: false,
                builder: (_) => BankReceipt(),
              ),
              GetBuilder<CashPaymentController>(
                init: CashPaymentController(),
                autoRemove: false,
                builder: (_) => CashPayment(),
              ),
              GetBuilder<CashReceiptController>(
                init: CashReceiptController(),
                autoRemove: false,
                builder: (_) => CashReceipt(),
              ),
            ],
          );
      },
    );
  }
}
