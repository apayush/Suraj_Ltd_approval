import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';
import '../../../core/constants/api_url.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/local_db.dart';
import '../../../core/utills/app_utills.dart';
import '../model/hourly_report_model.dart';
import '../utills/hourly_report_pdf_helper.dart';

class HourlyReportController extends GetxController {
  static HourlyReportController get instance => Get.find();

  // --- Inner Tab Index (0 = Data Entry, 1 = View Report) ---
  RxInt selectedInnerTab = 0.obs;

  // --- Loading State ---
  RxBool isLoading = false.obs;

  // --- Entries DB (in-memory, replace with real persistence as needed) ---
  RxList<HourlyEntry> entries = <HourlyEntry>[].obs;

  // ─── Entry Form State ───────────────────────────────────────────────────────
  RxString selectedReportType = ''.obs;
  Rx<DateTime> entryDate = DateTime.now().obs;
  RxString selectedTimeSlot = kShiftHours[0].obs;

  // ─── Dropdown Lists for UI ──────────────────────────────────────────────────
  Rxn<DropDownResponse> selectTimeSlotDropDown = Rxn<DropDownResponse>();
  Rxn<DropDownResponse> selectReportTypeDropDownFilter = Rxn<DropDownResponse>();

  RxList<DropDownResponse> timeSlotDropdownList = kShiftHours
      .map((slot) => DropDownResponse(value: slot, text: slot))
      .toList()
      .obs;

  RxList<DropDownResponse> reportTypeDropdownList = <DropDownResponse>[].obs;

