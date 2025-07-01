import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/ui/common/finance_module/widgets/finance_mobile.dart';
import 'package:suraj_approval/ui/common/finance_module/widgets/finance_tablet.dart';
import 'package:suraj_approval/ui/common/finance_module/widgets/finance_web.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../feature/controller/finance_controllers/finance_controller.dart';

class FinanceScreen extends StatelessWidget {
  FinanceScreen({super.key});

  final controller = FinanceController.instance;

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
