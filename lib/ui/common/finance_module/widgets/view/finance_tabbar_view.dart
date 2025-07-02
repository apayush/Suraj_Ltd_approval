import 'package:flutter/material.dart';
import '../../../../../feature/controller/finance_controllers/finance_controller.dart';
import 'tabs/bank_payment.dart';
import 'tabs/bank_receipt.dart';
import 'tabs/cash_payment.dart';
import 'tabs/cash_receipt.dart';

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
