import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/features/dashboard/controller/app_drawer_controller.dart';
import 'package:suraj_approval/features/sales/view/widgets/sales_mobile.dart';
import 'package:suraj_approval/features/sales/view/widgets/sales_tablet.dart';
import 'package:suraj_approval/features/sales/view/widgets/saless_web.dart';

import '../../../core/widgets/loading_widget.dart';
import '../controller/sales_controller.dart';

class SalesScreen extends StatefulWidget {
  SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<AppDrawerController>().setSelectedMenuDrawer(MenuType.sales);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScreenTypeLayout.builder(
          mobile: (context) => SalesMobile(),
          tablet: (context) => SalesTablet(),
          desktop: (context) => SalesWeb(),
        ),
        LoaderWidget(controller: Get.find<SalesController>()),
      ],
    );
  }
}
