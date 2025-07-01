import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/ui/common/purchase_module/widgets/purchase_mobile.dart';
import 'package:suraj_approval/ui/common/purchase_module/widgets/purchase_tablet.dart';
import 'package:suraj_approval/ui/common/purchase_module/widgets/purchase_web.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => PurchaseMobile(),
      tablet: (context) => PurchaseTablet(),
      desktop: (context) => PurchaseWeb(),
    );
  }
}
