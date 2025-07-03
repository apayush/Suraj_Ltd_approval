import 'package:flutter/material.dart';
import 'package:suraj_approval/features/purchase/controller/purchase_controller.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../core/utills/app_module_container.dart';

class PurchaseWeb extends StatelessWidget {
  PurchaseWeb({super.key});

  final controller = PurchaseController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: AppText(
          'Purchase Web',
          style: TextStyles.normal(context),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
