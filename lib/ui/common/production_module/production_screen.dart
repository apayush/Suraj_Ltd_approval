import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/ui/common/production_module/widgets/production_mobile.dart';
import 'package:suraj_approval/ui/common/production_module/widgets/production_tablet.dart';
import 'package:suraj_approval/ui/common/production_module/widgets/production_web.dart';

class ProductionScreen extends StatelessWidget {
  const ProductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => ProductionMobile(),
      tablet: (context) => ProductionTablet(),
      desktop: (context) => ProductionWeb(),
    );
  }
}
