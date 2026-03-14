import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/widgets/loading_widget.dart';
import '../controller/hourly_report_controller.dart';
import 'widgets/hourly_report_mobile.dart';
import 'widgets/hourly_report_tablet.dart';
import 'widgets/hourly_report_web.dart';

class HourlyReportScreen extends StatelessWidget {
  HourlyReportScreen({super.key});

  final controller = HourlyReportController.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScreenTypeLayout.builder(
          mobile: (context) => HourlyReportMobile(),
          tablet: (context) => HourlyReportTablet(),
          desktop: (context) => HourlyReportWeb(),
        ),
        LoaderWidget(controller: controller),
      ],
    );
  }
}