  final TextEditingController diaController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  final TextEditingController actualController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ─── Report Filter State ─────────────────────────────────────────────────────
  Rx<DateTime> reportDate = DateTime.now().obs;
  RxString reportTypeFilter = ''.obs;

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
        return entries.firstWhere((e) => e.timeSlot == slot);
      } catch (_) {
        return null;
      }
    }).toList();
  }

  RxInt totalReportTarget = 0.obs;
  RxInt totalReportActual = 0.obs;

  // ─── Recent entries (last 5 sorted by id desc) ───────────────────────────────
  List<HourlyEntry> get recentEntries {
    final sorted = [...entries]..sort((a, b) => b.id.compareTo(a.id));
    return sorted.take(5).toList();
  }

  @override
  void onInit() {
    super.onInit();
    getDepartmentList();
    _preselectCurrentTimeSlot();

    // Sync filter default dropdown
    if (reportTypeDropdownList.isNotEmpty) {
      selectReportTypeDropDownFilter.value = reportTypeDropdownList.firstWhere(
              (item) => item.value == reportTypeFilter.value,
          orElse: () => reportTypeDropdownList.first);
    }
    getHourlyReportData();
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
        selectTimeSlotDropDown.value = timeSlotDropdownList.firstWhere((element) => element.value == slot, orElse: () => timeSlotDropdownList.first);
        return;
      }
    }
    // Fallback if not matched
    selectTimeSlotDropDown.value = timeSlotDropdownList.firstWhere((element) => element.value == selectedTimeSlot.value, orElse: () => timeSlotDropdownList.first);
  }

  // ─── Actions ─────────────────────────────────────────────────────────────────
  void onReportTypeChanged(String type) {
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

  void onReportTypeFilterChanged(String type) {
    reportTypeFilter.value = type;
  }

  // void submitEntry() {
  //   if (!formKey.currentState!.validate()) return;
  //
  //   isLoading.value = true;
  //   final entry = HourlyEntry(
  //     id: DateTime.now().millisecondsSinceEpoch,
  //     type: selectedReportType.value,
  //     date: entryDate.value,
  //     timeSlot: selectedTimeSlot.value,
  //     target: int.tryParse(targetController.text.trim()) ?? 0,
  //     actual: int.tryParse(actualController.text.trim()) ?? 0,
  //     dia: diaController.text.trim(),
  //     grade: gradeController.text.trim(),
  //     size: sizeController.text.trim(),
  //   );
  //
  //   entries.add(entry);
  //   _advanceTimeSlot();
  //   actualController.clear();
  //
  //   Get.snackbar(
  //     'Success',
  //     'Entry saved successfully!',
  //     snackPosition: SnackPosition.TOP,
  //     backgroundColor: Colors.green,
  //     colorText: Colors.white,
  //     duration: const Duration(seconds: 3),
  //     margin: const EdgeInsets.all(12),
  //     borderRadius: 8,
  //   );
  //
  //   isLoading.value = false;
  // }

  void deleteEntry(int id) {
    entries.removeWhere((e) => e.id == id);
  }

  void clearForm() {
    diaController.clear();
    gradeController.clear();
    sizeController.clear();
    targetController.clear();
    actualController.clear();
    if (reportTypeDropdownList.isNotEmpty) {
      selectedReportType.value = reportTypeDropdownList.first.value ?? '';
    }
    entryDate.value = DateTime.now();
    _preselectCurrentTimeSlot();
  }

  void _advanceTimeSlot() {
    final idx = kShiftHours.indexOf(selectedTimeSlot.value);
    if (idx != -1 && idx < kShiftHours.length - 1) {
      selectedTimeSlot.value = kShiftHours[idx + 1];
      selectTimeSlotDropDown.value = timeSlotDropdownList.firstWhere((element) => element.value == selectedTimeSlot.value, orElse: () => timeSlotDropdownList.first);
    }
  }

  // ! ====================== Get Departments ==================================
  Future<void> getDepartmentList() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(
        ApiUrl.getProductionRights,
        queryParams: {
          'mUser' : LocalDB.getUserModel()?.mUser ?? '',
          'MainMenu' : 'Production',
          'SubMenu' : 'Hourly Production Entry',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        if (data.isNotEmpty) {
          List<DropDownResponse> dynamicList = data.map((item) {
            final optionMenu = item['OptionMenu'].toString();
            return DropDownResponse(value: optionMenu, text: optionMenu);
          }).toList();
          
          if (dynamicList.isNotEmpty) {
            reportTypeDropdownList.value = dynamicList;

            // Update all reactive selected states to point to the first fetched item
            final firstItem = dynamicList.first;
            final firstString = firstItem.value ?? '';

            selectedReportType.value = firstString;
            reportTypeFilter.value = firstString;
            selectReportTypeDropDownFilter.value = firstItem;
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ! =================== Save Hourly Production Entry ========================
  Future<void> postHourlyProductionEntry() async {
    isLoading.value = true;
    final userModel = LocalDB.getUserModel();
    try {
      final response = await ApiService.postData(
        ApiUrl.submitHourlyProductionEntry,
        data: {
          'EntryDate' : DateFormat('yyyy-MM-dd').format(entryDate.value),
          'TimeSlot' : selectTimeSlotDropDown.value?.text,
          'ReportType': selectedReportType.value.contains(' ')
              ? selectedReportType.value.split(' ').skip(1).join(' ')
              : selectedReportType.value,
          'DIANumber' : diaController.text ?? '',
          'Grade' : gradeController.text ?? '',
          'SizeWise' : sizeController.text ?? '',
          'TargetPerHour' : int.tryParse(targetController.text) ?? '',
          'ActualPerHour' : int.tryParse(actualController.text) ?? '',
          'CreatedBy' : userModel?.mUser ?? '',
        },
      );
      if (response.statusCode == 200) {
        if (response.data['Success'] == true) {
          AppUtils.showSnackBar(response.data['Message']);
          clearForm();
        }
      } else {
        AppUtils.showSnackBar(
          'Something went wrong! Status Code : ${response.statusCode}',
          background: Colors.red,
        );
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ! =================== Get Hourly Report Data ==============================
  Future<void> getHourlyReportData() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(
        ApiUrl.getHourlyReportData,
        queryParams: {
          'ReportType': reportTypeFilter.value.contains(' ')
              ? reportTypeFilter.value.split(' ').skip(1).join(' ')
              : reportTypeFilter.value,
          'date': DateFormat('yyyy-MM-dd').format(reportDate.value),
        },
      );
      if (response.statusCode == 200) {
        if (response.data['Success'] == true) {
          final data = response.data['Data'];
          if (data != null && data['ReportDetails'] != null) {
            final reportDetails = data['ReportDetails'];
            final List<dynamic> entriesData = reportDetails['Entries'] ?? [];

            final String reportType = reportDetails['ReportType'] ??
                reportTypeFilter.value;
            final DateTime date = reportDate.value;

            final newList = entriesData
                .asMap()
                .entries
                .map((e) {
              return HourlyEntry.fromJson(e.value, reportType, date, e.key);
            }).toList();

            entries.clear();
            entries.addAll(newList);
            entries.refresh();

            totalReportTarget.value = reportDetails['TotalTarget'] ?? 0;
            totalReportActual.value = reportDetails['TotalActual'] ?? 0;
          }
        } else {
          entries.clear();
          AppUtils.showSnackBar(
            response.data['message'] ?? response.data['Message'] ?? 'Failed to fetch data',
            background: Colors.red,
          );
        }
      } else {
        AppUtils.showSnackBar(
          'Something went wrong! Status Code : ${response.statusCode}',
          background: Colors.red,
        );
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ! =================== Print Hourly Report =================================
  Future<void> printReport() async {
    if (entries.isEmpty) {
      AppUtils.showSnackBar('No data available to print', background: Colors.orange);
      return;
    }

    isLoading.value = true;
    try {
      final base64Pdf = await HourlyReportPdfHelper.generateHourlyReportPdf(
        reportType: reportTypeFilter.value,
        reportDate: reportDate.value,
        entries: reportRows,
        totalTarget: totalReportTarget.value,
        totalActual: totalReportActual.value,
      );

      final fileName = 'Hourly_Report_${reportTypeFilter.value}_${DateFormat('dd_MMM_yyyy').format(reportDate.value)}.pdf';
      await AppUtils.openPdf(base64Pdf, fileName: fileName);
    } catch (e) {
      print('Error generating PDF: $e');
      AppUtils.showSnackBar('Failed to generate PDF', background: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

}
