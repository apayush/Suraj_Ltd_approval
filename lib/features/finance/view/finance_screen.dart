import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/features/dashboard/controller/app_drawer_controller.dart';
import 'package:suraj_approval/features/finance/view/widgets/finance_mobile.dart';
import 'package:suraj_approval/features/finance/view/widgets/finance_tablet.dart';
import 'package:suraj_approval/features/finance/view/widgets/finance_web.dart';

import '../../../core/widgets/loading_widget.dart';
import '../controller/finance_controller.dart';

class FinanceScreen extends StatefulWidget {
  FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<AppDrawerController>().setSelectedMenuDrawer(MenuType.finance);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScreenTypeLayout.builder(
          mobile: (context) => FinanceMobile(),
          tablet: (context) => FinanceTablet(),
          desktop: (context) => FinanceWeb(),
        ),
        LoaderWidget(controller: Get.find<FinanceController>()),
      ],
    );
  }
}
