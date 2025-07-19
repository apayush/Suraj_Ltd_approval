import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/features/finance/view/widgets/finance_mobile.dart';
import 'package:suraj_approval/features/finance/view/widgets/finance_tablet.dart';
import 'package:suraj_approval/features/finance/view/widgets/finance_web.dart';
import '../../../core/widgets/loading_widget.dart';
import '../controller/finance_controller.dart';

class FinanceScreen extends GetView<FinanceController> {
  FinanceScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScreenTypeLayout.builder(
          mobile: (context) => FinanceMobile(),
          tablet: (context) => FinanceTablet(),
          desktop: (context) => FinanceWeb(),
        ),
        LoaderWidget(controller: controller)
      ]
    );
  }
}
