import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';
import '../../../core/constants/api_url.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/local_db.dart';
import '../../../core/utills/app_utills.dart';
import '../model/lg30_pilger_model.dart';
import '../utills/lg30_report_pdf_helper.dart';

class LG30PilgerController extends GetxController {
  static LG30PilgerController get instance => Get.find();

  // --- Inner Tab Index (0 = Data Entry, 1 = View Report) ---
  RxInt selectedInnerTab = 0.obs;

  // --- Loading State ---
  RxBool isLoading = false.obs;
  RxBool isMachinesLoading = false.obs;

  // ─── Entry Form State ───────────────────────────────────────────────────────
  RxString selectedDept = ''.obs;
  Rx<DateTime> entryDate = DateTime.now().obs;

  // ─── Machine entries (entry form) ───────────────────────────────────────────
  RxList<LG30MachineEntry> machineEntries = <LG30MachineEntry>[].obs;

  // ─── Report entries (report view) ───────────────────────────────────────────
  RxList<LG30ReportEntry> reportEntries = <LG30ReportEntry>[].obs;
  RxInt totalReportNos = 0.obs;
  RxDouble totalReportKgs = 0.0.obs;
  RxDouble totalReportMtr = 0.0.obs;

  // ─── Dropdown Lists for UI ──────────────────────────────────────────────────
  RxList<DropDownResponse> deptDropdownList = <DropDownResponse>[].obs;
  Rxn<DropDownResponse> selectDeptDropDown = Rxn<DropDownResponse>();

  final List<DropDownResponse> shiftDropdownList = [
    DropDownResponse(value: '1st Shift', text: '1st Shift'),
    DropDownResponse(value: '2nd Shift', text: '2nd Shift'),
    DropDownResponse(value: '3rd Shift', text: '3rd Shift'),
  ];

  // ─── Report Filter State ─────────────────────────────────────────────────────
  Rx<DateTime> reportDate = DateTime.now().obs;
  RxString reportDeptFilter = ''.obs;
  Rxn<DropDownResponse> selectReportDeptDropDown = Rxn<DropDownResponse>();

  @override
  void onInit() {
    super.onInit();
    getDepartmentList();
  }

  @override
  void onClose() {
    // Dispose all machine entry controllers
    for (var entry in machineEntries) {
      entry.dispose();
    }
    super.onClose();
  }

  // ─── Actions ─────────────────────────────────────────────────────────────────
  void onDeptChanged(String dept) {
    selectedDept.value = dept;
    loadMachines();
  }

  void onEntryDateChanged(DateTime date) {
    entryDate.value = date;
  }

  void onReportDateChanged(DateTime date) {
    reportDate.value = date;
  }

  void onReportDeptFilterChanged(String dept) {
    reportDeptFilter.value = dept;
  }

  void clearForm() {
    for (var entry in machineEntries) {
      entry.nosController.clear();
      entry.kgsController.clear();
      entry.mtrController.clear();
      entry.selectedShift.value = '1st Shift';
      entry.maintController.clear();
      entry.rmController.clear();
      entry.manController.clear();
      entry.otherController.clear();
    }
  }

