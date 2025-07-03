import 'package:flutter/material.dart';
import 'package:suraj_approval/features/sales/controller/sales_controller.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../utills/app_module_container.dart';

class SalesWeb extends StatelessWidget {
  SalesWeb({super.key});

  final controller = SalesController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: AppText(
          'Sales Web',
          style: TextStyles.normal(context),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
