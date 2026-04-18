import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';
import '../../../core/constants/api_url.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/local_db.dart';
import '../../../core/utills/app_utills.dart';
import '../model/daywise_report_model.dart';

import 'package:suraj_approval/features/production/utills/daywise_report_pdf_helper.dart';

class DaywiseProductionController extends GetxController {
  static DaywiseProductionController get instance => Get.find();

  // --- Inner Tab Index (0 = Data Entry, 1 = View Report) ---
  RxInt selectedInnerTab = 0.obs;

  // --- Loading State ---
  RxBool isLoading = false.obs;

  // --- Entries DB ---
  RxList<DaywiseEntry> entries = <DaywiseEntry>[].obs;

  // ─── Entry Form State ───────────────────────────────────────────────────────
  RxString selectedDept = ''.obs;
  Rx<DateTime> entryDate = DateTime.now().obs;
  
  final TextEditingController targetController = TextEditingController();
  final TextEditingController nosController = TextEditingController();
  final TextEditingController kgsController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ─── Dropdown Lists for UI ──────────────────────────────────────────────────
  RxList<DropDownResponse> deptDropdownList = <DropDownResponse>[].obs;
  Rxn<DropDownResponse> selectDeptDropDownFilter = Rxn<DropDownResponse>();

  // ─── Report Filter State ─────────────────────────────────────────────────────
  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  RxString reportDeptFilter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Set default dates for report
    final now = DateTime.now();
    startDate.value = DateTime(now.year, now.month, 1);
    endDate.value = now;

    getDepartmentList();
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────
  
  /// Determines if the selected department is "Full" (Target + Nos + Kgs)
  /// or "Simple" (Target + Nos only).
  bool get isFullType {
    final dept = selectedDept.value.toLowerCase();
    // Simplified logic based on provided HTML configuration:
    // Expansion, Polishing, Peeling, Annealing, Straightening are SIMPLE.
    if (dept.contains('expansion') ||
        dept.contains('polishing') ||
        dept.contains('peeling') ||
        dept.contains('annealing') ||
        dept.contains('straightening')) {
      return false;
    }
    return true;
  }
  
  bool get isFullTypeFilter {
    final dept = reportDeptFilter.value.toLowerCase();
    if (dept.contains('expansion') ||
        dept.contains('polishing') ||
        dept.contains('peeling') ||
        dept.contains('annealing') ||
        dept.contains('straightening')) {
      return false;
    }
    return true;
  }

  // ─── Actions ─────────────────────────────────────────────────────────────────
  void onDeptChanged(String dept) {
    selectedDept.value = dept;
  }

  void onEntryDateChanged(DateTime date) {
    entryDate.value = date;
  }

  void onStartDateChanged(DateTime date) {
    startDate.value = date;
  }

  void onEndDateChanged(DateTime date) {
    endDate.value = date;
  }

  void onReportDeptFilterChanged(String dept) {
    reportDeptFilter.value = dept;
  }

  void clearForm() {
    targetController.clear();
    nosController.clear();
    kgsController.clear();
    entryDate.value = DateTime.now();
    if (deptDropdownList.isNotEmpty) {
      selectedDept.value = deptDropdownList.first.value ?? '';
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
          'SubMenu' : 'MPD/SPD Daywise Entry',
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
            deptDropdownList.value = dynamicList;

            final firstItem = dynamicList.first;
            final firstString = firstItem.value ?? '';

            selectedDept.value = firstString;
            reportDeptFilter.value = firstString;
            selectDeptDropDownFilter.value = firstItem;
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ! =================== Save Daywise Production Entry ========================
  Future<void> postDaywiseProductionEntry() async {
    isLoading.value = true;
    final userModel = LocalDB.getUserModel();
    try {
      // Logic for ReportType similar to Hourly: splitting name if necessary
      final deptName = selectedDept.value.contains(' ')
          ? selectedDept.value.split(' ').skip(1).join(' ')
          : selectedDept.value;
          
      final response = await ApiService.postData(
        ApiUrl.submitDaywiseProductionEntry,
        data: {
          'EntryDate' : DateFormat('yyyy-MM-dd').format(entryDate.value),
          'DeptName': deptName ?? '',
          'Target' : int.tryParse(targetController.text) ?? 0,
          'Nos' : int.tryParse(nosController.text) ?? 0,
          'Kgs' : double.tryParse(kgsController.text) ?? 0,
          'UserID' : userModel?.mUser ?? '',
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

  // ! =================== Get Daywise Report Data ==============================
  Future<void> getDaywiseReportData() async {
    isLoading.value = true;
    try {
      final deptName = reportDeptFilter.value.contains(' ')
          ? reportDeptFilter.value.split(' ').skip(1).join(' ')
          : reportDeptFilter.value;

      final response = await ApiService.getData(
        ApiUrl.getDaywiseReport,
        queryParams: {
          'DeptName': deptName,
          'StartDate': DateFormat('yyyy-MM-dd').format(startDate.value),
          'EndDate': DateFormat('yyyy-MM-dd').format(endDate.value),
        },
      );
      if (response.statusCode == 200) {
        final success = response.data['success'] ?? response.data['Success'] ?? false;
        if (success) {
          final List<dynamic> entriesData = response.data['data'] ?? response.data['Data'] ?? [];
          
          final newList = entriesData.asMap().entries.map((e) {
            return DaywiseEntry.fromJson(e.value, reportDeptFilter.value, e.key);
          }).toList();

          entries.assignAll(newList);
        } else {
          entries.clear();
          AppUtils.showSnackBar(
            response.data['message'] ?? response.data['Message'] ?? 'Failed to fetch data',
            background: Colors.red,
          );
        }
      } else {
        entries.clear();
      }
    } catch (e) {
      entries.clear();
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ! =================== Print Daywise Report ================================
  Future<void> printReport() async {
    if (entries.isEmpty) {
      AppUtils.showSnackBar('No data available to print', background: Colors.orange);
      return;
    }

    isLoading.value = true;
    try {
      final base64Pdf = await DaywiseReportPdfHelper.generateDaywiseReportPdf(
        reportType: reportDeptFilter.value,
        startDate: startDate.value,
        endDate: endDate.value,
        entries: entries,
        isFullType: isFullTypeFilter,
      );

      final dateStr = '${DateFormat('dd_MMM').format(startDate.value)}_to_${DateFormat('dd_MMM_yyyy').format(endDate.value)}';
      final fileName = 'Daywise_Report_${reportDeptFilter.value}_$dateStr.pdf';
      await AppUtils.openPdf(base64Pdf, fileName: fileName);
    } catch (e) {
      print('Error generating PDF: $e');
      AppUtils.showSnackBar('Failed to generate PDF', background: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}
