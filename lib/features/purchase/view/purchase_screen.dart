import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/features/dashboard/controller/app_drawer_controller.dart';
import 'package:suraj_approval/features/purchase/view/widgets/purchase_mobile.dart';
import 'package:suraj_approval/features/purchase/view/widgets/purchase_tablet.dart';
import 'package:suraj_approval/features/purchase/view/widgets/purchase_web.dart';

import '../../../core/widgets/loading_widget.dart';
import '../controller/purchase_controller.dart';

class PurchaseScreen extends StatefulWidget {
  PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<AppDrawerController>().setIndex(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScreenTypeLayout.builder(
          mobile: (context) => PurchaseMobile(),
          tablet: (context) => PurchaseTablet(),
          desktop: (context) => PurchaseWeb(),
        ),
        LoaderWidget(controller: Get.find<PurchaseController>()),
      ],
    );
  }
}
