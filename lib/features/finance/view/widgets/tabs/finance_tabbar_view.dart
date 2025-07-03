import 'package:flutter/material.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/screens/bank_payment.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/screens/bank_receipt.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/screens/cash_payment.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/screens/cash_receipt.dart';
import '../../../../../features/finance/controller/finance_controller.dart';

class FinanceTabView extends StatelessWidget {
  final FinanceController controller;

  const FinanceTabView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller.tabController,
      children: const [
        BankPayment(),
        BankReceipt(),
        CashPayment(),
        CashReceipt(),
      ],
    );
  }
}
