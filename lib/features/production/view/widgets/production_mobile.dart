import 'package:flutter/material.dart';

import '../../../../core/utills/app_module_container.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../controller/production_controller.dart';

class ProductionMobile extends StatelessWidget {
  ProductionMobile({super.key});

  final controller = ProductionController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text('Production', style: TextStyle(color: Colors.black)),
      body: Center(
        child: AppText(
          'Production Mobile',
          style: TextStyles.normal(context),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
