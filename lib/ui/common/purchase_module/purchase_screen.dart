import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/ui/common/purchase_module/widgets/purchase_mobile.dart';
import 'package:suraj_approval/ui/common/purchase_module/widgets/purchase_tablet.dart';
import 'package:suraj_approval/ui/common/purchase_module/widgets/purchase_web.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../feature/controller/purchase_controllers/purchase_controller.dart';

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
