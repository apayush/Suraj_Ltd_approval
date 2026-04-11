import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/features/production/controller/ffd_controller.dart';
import '../hourly_module/hourly_report_widgets.dart';

/// Entry form for FFD Forming Production.
/// Allows entering daily quantities for Elbow, Tee, Reducer, and Cap.
///
/// [columns]: 1 = mobile | 2 = tablet | 3 = web
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
    if (columns == 1) {
      return _buildMobileLayout(context);
    } else {
      return _buildDesktopLayout(context);
    }
  }

  // ── MOBILE: stacked card layout ────────────────────────────────────────────
  Widget _buildMobileLayout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date picker
              Obx(() => DatePickerField(
                    label: 'Production Date',
                    date: controller.entryDate.value,
                    onChanged: controller.onEntryDateChanged,
                  )),
              16.heightGap,
              // Qty cards — 2×2 grid
              _buildQtyGrid(isDark),
            ],
          ),
        ),
        // Floating save button
        Positioned(
          right: 16,
          bottom: 16,
          child: Obx(() => FloatingActionButton.extended(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.submitEntry(),
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

  // ── TABLET & WEB: card with inline / row-based layout ─────────────────────
  Widget _buildDesktopLayout(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Blue top accent bar
                  Container(
                    height: 3,
                    decoration: const BoxDecoration(
                      color: AppColors.blue,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          'Add New Daily Production',
                          style: TextStyles.heading4(context),
                        ),
                        12.heightGap,
                        const Divider(),
                        12.heightGap,

                        // Date picker (row for web — 3 cols)
                        columns >= 3
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: 260,
                                    child: Obx(() => DatePickerField(
                                          label: 'Production Date',
                                          date: controller.entryDate.value,
                                          onChanged:
                                              controller.onEntryDateChanged,
                                        )),
                                  ),
                                ],
                              )
                            : Obx(() => DatePickerField(
                                  label: 'Production Date',
                                  date: controller.entryDate.value,
                                  onChanged: controller.onEntryDateChanged,
                                )),

                        20.heightGap,

                        // Qty fields: all 4 in a row for web, 2×2 for tablet
                        columns >= 3
                            ? _buildQtyRow4(isDark)
                            : _buildQtyGrid(isDark),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Bottom save bar
        _buildBottomBar(context, isDark),
      ],
    );
  }

  // ── 4 fields in a single row (Web) ─────────────────────────────────────────
  Widget _buildQtyRow4(bool isDark) {
    return Row(
      children: [
        Expanded(child: _QtyCard(label: 'ELBOW', controller: controller.elbowController, isDark: isDark)),
        12.widthGap,
        Expanded(child: _QtyCard(label: 'TEE', controller: controller.teeController, isDark: isDark)),
        12.widthGap,
        Expanded(child: _QtyCard(label: 'REDUCER', controller: controller.reducerController, isDark: isDark)),
        12.widthGap,
        Expanded(child: _QtyCard(label: 'CAP', controller: controller.capController, isDark: isDark)),
      ],
    );
  }

  // ── 2×2 grid (Mobile + Tablet) ─────────────────────────────────────────────
  Widget _buildQtyGrid(bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _QtyCard(label: 'ELBOW', controller: controller.elbowController, isDark: isDark)),
            12.widthGap,
            Expanded(child: _QtyCard(label: 'TEE', controller: controller.teeController, isDark: isDark)),
          ],
        ),
        12.heightGap,
        Row(
          children: [
            Expanded(child: _QtyCard(label: 'REDUCER', controller: controller.reducerController, isDark: isDark)),
            12.widthGap,
            Expanded(child: _QtyCard(label: 'CAP', controller: controller.capController, isDark: isDark)),
          ],
        ),
      ],
    );
  }

  // ── Bottom save bar (Tablet + Web) ─────────────────────────────────────────
  Widget _buildBottomBar(BuildContext context, bool isDark) {
    return Container(
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
                onPressed: () => controller.submitEntry(),
                isLoading: controller.isLoading.value,
              )),
        ],
      ),
    );
  }
}

// ── Qty input card widget ──────────────────────────────────────────────────────

class _QtyCard extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isDark;

  const _QtyCard({
    required this.label,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.blue.withOpacity(0.08)
            : AppColors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.blue.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: AppColors.blue,
            ),
          ),
          8.heightGap,
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              hintText: '0',
              hintStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide:
                    const BorderSide(color: AppColors.blue, width: 1.5),
              ),
              filled: true,
              fillColor: isDark ? Colors.grey.shade800 : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
