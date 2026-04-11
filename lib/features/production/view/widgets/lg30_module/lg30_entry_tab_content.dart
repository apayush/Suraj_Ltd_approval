import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/core/widgets/loading_widget.dart';
import '../../../controller/lg30_pilger_controller.dart';
import '../hourly_module/hourly_report_widgets.dart';

/// Entry form for LG30 Pilger production.
/// Shows department dropdown, date picker, and machine grid.
class LG30EntryTabContent extends StatelessWidget {
  final LG30PilgerController controller;
  final int columns;

  const LG30EntryTabContent({
    super.key,
    required this.controller,
    this.columns = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Filter Card: Department + Date + Reset ─────────────────────────
        if (columns > 1) _buildFilterCard(context),
        // ── Machine Grid ──────────────────────────────────────────────────
        Expanded(
          child: Obx(() {
            if (controller.isMachinesLoading.value) {
              return const Center(child: LoadingIndicator());
            }
            if (controller.machineEntries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.precision_manufacturing_outlined,
                        size: 48, color: Colors.grey.shade400),
                    8.heightGap,
                    Text(
                      'No machines loaded.\nSelect a department to load machines.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              );
            }
            return _buildMachineGrid(context);
          }),
        ),
      ],
    );
  }

  // ── Filter Card ──────────────────────────────────────────────────────────
  Widget _buildFilterCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: columns >= 3
          ? _buildFilterRow3(isDark)
          : columns == 2
              ? _buildFilterRow2(isDark)
              : _buildFilterColumn(isDark),
    );
  }

  Widget _buildFilterRow3(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(flex: 3, child: _deptDropdown(isDark)),
        14.widthGap,
        Expanded(
          flex: 2,
          child: Obx(() => DatePickerField(
                label: 'Date',
                date: controller.entryDate.value,
                onChanged: controller.onEntryDateChanged,
              )),
        ),
        14.widthGap,
        SizedBox(
          width: 100,
          child: AppButton(
            text: 'Reset',
            onPressed: controller.clearForm,
            isCancelButton: true,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterRow2(bool isDark) {
    return Column(
      children: [
        _deptDropdown(isDark),
        10.heightGap,
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Obx(() => DatePickerField(
                    label: 'Date',
                    date: controller.entryDate.value,
                    onChanged: controller.onEntryDateChanged,
                  )),
            ),
            14.widthGap,
            SizedBox(
              width: 100,
              child: AppButton(
                text: 'Reset',
                onPressed: controller.clearForm,
                isCancelButton: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterColumn(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _deptDropdown(isDark),
        10.heightGap,
        Row(
          children: [
            Expanded(
              child: Obx(() => DatePickerField(
                    label: 'Date',
                    date: controller.entryDate.value,
                    onChanged: controller.onEntryDateChanged,
                  )),
            ),
            14.widthGap,
            SizedBox(
              width: 90,
              child: AppButton(
                text: 'Reset',
                onPressed: controller.clearForm,
                isCancelButton: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _deptDropdown(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Select Department',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600)),
        8.heightGap,
        Obx(() {
          if (controller.isLoading.value && controller.deptDropdownList.isEmpty) {
            return const Center(child: LoadingIndicator(size: 24));
          }

          final dummy = DropDownResponse(value: '', text: 'Select Department');
          final matchingItem = controller.deptDropdownList.firstWhere(
            (item) => item.value == controller.selectedDept.value,
            orElse: () => controller.deptDropdownList.isNotEmpty
                ? controller.deptDropdownList.first
                : dummy,
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

  // ── Machine Grid ─────────────────────────────────────────────────────────
  Widget _buildMachineGrid(BuildContext context) {
    if (columns == 1) {
      return _buildMobileCards(context);
    }
    return _buildDesktopTable(context);
  }

  // ── Mobile: Card-per-machine ─────────────────────────────────────────────
  Widget _buildMobileCards(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
          itemCount: controller.machineEntries.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildFilterCard(context),
              );
            }
            final entry = controller.machineEntries[index - 1];
            return Card(
              color: isDark ? Colors.grey.shade900 : Colors.white,
              elevation: 1,
              margin: const EdgeInsets.only(top: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Machine Name Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        entry.machineName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                    12.heightGap,
                    // NOS + KGS in a row
                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            label: 'NOS',
                            controller: entry.nosController,
                            keyboardType: TextInputType.number,
                            hint: '0',
                          ),
                        ),
                        12.widthGap,
                        Expanded(
                          child: LabeledTextField(
                            label: 'KGS',
                            controller: entry.kgsController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            hint: '0',
                          ),
                        ),
                      ],
                    ),
                    10.heightGap,
                    LabeledTextField(
                      label: 'Maintenance',
                      controller: entry.maintController,
                      hint: '',
                    ),
                    10.heightGap,
                    LabeledTextField(
                      label: 'RM Issue',
                      controller: entry.rmController,
                      hint: '',
                    ),
                    10.heightGap,
                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            label: 'Manpower',
                            controller: entry.manController,
                            hint: '',
                          ),
                        ),
                        12.widthGap,
                        Expanded(
                          child: LabeledTextField(
                            label: 'Other',
                            controller: entry.otherController,
                            hint: '',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // Floating save button
        Positioned(
          right: 16,
          bottom: 16,
          child: Obx(() => FloatingActionButton.extended(
                onPressed:
                    controller.isLoading.value ? null : () => controller.submitEntries(),
                backgroundColor: AppColors.blue,
                icon: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save, color: Colors.white),
                label: Text(
                  controller.isLoading.value ? 'Saving...' : 'Save Entry',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )),
        ),
      ],
    );
  }

  // ── Desktop/Tablet: Table layout ─────────────────────────────────────────
  Widget _buildDesktopTable(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: isDark ? Colors.grey.shade900 : Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Container(
                    height: 3,
                    decoration: const BoxDecoration(
                      color: AppColors.blue,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2.5),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1.5),
                        4: FlexColumnWidth(1.5),
                        5: FlexColumnWidth(1.5),
                        6: FlexColumnWidth(1.5),
                      },
                      border: TableBorder.all(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      children: [
                        // Header row
                        TableRow(
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey.shade800
                                : const Color(0xFFE9ECEF),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6)),
                          ),
                          children: const [
                            _TableHeader('MACHINE NAME'),
                            _TableHeader('NOS'),
                            _TableHeader('KGS'),
                            _TableHeader('MAINTENANCE'),
                            _TableHeader('RM ISSUE'),
                            _TableHeader('MANPOWER'),
                            _TableHeader('OTHER'),
                          ],
                        ),
                        // Data rows
                        ...controller.machineEntries.map((entry) {
                          return TableRow(
                            children: [
                              _MachineNameCell(entry.machineName),
                              _InputCell(
                                  controller: entry.nosController,
                                  keyboardType: TextInputType.number),
                              _InputCell(
                                  controller: entry.kgsController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true)),
                              _InputCell(controller: entry.maintController),
                              _InputCell(controller: entry.rmController),
                              _InputCell(controller: entry.manController),
                              _InputCell(controller: entry.otherController),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Bottom save bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade900 : Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                text: 'Clear',
                onPressed: controller.clearForm,
                isCancelButton: true,
                width: 90,
              ),
              10.widthGap,
              Obx(() => AppButton(
                    text: 'Save Entry',
                    onPressed: () => controller.submitEntries(),
                    isLoading: controller.isLoading.value,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Small helper widgets ──────────────────────────────────────────────────────

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
      ),
    );
  }
}

class _MachineNameCell extends StatelessWidget {
  final String name;
  const _MachineNameCell(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      color: Colors.grey.shade50,
      child: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}

class _InputCell extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _InputCell({
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          hintText: '',
        ),
      ),
    );
  }
}