  // ! ====================== Get Departments ==================================
  Future<void> getDepartmentList() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(
        ApiUrl.getProductionRights,
        queryParams: {
          'mUser': LocalDB.getUserModel()?.mUser ?? '',
          'MainMenu': 'Production',
          'SubMenu': 'LG30/70/Pilger SPD Production Entry',
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
            selectDeptDropDown.value = firstItem;
            selectReportDeptDropDown.value = firstItem;

            // Load machines for default department
            loadMachines();
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ! ====================== Load Machines by Department ======================
  Future<void> loadMachines() async {
    isMachinesLoading.value = true;

    // Dispose old controllers
    for (var entry in machineEntries) {
      entry.dispose();
    }
    machineEntries.clear();

    try {
      final response = await ApiService.getData(
        ApiUrl.getMachinesByDepartment,
        queryParams: {
          'userId': LocalDB.getUserModel()?.mUser ?? '',
          'department': selectedDept.value,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Handle both possible response shapes
        List<dynamic> machines = [];
        if (data is List) {
          machines = data;
        } else if (data is Map) {
          machines = data['data'] ?? data['Data'] ?? data['machines'] ?? [];
        }

        for (var machine in machines) {
          String machineName = '';
          if (machine is String) {
            machineName = machine;
          } else if (machine is Map) {
            machineName = machine['MachineName'] ??
                machine['machineName'] ??
                machine['Machine'] ??
                machine['machine'] ??
                '';
          }
          if (machineName.isNotEmpty) {
            machineEntries.add(LG30MachineEntry(machineName: machineName));
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading machines: $e');
    } finally {
      isMachinesLoading.value = false;
    }
  }

  // ! =================== Submit LG30 Pilger Entries ==========================
  Future<void> submitEntries() async {
    if (machineEntries.isEmpty) {
      AppUtils.showSnackBar('No machines loaded', background: Colors.orange);
      return;
    }

    isLoading.value = true;
    final userModel = LocalDB.getUserModel();
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(entryDate.value);
      final List<Map<String, dynamic>> payload = machineEntries
          .map((entry) => entry.toJson(
                date: dateStr,
                dept: selectedDept.value,
                createdBy: userModel?.mUser ?? '',
              ))
          .toList();

      final response = await ApiService.postData(
        ApiUrl.submitLG35PilgerEntry,
        data: payload,
      );

      if (response.statusCode == 200) {
        final success =
            response.data['success'] ?? response.data['Success'] ?? false;
        if (success) {
          AppUtils.showSnackBar(
            response.data['message'] ??
                response.data['Message'] ??
                'Data saved successfully!',
          );
          clearForm();
        } else {
          AppUtils.showSnackBar(
            response.data['message'] ??
                response.data['Message'] ??
                'Failed to save data',
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
      debugPrint('Error submitting entries: $e');
      AppUtils.showSnackBar('Error saving data', background: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // ! =================== Get LG30 Report Data ================================
  Future<void> getReportData() async {
    isLoading.value = true;
    reportEntries.clear();
    totalReportNos.value = 0;
    totalReportKgs.value = 0.0;
    totalReportMtr.value = 0.0;

    try {
      final response = await ApiService.getData(
        ApiUrl.getReportLG35Pilger,
        queryParams: {
          'department': reportDeptFilter.value,
          'date': DateFormat('yyyy-MM-dd').format(reportDate.value),
        },
      );

      if (response.statusCode == 200) {
        final success =
            response.data['success'] ?? response.data['Success'] ?? false;
        if (success) {
          final List<dynamic> data =
              response.data['data'] ?? response.data['Data'] ?? [];

          final newList = data.asMap().entries.map((e) {
            return LG30ReportEntry.fromJson(e.value, e.key);
          }).toList();

          reportEntries.assignAll(newList);

          // Calculate totals
          int sumNos = 0;
          double sumKgs = 0.0;
          double sumMtr = 0.0;
          for (var entry in reportEntries) {
            sumNos += entry.nos;
            sumKgs += entry.kgs;
            sumMtr += entry.mtr;
          }
          totalReportNos.value = sumNos;
          totalReportKgs.value = sumKgs;
          totalReportMtr.value = sumMtr;
        } else {
          AppUtils.showSnackBar(
            response.data['message'] ??
                response.data['Message'] ??
                'Failed to fetch report',
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
      debugPrint('Error fetching report: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ! =================== Print LG30 Report ===================================
  Future<void> printReport() async {
    if (reportEntries.isEmpty) {
      AppUtils.showSnackBar('No data available to print',
          background: Colors.orange);
      return;
    }

    isLoading.value = true;
    try {
      final base64Pdf = await LG30ReportPdfHelper.generateLG30ReportPdf(
        department: reportDeptFilter.value,
        reportDate: reportDate.value,
        entries: reportEntries,
        totalNos: totalReportNos.value,
        totalKgs: totalReportKgs.value,
        totalMtr: totalReportMtr.value,
      );

      final fileName =
          'LG30_Report_${reportDeptFilter.value}_${DateFormat('dd_MMM_yyyy').format(reportDate.value)}.pdf';
      await AppUtils.openPdf(base64Pdf, fileName: fileName);
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      AppUtils.showSnackBar('Failed to generate PDF',
          background: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}
