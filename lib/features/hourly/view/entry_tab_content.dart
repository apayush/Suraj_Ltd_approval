import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/features/hourly/controller/hourly_report_controller.dart';
import 'package:suraj_approval/features/hourly/model/hourly_report_model.dart';
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
                      const SizedBox(width: 8),
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
                  const SizedBox(height: 24),
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
      final isExpansion =
          controller.selectedReportType.value == ReportType.expansion;
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
            Obx(
              () => TimeSlotDropdown(
                value: controller.selectedTimeSlot.value,
                onChanged: controller.onTimeSlotChanged,
              ),
            ),
          ]),
          if (isExpansion) ...[
            const SizedBox(height: 14),
            // Row 2: DIA | Grade | Size Wise
            _row3([
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
              LabeledTextField(
                label: 'Size Wise',
                controller: controller.sizeController,
                hint: 'e.g. 138x9x152700',
              ),
            ]),
          ],
          const SizedBox(height: 14),
          // Row 3: Target | Actual | empty
          _row3([
            LabeledTextField(
              label: 'Target (Per Hour)',
              controller: controller.targetController,
              keyboardType: TextInputType.number,
              valueColor: AppColors.blue,
              required: true,
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            LabeledTextField(
              label: 'Actual (Per Hour)',
              controller: controller.actualController,
              keyboardType: TextInputType.number,
              valueColor: Colors.green,
              required: true,
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
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
      final isExpansion =
          controller.selectedReportType.value == ReportType.expansion;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Department (full width)
          _deptDropdown(isDark),
          const SizedBox(height: 14),
          // Date | Time Slot
          _row2([
            Obx(
              () => DatePickerField(
                label: 'Date',
                date: controller.entryDate.value,
                onChanged: controller.onEntryDateChanged,
              ),
            ),
            Obx(
              () => TimeSlotDropdown(
                value: controller.selectedTimeSlot.value,
                onChanged: controller.onTimeSlotChanged,
              ),
            ),
          ]),
          if (isExpansion) ...[
            const SizedBox(height: 14),
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
            const SizedBox(height: 14),
            LabeledTextField(
              label: 'Size Wise',
              controller: controller.sizeController,
              hint: 'e.g. 138x9x152700',
            ),
          ],
          const SizedBox(height: 14),
          _row2([
            LabeledTextField(
              label: 'Target (Per Hour)',
              controller: controller.targetController,
              keyboardType: TextInputType.number,
              valueColor: AppColors.blue,
              required: true,
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            LabeledTextField(
              label: 'Actual (Per Hour)',
              controller: controller.actualController,
              keyboardType: TextInputType.number,
              valueColor: Colors.green,
              required: true,
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
          ]),
        ],
      );
    });
  }

  // 1-col: mobile
  Widget _buildOneColumnLayout(bool isDark) {
    return Obx(() {
      final isExpansion =
          controller.selectedReportType.value == ReportType.expansion;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _deptDropdown(isDark),
          const SizedBox(height: 14),
          Obx(
            () => DatePickerField(
              label: 'Date',
              date: controller.entryDate.value,
              onChanged: controller.onEntryDateChanged,
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => TimeSlotDropdown(
              value: controller.selectedTimeSlot.value,
              onChanged: controller.onTimeSlotChanged,
            ),
          ),
          if (isExpansion) ...[
            const SizedBox(height: 14),
            LabeledTextField(
              label: 'DIA Number',
              controller: controller.diaController,
              hint: 'e.g. 123',
            ),
            const SizedBox(height: 14),
            LabeledTextField(
              label: 'Grade / Number',
              controller: controller.gradeController,
              hint: 'e.g. 316L',
            ),
            const SizedBox(height: 14),
            LabeledTextField(
              label: 'Size Wise',
              controller: controller.sizeController,
              hint: 'e.g. 138x9x152700',
            ),
          ],
          const SizedBox(height: 14),
          LabeledTextField(
            label: 'Target (Per Hour)',
            controller: controller.targetController,
            keyboardType: TextInputType.number,
            valueColor: AppColors.blue,
            required: true,
            validator:
                (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 14),
          LabeledTextField(
            label: 'Actual (Per Hour)',
            controller: controller.actualController,
            keyboardType: TextInputType.number,
            valueColor: Colors.green,
            required: true,
            validator:
                (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
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
        Text(
          'Department',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => DropdownButtonFormField<ReportType>(
            value: controller.selectedReportType.value,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              prefixIcon: const Icon(
                Icons.factory_outlined,
                size: 18,
                color: AppColors.blue,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            items: ReportType.values
                .map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(
                      t.label,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) controller.onReportTypeChanged(v);
            },
          ),
        ),
      ],
    );
  }

  // ── Row helpers ───────────────────────────────────────────────────────────
  Widget _row2(List<Widget> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .map(
            (w) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: w,
              ),
            ),
          )
          .toList()
        ..last = Expanded(child: children.last),
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
        // Clear button
        OutlinedButton.icon(
          onPressed: controller.clearForm,
          icon: const Icon(Icons.refresh_outlined, size: 15),
          label: const Text('Clear'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            side: BorderSide(color: Colors.grey.shade400),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Save button
        Obx(
          () => ElevatedButton.icon(
            onPressed:
                controller.isLoading.value ? null : controller.submitEntry,
            icon:
                controller.isLoading.value
                    ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Icon(Icons.save_outlined, size: 15),
            label: const Text('Save Entry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
