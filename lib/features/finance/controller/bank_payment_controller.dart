import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/api_url.dart';
import 'package:suraj_approval/core/service/local_db.dart';
import 'package:suraj_approval/core/utills/app_utills.dart';

import '../../../core/constants/app_enum.dart';
import '../../../core/service/api_service.dart';
import '../../../core/utills/table_data_sources/bank_payment/bank_payment_data_source.dart';
import '../model/bank_payment_model.dart';

class BankPaymentController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static BankPaymentController get instance => Get.find();

  RxBool isLoading = false.obs;

  final userModel = LocalDB.getUserModel();
  MenuType currentMenu = MenuType.finance;
  SubMenuType currentSubMenu = SubMenuType.bankPayment;

  // ! Two lists to hold the Api data and filtered data
  RxList<BankPaymentModel> bankPaymentList = <BankPaymentModel>[].obs;
  RxList<BankPaymentModel> filteredBankPaymentList = <BankPaymentModel>[].obs;

  //! DataGridSource for the SfDataGrid
  late BankPaymentDataSource bankPaymentDataSource;

  // ! GET Bank Payment Data
  Future<void> getBankPaymentData() async {
    isLoading.value = true;
    try {
      final matchedUserDetail = userModel?.getDetailFor(
        currentMenu,
        currentSubMenu,
      );

      print('userModel.mUser : ${userModel?.mUser}');
      if (matchedUserDetail != null) {
        final param = {
          'mUser': userModel?.mUser,
          'mType': matchedUserDetail.type,
          'mUserLevel': matchedUserDetail.userLevel,
        };
        final response = await ApiService.getData(
          ApiUrl.getAuthorisationList,
          queryParams: param,
        );
        print("response.data:${response.data}");
        if (response.statusCode == 200) {
          List<BankPaymentModel> payment = BankPaymentModel.fromDecodedJsonList(
            response.data ?? [],
          );
          bankPaymentList.assignAll(payment);
          bankPaymentDataSource.updateDataSource(bankPaymentList);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ! GET Bank Payment Report
  Future<void> getBankpaymentReport() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(
        ApiUrl.getBankpaymentReport,
        queryParams: {
          'mbranch': 'HO',
          'mYearCode': '00101042025',
          'mType': 'BNA',
          'mSrl': '000001',
        },
      );
      if (response.statusCode == 200) {
        AppUtils.openPdf(response.data['Base64Pdf']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ! RESET FITERS
  resetFilters() {
    getBankPaymentData();
  }

  // ! Search Functionality
  TextEditingController searchController = TextEditingController();
  void filterData(String value) {
    // if (searchController.text.isEmpty) {
    //   filteredBankPaymentList.value = bankPaymentList;
    // } else {
    //   filteredBankPaymentList.value = bankPaymentList.where((item) {
    //     final displayNo = item.mBranch?.toLowerCase() ?? '';
    //     final credit = item.credit ?? 0.0;
    //     final debit = item.debit ?? 0.0;
    //
    //     bool matchesText = displayNo.contains(searchController.text) ||
    //         credit.contains(searchController.text.toLowerCase());
    //
    //     return matchesText;
    //   }).toList();
    // }
    bankPaymentDataSource.updateDataSource(filteredBankPaymentList);
  }

  // ! Grid Pagination
  var rowsPerPage = 10.obs;
  void changeRowsPerPage(int newRowsPerPage) {
    rowsPerPage.value = newRowsPerPage;
    bankPaymentDataSource.setRowsPerPage(newRowsPerPage);
  }

  void handleMenuSelection(String value, BankPaymentModel bankPayment) {
    if (value == 'View') {
      print('View Action Clicked');
    } else if (value == 'Approve') {
      print('Approve Action Clicked');
      // Add your approve logic here
    } else if (value == 'Reject') {
      print('Reject Action Clicked');
      // Add your reject logic here
    }
    print('value is $value');
  }

  // ! ON INIT
  @override
  void onInit() {
    super.onInit();
    bankPaymentDataSource = BankPaymentDataSource(
      bankPaymentList,
      rowsPerPage: rowsPerPage.value,
    );
    getBankPaymentData();
  }
}
