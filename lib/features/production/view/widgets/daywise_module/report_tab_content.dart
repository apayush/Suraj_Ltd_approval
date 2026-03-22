import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/features/production/controller/daywise_report_controller.dart';
import 'daywise_report_widgets.dart';

import 'package:suraj_approval/core/widgets/loading_widget.dart';
import 'package:suraj_approval/core/widgets/no_data_found.dart';

class DaywiseReportTabContent extends StatelessWidget {
  final DaywiseProductionController controller;
  final bool compact;

  const DaywiseReportTabContent({
    super.key,
    required this.controller,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter bar on top
        _buildFilterBar(context),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: LoadingIndicator(),
                    ));
                  }
                  if (controller.entries.isEmpty) {
                    return const NoDataFound();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DaywiseReportTable(
                        entries: controller.entries,
                        isFullType: controller.isFullTypeFilter,
                        controller: controller,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          // Filter Status Button on left
          Obx(() {
            final dept = controller.reportDeptFilter.value;
            final start = DateFormat('dd/MM/yy').format(controller.startDate.value);
            final end = DateFormat('dd/MM/yy').format(controller.endDate.value);
            return AppButton(
              text: '$dept • $start to $end',
              onPressed: () => _showFilterDialog(context),
              backgroundColor: AppColors.blue,
            );
          }),
          const Spacer(),
          // Print button
          AppButton(
            text: 'Print',
            onPressed: () {
              controller.printReport();
            },
            width: 80,
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    DaywiseFilterDialog.show(context, controller);
  }
}
