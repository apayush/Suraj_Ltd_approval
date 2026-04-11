import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';

import '../../../controller/ffd_controller.dart';
import '../hourly_module/hourly_report_widgets.dart'; // Re-use standard LabeledTextField & DatePickerField

class FFDEntryTabContent extends StatelessWidget {
  final FFDController controller;
  final int columns;

  const FFDEntryTabContent({
    super.key,
    required this.controller,
    this.columns = 1,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _EntryFormCard(controller: controller, columns: columns),
    );
  }
}

class _EntryFormCard extends StatelessWidget {
  final FFDController controller;
  final int columns;

  const _EntryFormCard({required this.controller, required this.columns});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark ? Colors.grey.shade900 : Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accent bar
          Container(
            height: 3,
            decoration: const BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title ──────────────────────────────────────────────
                  Row(
                    children: [
                       const Icon(
                        Icons.edit_note_outlined,
                        color: AppColors.blue,
                        size: 20,
                      ),
                      8.widthGap,
                      Text(
                        'New FFD Forming Production Entry',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // ── Fields ─────────────────────────────────────────────
                  _buildFields(context, isDark),

                  // ── Action Buttons ─────────────────────────────────────
                  24.heightGap,
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFields(BuildContext context, bool isDark) {
    if (columns >= 3) return _buildThreeColumnLayout(isDark);
    if (columns == 2) return _buildTwoColumnLayout(isDark);
    return _buildOneColumnLayout(isDark);
  }

  Widget _buildThreeColumnLayout(bool isDark) {
    return Column(
      children: [
        _row3([
          Obx(() => DatePickerField(
            label: 'Production Date',
            date: controller.entryDate.value,
            onChanged: controller.onEntryDateChanged,
          )),
          LabeledTextField(
            label: 'Elbow Quantity',
            controller: controller.elbowController,
            keyboardType: TextInputType.number,
            required: false,
          ),
          LabeledTextField(
            label: 'Tee Quantity',
            controller: controller.teeController,
            keyboardType: TextInputType.number,
            required: false,
          ),
        ]),
        14.heightGap,
        _row3([
          LabeledTextField(
            label: 'Reducer Quantity',
            controller: controller.reducerController,
            keyboardType: TextInputType.number,
            required: false,
          ),
          LabeledTextField(
            label: 'Cap Quantity',
            controller: controller.capController,
            keyboardType: TextInputType.number,
            required: false,
          ),
          const SizedBox(),
        ]),
      ],
    );
  }

  Widget _buildTwoColumnLayout(bool isDark) {
    return Column(
      children: [
        _row2([
          Obx(() => DatePickerField(
            label: 'Production Date',
            date: controller.entryDate.value,
            onChanged: controller.onEntryDateChanged,
          )),
          LabeledTextField(
            label: 'Elbow Quantity',
            controller: controller.elbowController,
            keyboardType: TextInputType.number,
            required: false,
          ),
        ]),
        14.heightGap,
        _row2([
          LabeledTextField(
            label: 'Tee Quantity',
            controller: controller.teeController,
            keyboardType: TextInputType.number,
            required: false,
          ),
          LabeledTextField(
            label: 'Reducer Quantity',
            controller: controller.reducerController,
            keyboardType: TextInputType.number,
            required: false,
          ),
        ]),
        14.heightGap,
        _row2([
          LabeledTextField(
            label: 'Cap Quantity',
            controller: controller.capController,
            keyboardType: TextInputType.number,
            required: false,
          ),
          const SizedBox(),
        ])
      ],
    );
  }

  Widget _buildOneColumnLayout(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => DatePickerField(
          label: 'Production Date',
          date: controller.entryDate.value,
          onChanged: controller.onEntryDateChanged,
        )),
        14.heightGap,
        LabeledTextField(
          label: 'Elbow Quantity',
          controller: controller.elbowController,
          keyboardType: TextInputType.number,
          required: false,
        ),
        14.heightGap,
        LabeledTextField(
          label: 'Tee Quantity',
          controller: controller.teeController,
          keyboardType: TextInputType.number,
          required: false,
        ),
        14.heightGap,
        LabeledTextField(
          label: 'Reducer Quantity',
          controller: controller.reducerController,
          keyboardType: TextInputType.number,
          required: false,
        ),
        14.heightGap,
        LabeledTextField(
          label: 'Cap Quantity',
          controller: controller.capController,
          keyboardType: TextInputType.number,
          required: false,
        ),
      ],
    );
  }

  Widget _row2(List<Widget> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(children.length, (i) {
        final isLast = i == children.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 14),
            child: children[i],
          ),
        );
      }),
    );
  }

  Widget _row3(List<Widget> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(children.length, (i) {
        final isLast = i == children.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 14),
            child: children[i],
          ),
        );
      }),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton(
          text: 'Clear',
          onPressed: controller.clearForm,
          isCancelButton: true,
          width: 90,
        ),
        10.widthGap,
        // Save button
        Obx(
          () => AppButton(
            text: 'Save',
            onPressed: () {
              if (!controller.isLoading.value) {
                controller.submitEntry();
              }
            },
            isLoading: controller.isLoading.value,
          ),
        ),
      ],
    );
  }
}
