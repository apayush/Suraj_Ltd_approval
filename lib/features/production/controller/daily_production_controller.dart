import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:suraj_approval/core/utills/app_utills.dart';
import '../../../core/constants/api_url.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/local_db.dart';
import '../model/daily_production_model.dart';
import '../model/daily_production_data_source.dart';

class DailyProductionController extends GetxController with GetSingleTickerProviderStateMixin {
  static DailyProductionController get instance => Get.find();

  // --- Tab Controller ---
  late TabController tabController;

  // --- Loading State ---
  RxBool isLoading = false.obs;

  // --- Entries DB (In-Memory for UI testing) ---
  RxList<DailyProductionEntry> entries = <DailyProductionEntry>[].obs;

  // --- Form Controllers & State ---
  Rx<DateTime> entryDate = DateTime.now().obs;
  final TextEditingController cuttingController = TextEditingController();
  final TextEditingController formingController = TextEditingController();
  final TextEditingController bevellingController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // --- Report Filter State ---
  Rxn<DateTime> filterStartDate = Rxn<DateTime>(DateTime.now());
  Rxn<DateTime> filterEndDate = Rxn<DateTime>(DateTime.now());

  // --- Computed Rows for Grid ---
  List<DailyProductionEntry> get filteredEntries {
    List<DailyProductionEntry> result = entries.toList();
    result.sort((a, b) => a.date.compareTo(b.date));

    // Date filters
    if (filterStartDate.value != null) {
      result = result.where((e) {
        final d = DateFormat('yyyy-MM-dd').parse(e.date);
        return d.isAfter(filterStartDate.value!.subtract(const Duration(days: 1)));
      }).toList();
    }
    if (filterEndDate.value != null) {
      result = result.where((e) {
        final d = DateFormat('yyyy-MM-dd').parse(e.date);
        return d.isBefore(filterEndDate.value!.add(const Duration(days: 1)));
      }).toList();
    }
    return result;
  }

  // --- Pagination / Totals Variables (if required) ---
  RxInt totalReportTarget = 0.obs;
  RxInt totalReportActual = 0.obs;

  bool _isReportLoaded = false;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    
    // Fetch report data only when viewing the report tab for the first time
    tabController.addListener(() {
      if (tabController.index == 1 && !_isReportLoaded) {
        getReportData();
      }
    });
  }

  // --- Actions ---
  void onEntryDateChanged(DateTime date) {
    entryDate.value = date;
  }

  void onFilterStartDateChanged(DateTime date) {
    filterStartDate.value = date;
  }

  void onFilterEndDateChanged(DateTime date) {
    filterEndDate.value = date;
  }

  void clearForm() {
    cuttingController.clear();
    formingController.clear();
    bevellingController.clear();
    entryDate.value = DateTime.now();
  }

  // ! ====================== Load Machines by Department ======================
  Future<void> getReportData() async {
    _isReportLoaded = true;
    isLoading.value = true;
    try {
      final response = await ApiService.getData(
        ApiUrl.getCapacityReport,
        queryParams: {
          'startDate': filterStartDate.value != null ? DateFormat('yyyy-MM-dd').format(filterStartDate.value!) : '',
          'endDate': filterEndDate.value != null ? DateFormat('yyyy-MM-dd').format(filterEndDate.value!) : '',
        },
      );

      if (response.statusCode == 200) {
        final success = response.data['success'] ?? response.data['Success'] ?? false;
        if (success) {
          final data = response.data['Data'] ?? response.data['data'] as List?;
          if (data != null) {
            entries.clear();
            for (var item in data) {
              entries.add(DailyProductionEntry.fromJson(item));
            }
          }
        } else {
          entries.clear();
          AppUtils.showSnackBar(
            response.data['message'] ?? response.data['Message'] ?? 'Failed to fetch report data',
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
      debugPrint('Error loading report: $e');
      AppUtils.showSnackBar('Error loading report data', background: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // ! =================== Submit LG30 Pilger Entries ==========================
  Future<void> submitEntries() async {
    if (!formKey.currentState!.validate()) return;
    
    isLoading.value = true;
    final userModel = LocalDB.getUserModel();
    try {
      final response = await ApiService.postData(
        ApiUrl.submitCapacityEntry,
        data: {
          'EntryDate': DateFormat('yyyy-MM-dd').format(entryDate.value),
          'CuttingQty': int.tryParse(cuttingController.text.trim()) ?? 0,
          'FormingQty': int.tryParse(formingController.text.trim()) ?? 0,
          'BevellingQty': int.tryParse(bevellingController.text.trim()) ?? 0,
          'createdBy': userModel?.mUser ?? '',
        },
      );

      if (response.statusCode == 200) {
        final success =
            response.data['success'] ?? response.data['Success'] ?? false;
        if (success) {
          AppUtils.showSnackBar(
            response.data['message'] ??
                response.data['Message'] ??
                'Data saved successfully!',
            background: Colors.green,
          );
          clearForm();
          getReportData();
          tabController.animateTo(1);
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
}
