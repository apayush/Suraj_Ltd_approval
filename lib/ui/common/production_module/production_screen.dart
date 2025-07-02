import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/ui/common/production_module/widgets/production_mobile.dart';
import 'package:suraj_approval/ui/common/production_module/widgets/production_tablet.dart';
import 'package:suraj_approval/ui/common/production_module/widgets/production_web.dart';

import '../../../core/widgets/loading_widget.dart';
import '../../../feature/controller/production_controllers/production_controller.dart';

class ProductionScreen extends StatelessWidget {
  ProductionScreen({super.key});

  final controller = ProductionController.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScreenTypeLayout.builder(
          mobile: (context) => ProductionMobile(),
          tablet: (context) => ProductionTablet(),
          desktop: (context) => ProductionWeb(),
        ),
        LoaderWidget(controller: controller)
      ]
    );
  }
}
