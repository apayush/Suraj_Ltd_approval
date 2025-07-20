import 'package:flutter/material.dart';
import 'package:suraj_approval/features/sales/controller/sales_controller.dart';

import '../../../../core/utills/app_module_container.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';

class SalesTablet extends StatelessWidget {
  SalesTablet({super.key});

  final controller = SalesController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text('Sales', style: TextStyle(color: Colors.black)),
      body: Center(
        child: AppText(
          'Sales Tablet',
          style: TextStyles.normal(context),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
