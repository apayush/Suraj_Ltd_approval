import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/features/hourly/model/hourly_report_model.dart';

class HourlyReportController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static HourlyReportController get instance => Get.find();

  // --- Tab Controller ---
  late TabController tabController;

  // --- Loading State ---
  RxBool isLoading = false.obs;

  // --- Entries DB (in-memory, replace with real persistence as needed) ---
  RxList<HourlyEntry> entries = <HourlyEntry>[].obs;

  // ─── Entry Form State ───────────────────────────────────────────────────────
  Rx<ReportType> selectedReportType = ReportType.expansion.obs;
  Rx<DateTime> entryDate = DateTime.now().obs;
  RxString selectedTimeSlot = kShiftHours[0].obs;

  final TextEditingController diaController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  final TextEditingController actualController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ─── Report Filter State ─────────────────────────────────────────────────────
  Rx<DateTime> reportDate = DateTime.now().obs;
  Rx<ReportType> reportTypeFilter = ReportType.expansion.obs;

  // ─── Computed: filtered entries for the report view ─────────────────────────
  List<HourlyEntry> get filteredEntries {
    return entries.where((e) {
      return e.type == reportTypeFilter.value &&
          _sameDay(e.date, reportDate.value);
    }).toList();
  }

  /// Returns entries for each shift hour slot (null if no data for that hour)
  List<HourlyEntry?> get reportRows {
    return kShiftHours.map((slot) {
      try {
        return filteredEntries.firstWhere((e) => e.timeSlot == slot);
      } catch (_) {
        return null;
      }
    }).toList();
  }

  int get reportTotalTarget =>
      filteredEntries.fold(0, (sum, e) => sum + e.target);

  int get reportTotalActual =>
      filteredEntries.fold(0, (sum, e) => sum + e.actual);

  // ─── Recent entries (last 5 sorted by id desc) ───────────────────────────────
  List<HourlyEntry> get recentEntries {
    final sorted = [...entries]..sort((a, b) => b.id.compareTo(a.id));
    return sorted.take(5).toList();
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    _preselectCurrentTimeSlot();
  }

  @override
  void onClose() {
    tabController.dispose();
    diaController.dispose();
    gradeController.dispose();
    sizeController.dispose();
    targetController.dispose();
    actualController.dispose();
    super.onClose();
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────
  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _preselectCurrentTimeSlot() {
    final now = TimeOfDay.now();
    // pick the slot whose hour matches current hour
    final currentHour = now.hour;
    for (final slot in kShiftHours) {
      final parts = slot.split(':');
      int h = int.tryParse(parts[0]) ?? 0;
      final isPM = slot.contains('PM');
      final isAM = slot.contains('AM');
      if (isPM && h != 12) h += 12;
      if (isAM && h == 12) h = 0;
      if (h == currentHour) {
        selectedTimeSlot.value = slot;
        return;
      }
    }
  }

  // ─── Actions ─────────────────────────────────────────────────────────────────
  void onReportTypeChanged(ReportType type) {
    selectedReportType.value = type;
  }

  void onEntryDateChanged(DateTime date) {
    entryDate.value = date;
  }

  void onTimeSlotChanged(String slot) {
    selectedTimeSlot.value = slot;
  }

  void onReportDateChanged(DateTime date) {
    reportDate.value = date;
  }

  void onReportTypeFilterChanged(ReportType type) {
    reportTypeFilter.value = type;
  }

  void submitEntry() {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    final entry = HourlyEntry(
      id: DateTime.now().millisecondsSinceEpoch,
      type: selectedReportType.value,
      date: entryDate.value,
      timeSlot: selectedTimeSlot.value,
      target: int.tryParse(targetController.text.trim()) ?? 0,
      actual: int.tryParse(actualController.text.trim()) ?? 0,
      dia: diaController.text.trim(),
      grade: gradeController.text.trim(),
      size: sizeController.text.trim(),
    );

    entries.add(entry);
    _advanceTimeSlot();
    actualController.clear();

    Get.snackbar(
      'Success',
      'Entry saved successfully!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );

    isLoading.value = false;
  }

  void deleteEntry(int id) {
    entries.removeWhere((e) => e.id == id);
  }

  void clearForm() {
    diaController.clear();
    gradeController.clear();
    sizeController.clear();
    targetController.clear();
    actualController.clear();
    selectedReportType.value = ReportType.expansion;
    entryDate.value = DateTime.now();
    _preselectCurrentTimeSlot();
  }

  void _advanceTimeSlot() {
    final idx = kShiftHours.indexOf(selectedTimeSlot.value);
    if (idx != -1 && idx < kShiftHours.length - 1) {
      selectedTimeSlot.value = kShiftHours[idx + 1];
    }
  }
}
