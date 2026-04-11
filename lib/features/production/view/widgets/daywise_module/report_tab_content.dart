import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/features/production/controller/daywise_report_controller.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../hourly_module/hourly_report_widgets.dart';
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
                        compact: compact,
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
    if (compact) {
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
              return Flexible(
                child: AppButton(
                  text: 'Filter • $dept • $start to $end',
                  onPressed: () => _showFilterDialog(context),
                  backgroundColor: AppColors.blue,
                ),
              );
            }),
            const Spacer(),
            // Print button
            AppButton(
              text: 'Print',
              onPressed: () {
                controller.printReport();
              },
            ),
          ],
        ),
      );
    } else {
      // Desktop / Tablet Inline
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Department', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Obx(() {
                    final dummy = DropDownResponse(value: '', text: 'Select Department');
                    final matchingItem = controller.deptDropdownList.firstWhere(
                      (item) => item.value == controller.reportDeptFilter.value,
                      orElse: () => controller.deptDropdownList.isNotEmpty ? controller.deptDropdownList.first : dummy,
                    );
                    return CustomDropdownSingle(
                      width: double.infinity,
                      hintText: 'Select Department',
                      selectedItem: matchingItem.value == '' ? null : matchingItem,
                      items: controller.deptDropdownList,
                      onChanged: (v) {
                        if (v?.value != null) {
                          controller.reportDeptFilter.value = v!.value!;
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(() => DatePickerField(
                    label: 'Start Date',
                    date: controller.startDate.value,
                    onChanged: (d) {
                      controller.startDate.value = d;
                    },
                  )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() => DatePickerField(
                    label: 'End Date',
                    date: controller.endDate.value,
                    onChanged: (d) {
                      controller.endDate.value = d;
                    },
                  )),
            ),
            const SizedBox(width: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  AppButton(
                    text: 'Search',
                    onPressed: () => controller.getDaywiseReportData(),
                    backgroundColor: AppColors.blue,
                  ),
                  const SizedBox(width: 8),
                  AppButton(
                    text: 'Print',
                    onPressed: () => controller.printReport(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showFilterDialog(BuildContext context) {
    DaywiseFilterDialog.show(context, controller);
  }
}
