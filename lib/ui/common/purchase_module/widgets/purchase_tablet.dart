import 'package:flutter/material.dart';
import 'package:suraj_approval/features/purchase/controller/purchase_controller.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../utills/app_module_container.dart';

class PurchaseTablet extends StatelessWidget {
  PurchaseTablet({super.key});

  final controller = PurchaseController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: AppText(
          'Purchase Tablet',
          style: TextStyles.normal(context),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
