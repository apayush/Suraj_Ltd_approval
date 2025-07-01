import 'package:flutter/material.dart';
import 'package:suraj_approval/feature/controller/purchase_controllers/purchase_controller.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../feature/controller/production_controllers/production_controller.dart';
import '../../../utills/app_module_container.dart';

class PurchaseMobile extends StatelessWidget {
  PurchaseMobile({super.key});

  final controller = PurchaseController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: AppText(
          'Purchase Mobile',
          style: TextStyles.normal(context),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
