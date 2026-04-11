import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/api_url.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/local_db.dart';
import '../../../core/utills/app_utills.dart';
import '../model/ffd_model.dart';

class FFDController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // ─── Tab Controller ────────────────────────────────────────────────────────
  late TabController tabController;

  // ─── Loading ───────────────────────────────────────────────────────────────
  RxBool isLoading = false.obs;

  // ─── Entry Form ────────────────────────────────────────────────────────────
  Rx<DateTime> entryDate = DateTime.now().obs;

  final elbowController = TextEditingController(text: '0');
  final teeController = TextEditingController(text: '0');
  final reducerController = TextEditingController(text: '0');
  final capController = TextEditingController(text: '0');

  // ─── Report ────────────────────────────────────────────────────────────────
  RxList<FFDReportEntry> reportEntries = <FFDReportEntry>[].obs;
  Rx<DateTime> reportStartDate = DateTime.now().obs;
  Rx<DateTime> reportEndDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    elbowController.dispose();
    teeController.dispose();
    reducerController.dispose();
    capController.dispose();
    super.onClose();
  }

  // ─── Actions ───────────────────────────────────────────────────────────────

  void onEntryDateChanged(DateTime date) => entryDate.value = date;

  void onReportStartDateChanged(DateTime date) =>
      reportStartDate.value = date;

  void onReportEndDateChanged(DateTime date) => reportEndDate.value = date;

  void clearForm() {
    elbowController.text = '0';
    teeController.text = '0';
    reducerController.text = '0';
    capController.text = '0';
    entryDate.value = DateTime.now();
  }

  // ! ========================= Submit FFD Entry ==============================
  Future<void> submitEntry() async {
    isLoading.value = true;
    final userModel = LocalDB.getUserModel();

    try {
      final response = await ApiService.postData(
        ApiUrl.submitFFDEntry,
        data: dio.FormData.fromMap({
          'EntryDate':
              DateFormat('yyyy-MM-dd').format(entryDate.value),
          'ElbowQty': elbowController.text.trim().isEmpty
              ? '0'
              : elbowController.text.trim(),
          'TeeQty': teeController.text.trim().isEmpty
              ? '0'
              : teeController.text.trim(),
          'ReducerQty': reducerController.text.trim().isEmpty
              ? '0'
              : reducerController.text.trim(),
          'CapQty': capController.text.trim().isEmpty
              ? '0'
              : capController.text.trim(),
          'createdBy': userModel?.mUser ?? '',
        }),
      );

      if (response.statusCode == 200) {
        final success =
            response.data['success'] ?? response.data['Success'] ?? false;
        if (success) {
          AppUtils.showSnackBar(
            response.data['message'] ??
                response.data['Message'] ??
                'Entry saved successfully!',
          );
          clearForm();
          // Switch to report tab
          tabController.animateTo(1);
          getReportData();
        } else {
          AppUtils.showSnackBar(
            response.data['message'] ??
                response.data['Message'] ??
                'Failed to save entry',
            background: Colors.red,
          );
        }
      } else {
        AppUtils.showSnackBar(
          'Something went wrong! Status: ${response.statusCode}',
          background: Colors.red,
        );
      }
    } catch (e) {
      debugPrint('FFD submitEntry error: $e');
      AppUtils.showSnackBar('Error saving entry', background: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // ! ========================= Get FFD Report ================================
  Future<void> getReportData() async {
    isLoading.value = true;
    reportEntries.clear();

    try {
      final response = await ApiService.getData(
        ApiUrl.getFFDReport,
        queryParams: {
          'startDate':
              DateFormat('yyyy-MM-dd').format(reportStartDate.value),
          'endDate':
              DateFormat('yyyy-MM-dd').format(reportEndDate.value),
        },
      );

      if (response.statusCode == 200) {
        final rawData = response.data;
        List<dynamic> data = [];

        if (rawData is List) {
          data = rawData;
        } else if (rawData is Map) {
          data = rawData['data'] ?? rawData['Data'] ?? rawData['result'] ?? [];
        }

        reportEntries.assignAll(FFDReportEntry.fromJsonList(data));
      } else {
        AppUtils.showSnackBar(
          'Something went wrong! Status: ${response.statusCode}',
          background: Colors.red,
        );
      }
    } catch (e) {
      debugPrint('FFD getReportData error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
