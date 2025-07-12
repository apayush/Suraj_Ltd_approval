import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/features/auth/model/user_model.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/screens/bank_payment.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/screens/bank_receipt.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/screens/cash_payment.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/screens/cash_receipt.dart';
import '../../../../../core/models/user_model.dart';
import '../../../controller/bank_payment_controller.dart';
import '../../../controller/bank_receipt_controller.dart';
import '../../../controller/cash_payment_controller.dart';
import '../../../controller/cash_receipt_controller.dart';
import '../../../controller/finance_controller.dart';

class FinanceTabView extends StatelessWidget {
  FinanceTabView({super.key});

  final userModel = Get.find<UserModel>();

  @override
  Widget build(BuildContext context) {
    final allowedSubMenus = userModel.getSubMenusFor(MenuType.finance);

    final tabViews = <Widget>[];

    if (allowedSubMenus.contains(SubMenuType.bankPayment)) {
      tabViews.add(
        GetBuilder<BankPaymentController>(
          init: BankPaymentController(),
          autoRemove: false,
          builder: (_) => BankPayment(),
        ),
      );
    }

    if (allowedSubMenus.contains(SubMenuType.bankReceipt)) {
      tabViews.add(
        GetBuilder<BankReceiptController>(
          init: BankReceiptController(),
          autoRemove: false,
          builder: (_) => BankReceipt(),
        ),
      );
    }

    if (allowedSubMenus.contains(SubMenuType.cashPayment)) {
      tabViews.add(
        GetBuilder<CashPaymentController>(
          init: CashPaymentController(),
          autoRemove: false,
          builder: (_) => CashPayment(),
        ),
      );
    }

    if (allowedSubMenus.contains(SubMenuType.cashReceipt)) {
      tabViews.add(
        GetBuilder<CashReceiptController>(
          init: CashReceiptController(),
          autoRemove: false,
          builder: (_) => const CashReceipt(),
        ),
      );
    }

    if (tabViews.isEmpty) {
      tabViews.add(
        const Center(child: Text('No Access to Finance Submenus')),
      );
    }

    final controller = Get.find<FinanceController>();

    return TabBarView(
      controller: controller.tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: tabViews,
    );
  }
}
