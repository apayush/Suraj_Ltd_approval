import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/features/sales/view/widgets/sales_mobile.dart';
import 'package:suraj_approval/features/sales/view/widgets/sales_tablet.dart';
import 'package:suraj_approval/features/sales/view/widgets/saless_web.dart';

import '../../../core/widgets/loading_widget.dart';
import '../controller/sales_controller.dart';

class SalesScreen extends StatelessWidget {
  SalesScreen({super.key});

  final controller = SalesController.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScreenTypeLayout.builder(
          mobile: (context) => SalesMobile(),
          tablet: (context) => SalesTablet(),
          desktop: (context) => SalesWeb(),
        ),
        LoaderWidget(controller: controller)
      ]
    );
  }
}
