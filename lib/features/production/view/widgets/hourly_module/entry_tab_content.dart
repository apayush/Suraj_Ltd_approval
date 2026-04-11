import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/features/production/controller/hourly_report_controller.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/core/widgets/loading_widget.dart';
import 'hourly_report_widgets.dart';

/// Shared entry form content — used by mobile, tablet, web layouts.
/// [columns] controls field layout: 1 = mobile, 2 = tablet, 3 = web.
class EntryTabContent extends StatelessWidget {
  final HourlyReportController controller;
  final int columns;

  const EntryTabContent({
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
  final HourlyReportController controller;
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
                        'New Production Entry',
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

  // ── Responsive field layout ────────────────────────────────────────────────
  Widget _buildFields(BuildContext context, bool isDark) {
    if (columns == 3) return _buildThreeColumnLayout(isDark);
    if (columns == 2) return _buildTwoColumnLayout(isDark);
    return _buildOneColumnLayout(isDark);
  }

  // 3-col: web
  Widget _buildThreeColumnLayout(bool isDark) {
    return Obx(() {
      final isExpansion = controller.selectedReportType.value
          .toLowerCase()
          .contains('expansion');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Department | Date | Time Slot
          _row3([
            _deptDropdown(isDark),
            Obx(
              () => DatePickerField(
                label: 'Date',
                date: controller.entryDate.value,
                onChanged: controller.onEntryDateChanged,
              ),
            ),
            TimeSlotDropdown(controller: controller),
          ]),
          if (isExpansion) ...[
            14.heightGap,
            // Row 2: DIA | Grade | Size Wise
            _row3([
              LabeledTextField(
                label: 'DIA Number',
                controller: controller.diaController,
                required: true,
                validator:
                    (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                hint: 'e.g. 123',
              ),
              LabeledTextField(
                label: 'Grade / Number',
                controller: controller.gradeController,
                required: true,
                validator:
                    (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                hint: 'e.g. 316L',
              ),
              LabeledTextField(
                label: 'Size Wise',
                controller: controller.sizeController,
                required: true,
                validator:
                    (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                hint: 'e.g. 138x9x152700',
              ),
            ]),
          ],
          14.heightGap,
          // Row 3: Target | Actual | empty
          _row3([
            LabeledTextField(
              label: 'Target (Per Hour)',
              controller: controller.targetController,
              keyboardType: TextInputType.number,
              required: true,
              validator:
                  (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            LabeledTextField(
              label: 'Actual (Per Hour)',
              controller: controller.actualController,
              keyboardType: TextInputType.number,
              required: true,
              validator:
                  (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(), // empty 3rd slot
          ]),
        ],
      );
    });
  }

  // 2-col: tablet
  Widget _buildTwoColumnLayout(bool isDark) {
    return Obx(() {
      final isExpansion = controller.selectedReportType.value
          .toLowerCase()
          .contains('expansion');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Department (full width)
          _deptDropdown(isDark),
          14.heightGap,
          // Date | Time Slot
          _row2([
            Obx(
              () => DatePickerField(
                label: 'Date',
                date: controller.entryDate.value,
                onChanged: controller.onEntryDateChanged,
              ),
            ),
            TimeSlotDropdown(controller: controller),
          ]),
          if (isExpansion) ...[
            14.heightGap,
            _row2([
              LabeledTextField(
                label: 'DIA Number',
                controller: controller.diaController,
                hint: 'e.g. 123',
              ),
              LabeledTextField(
                label: 'Grade / Number',
                controller: controller.gradeController,
                hint: 'e.g. 316L',
              ),
            ]),
            14.heightGap,
            LabeledTextField(
              label: 'Size Wise',
              controller: controller.sizeController,
              hint: 'e.g. 138x9x152700',
            ),
          ],
          14.heightGap,
          _row2([
            LabeledTextField(
              label: 'Target (Per Hour)',
              controller: controller.targetController,
              keyboardType: TextInputType.number,
              valueColor: AppColors.blue,
              required: true,
              validator:
                  (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            LabeledTextField(
              label: 'Actual (Per Hour)',
              controller: controller.actualController,
              keyboardType: TextInputType.number,
              valueColor: Colors.green,
              required: true,
              validator:
                  (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
          ]),
        ],
      );
    });
  }

  // 1-col: mobile
  Widget _buildOneColumnLayout(bool isDark) {
    return Obx(() {
      final isExpansion = controller.selectedReportType.value
          .toLowerCase()
          .contains('expansion');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _deptDropdown(isDark),
          14.heightGap,
          Obx(
            () => DatePickerField(
              label: 'Date',
              date: controller.entryDate.value,
              onChanged: controller.onEntryDateChanged,
            ),
          ),
          14.heightGap,
          TimeSlotDropdown(controller: controller),
          if (isExpansion) ...[
            14.heightGap,
            LabeledTextField(
              label: 'DIA Number',
              controller: controller.diaController,
              hint: 'e.g. 123',
            ),
            14.heightGap,
            LabeledTextField(
              label: 'Grade / Number',
              controller: controller.gradeController,
              hint: 'e.g. 316L',
            ),
            14.heightGap,
            LabeledTextField(
              label: 'Size Wise',
              controller: controller.sizeController,
              hint: 'e.g. 138x9x152700',
            ),
          ],
          14.heightGap,
          LabeledTextField(
            label: 'Target (Per Hour)',
            controller: controller.targetController,
            keyboardType: TextInputType.number,
            valueColor: AppColors.blue,
            required: true,
            validator:
                (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          14.heightGap,
          LabeledTextField(
            label: 'Actual (Per Hour)',
            controller: controller.actualController,
            keyboardType: TextInputType.number,
            valueColor: Colors.green,
            required: true,
            validator:
                (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
        ],
      );
    });
  }

  // ── Department dropdown ───────────────────────────────────────────────────
  Widget _deptDropdown(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Department', style: TextStyles.small(Get.context!)),
        8.heightGap,
        Obx(() {
          if (controller.isLoading.value) {
            return SizedBox(
              height: 48,
              width: double.infinity,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: LoadingIndicator(size: 24),
                ),
              ),
            );
          }

          // Safe lookup without throwing Bad State: No Element
          final dummy = DropDownResponse(value: '', text: 'Select Department');
          final matchingItem = controller.reportTypeDropdownList.firstWhere(
            (item) => item.value == controller.selectedReportType.value,
            orElse:
                () =>
                    controller.reportTypeDropdownList.isNotEmpty
                        ? controller.reportTypeDropdownList.first
                        : dummy,
          );

          return CustomDropdownSingle(
            width: double.infinity,
            hintText: 'Select Department',
            selectedItem: matchingItem.value == '' ? null : matchingItem,
            items: controller.reportTypeDropdownList,
            onChanged: (v) {
              if (v != null && v.value != null) {
                controller.onReportTypeChanged(v.value!);
              }
            },
          );
        }),
      ],
    );
  }

  // ── Row helpers ───────────────────────────────────────────────────────────
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

  // ── Buttons ───────────────────────────────────────────────────────────────
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
        // Save button
        Obx(
          () => AppButton(
            text: 'Save',
            onPressed: () {
              if (!controller.isLoading.value) {
                if (!controller.formKey.currentState!.validate())
                  return;
                controller.postHourlyProductionEntry();
              }
            },
            isLoading: controller.isLoading.value,
          ),
        ),
      ],
    );
  }
}
