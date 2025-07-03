import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/features/purchase/view/widgets/purchase_mobile.dart';
import 'package:suraj_approval/features/purchase/view/widgets/purchase_tablet.dart';
import 'package:suraj_approval/features/purchase/view/widgets/purchase_web.dart';
import '../../../core/widgets/loading_widget.dart';
import '../controller/purchase_controller.dart';

class PurchaseScreen extends StatelessWidget {
  PurchaseScreen({super.key});

  final controller = PurchaseController.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScreenTypeLayout.builder(
          mobile: (context) => PurchaseMobile(),
          tablet: (context) => PurchaseTablet(),
          desktop: (context) => PurchaseWeb(),
        ),
        LoaderWidget(controller: controller)
      ]
    );
  }
}
