import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/features/production/controller/daywise_report_controller.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/core/widgets/loading_widget.dart';
import 'package:suraj_approval/features/production/view/widgets/hourly_module/hourly_report_widgets.dart';

class DaywiseEntryTabContent extends StatelessWidget {
  final DaywiseProductionController controller;
  final int columns;

  const DaywiseEntryTabContent({
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
  final DaywiseProductionController controller;
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
                  Row(
                    children: [
                      const Icon(Icons.edit_note_outlined, color: AppColors.blue, size: 20),
                      8.widthGap,
                      Text(
                        'New Daywise Production Entry',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildFields(context, isDark),
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
    if (columns == 3) return _buildThreeColumnLayout(isDark);
    if (columns == 2) return _buildTwoColumnLayout(isDark);
    return _buildOneColumnLayout(isDark);
  }

  // 3-col: web
  Widget _buildThreeColumnLayout(bool isDark) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row3([
            _deptDropdown(isDark),
            _shiftDropdown(isDark),
            DatePickerField(
              label: 'Date',
              date: controller.entryDate.value,
              onChanged: controller.onEntryDateChanged,
            ),
          ]),
          14.heightGap,
          _row3([
            LabeledTextField(
              label: 'TARGET',
              controller: controller.targetController,
              keyboardType: TextInputType.number,
              hint: 'e.g. 360',
            ),
            LabeledTextField(
              label: 'NOS',
              controller: controller.nosController,
              keyboardType: TextInputType.number,
              required: true,
              hint: 'Prod Qty',
            ),
            LabeledTextField(
              label: 'KGS',
              controller: controller.kgsController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              required: true,
              hint: 'Weight',
            ),
          ]),
          14.heightGap,
          _row3([
            LabeledTextField(
              label: 'MTR',
              controller: controller.mtrController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              hint: 'Meter',
            ),
            const SizedBox(),
            const SizedBox(),
          ]),
        ],
      );
    });
  }

  // 2-col: tablet
  Widget _buildTwoColumnLayout(bool isDark) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row2([
            _deptDropdown(isDark),
            _shiftDropdown(isDark),
          ]),
          14.heightGap,
          _row2([
            DatePickerField(
              label: 'Date',
              date: controller.entryDate.value,
              onChanged: controller.onEntryDateChanged,
            ),
            LabeledTextField(
              label: 'TARGET',
              controller: controller.targetController,
              keyboardType: TextInputType.number,
            ),
          ]),
          14.heightGap,
          _row2([
            LabeledTextField(
              label: 'NOS',
              controller: controller.nosController,
              keyboardType: TextInputType.number,
              required: true,
            ),
            LabeledTextField(
              label: 'KGS',
              controller: controller.kgsController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              required: true,
            ),
          ]),
          14.heightGap,
          _row2([
            LabeledTextField(
              label: 'MTR',
              controller: controller.mtrController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              // required: true,
            ),
            const SizedBox(),
          ]),
        ],
      );
    });
  }

  Widget _buildOneColumnLayout(bool isDark) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _deptDropdown(isDark),
          14.heightGap,
          _shiftDropdown(isDark),
          14.heightGap,
          DatePickerField(
            label: 'Date',
            date: controller.entryDate.value,
            onChanged: controller.onEntryDateChanged,
          ),
          14.heightGap,
          LabeledTextField(
            label: 'TARGET',
            controller: controller.targetController,
            keyboardType: TextInputType.number,
            hint: 'e.g. 360',
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          14.heightGap,
          LabeledTextField(
            label: 'NOS',
            controller: controller.nosController,
            keyboardType: TextInputType.number,
            required: true,
            hint: 'Prod Qty',
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          14.heightGap,
          LabeledTextField(
            label: 'KGS',
            controller: controller.kgsController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            required: true,
            hint: 'Weight',
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          14.heightGap,
          LabeledTextField(
            label: 'MTR',
            controller: controller.mtrController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            // required: true,
            hint: 'Meter',
            // validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
        ],
      );
    });
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

  Widget _deptDropdown(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Select Department', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
        8.heightGap,
        Obx(() {
          if (controller.isLoading.value && controller.deptDropdownList.isEmpty) {
            return const Center(child: LoadingIndicator(size: 24));
          }

          final dummy = DropDownResponse(value: '', text: 'Select Department');
          final matchingItem = controller.deptDropdownList.firstWhere(
            (item) => item.value == controller.selectedDept.value,
            orElse: () => controller.deptDropdownList.isNotEmpty ? controller.deptDropdownList.first : dummy,
          );

          return CustomDropdownSingle(
            width: double.infinity,
            hintText: 'Select Department',
            selectedItem: matchingItem.value == '' ? null : matchingItem,
            items: controller.deptDropdownList,
            onChanged: (v) {
              if (v?.value != null) controller.onDeptChanged(v!.value!);
            },
          );
        }),
      ],
    );
  }

  Widget _shiftDropdown(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Select Shift', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
        8.heightGap,
        Obx(() {
          final dummy = DropDownResponse(value: '', text: 'Select Shift');
          final matchingItem = controller.shiftDropdownList.firstWhere(
            (item) => item.value == controller.selectedShift.value,
            orElse: () => dummy,
          );

          return CustomDropdownSingle(
            width: double.infinity,
            hintText: 'Select Shift',
            selectedItem: matchingItem.value == '' ? null : matchingItem,
            items: controller.shiftDropdownList,
            onChanged: (v) {
              if (v?.value != null) controller.selectedShift.value = v?.value ?? '';
            },
          );
        }),
      ],
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
        ),
        10.widthGap,
        Obx(() => AppButton(
          text: 'Save',
          onPressed: () {
            if (!controller.isLoading.value) {
              if (controller.formKey.currentState!.validate()) {
                controller.postDaywiseProductionEntry();
              }
            }
          },
          isLoading: controller.isLoading.value,
        )),
      ],
    );
  }
}
