import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/bank_payment.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/bank_receipt.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/cash_payment.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/cash_receipt.dart';
import '../../../../../core/constants/app_enum.dart';
import '../../../../../core/models/user_model.dart';
import '../../../controller/finance_controller.dart';

class FinanceTabView extends StatelessWidget {
  FinanceTabView({super.key});

  final userModel = Get.find<UserModel>();
  final controller = Get.find<FinanceController>();

  @override
  Widget build(BuildContext context) {
    if (controller.myTabs.isEmpty || controller.tabController.length == 0) {
      return const Center(child: CircularProgressIndicator());
    }

    final allowedSubMenus = userModel.getSubMenusFor(MenuType.finance);

    final tabViews = allowedSubMenus.map((submenu) {
      return Builder(
        builder: (_) {
          switch (submenu) {
            case SubMenuType.bankPayment:
              return BankPayment();
            case SubMenuType.bankReceipt:
              return BankReceipt();
            case SubMenuType.cashPayment:
              return CashPayment();
            case SubMenuType.cashReceipt:
              return CashReceipt();
            default:
              return const Center(child: Text('Invalid Tab'));
          }
        },
      );
    }).toList();

    return TabBarView(
      controller: controller.tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: tabViews,
    );
  }
}
