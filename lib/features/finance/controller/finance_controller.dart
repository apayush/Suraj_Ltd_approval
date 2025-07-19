import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';

import '../../../core/constants/api_url.dart';
import '../../../core/constants/app_enum.dart';
import '../../../core/models/user_model.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/local_db.dart';
import '../../../core/utills/app_module_container.dart';
import '../../../core/utills/app_utills.dart';
import '../../../core/utills/table_data_sources/bank_payment/bank_payment_data_source.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/common_widgets.dart';
import '../model/bank_payment_model.dart';
import '../view/widgets/tabs/widgets/bank_payment.dart';
import '../view/widgets/tabs/widgets/bank_receipt.dart';
import '../view/widgets/tabs/widgets/cash_payment.dart';

// class FinanceController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   static FinanceController get instance => Get.find();
//
//   RxBool isLoading = false.obs;
//
//   late TabController tabController;
//   final List<Tab> myTabs = const <Tab>[
//     Tab(text: 'Bank Payment'),
//     Tab(text: 'Bank Receipt'),
//     Tab(text: 'Cash Payment'),
//     Tab(text: 'Cash Receipt'),
//   ];
//
//   final userModel = LocalDB.getUserModel();
//   MenuType currentMenu = MenuType.finance;
//   SubMenuType currentSubMenu = SubMenuType.bankPayment;
//
//   // ! Two lists to hold the Api data and filtered data
//   RxList<BankPaymentModel> bankPaymentList = <BankPaymentModel>[].obs;
//   RxList<BankPaymentModel> filteredBankPaymentList = <BankPaymentModel>[].obs;
//
//   //! DataGridSource for the SfDataGrid
//   late BankPaymentDataSource bankPaymentDataSource;
//
//   // ! GET Bank Payment Data
//   Future<void> getBankPaymentData() async {
//     isLoading.value = true;
//     try {
//       final matchedUserDetail = userModel?.getDetailFor(
//         currentMenu,
//         currentSubMenu,
//       );
//
//       if (matchedUserDetail != null) {
//         final param = {
//           'mUser': userModel?.mUser,
//           'mType': matchedUserDetail.type,
//           'mUserLevel': matchedUserDetail.userLevel,
//         };
//         final response = await ApiService.getData(
//           ApiUrl.getAuthorisationList,
//           queryParams: param,
//         );
//         if (response.statusCode == 200) {
//           List<BankPaymentModel> payment = BankPaymentModel.fromDecodedJsonList(
//             response.data ?? [],
//           );
//           bankPaymentList.assignAll(payment);
//           bankPaymentDataSource.updateDataSource(bankPaymentList);
//         }
//       }
//     } catch (e) {
//       print(e);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ! GET Bank Payment Report
//   Future<void> getBankpaymentReport(BankPaymentModel bankPayment) async {
//     isLoading.value = true;
//     try {
//       final response = await ApiService.getData(
//         ApiUrl.getBankpaymentReport,
//         queryParams: {
//           // 'mbranch': bankPayment.mBranch,
//           'mLinkField': bankPayment.linkField,
//           // 'mType': bankPayment.type,
//           // 'mSrl': bankPayment.srl,
//         },
//       );
//       if (response.statusCode == 200) {
//         AppUtils.openPdf(response.data['Base64Pdf']);
//       }
//     } catch (e) {
//       print(e);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ! Authorize Finance Voucher
//   Future<void> postFinanceVoucher(
//     BankPaymentModel bankPayment, {
//     required String paymentStatus,
//   }) async {
//     isLoading.value = true;
//     try {
//       final matchedUserDetail = userModel?.getDetailFor(
//         currentMenu,
//         currentSubMenu,
//       );
//       final response = await ApiService.postData(
//         ApiUrl.authoriseFinanceVoucher,
//         queryParams: {
//           'mUser': userModel?.mUser,
//           'mUserLevel': matchedUserDetail?.userLevel,
//           'LinkField': bankPayment.linkField,
//           'mAuthorise': paymentStatus,
//           'mRemarks': 'test',
//         },
//       );
//       if (response.statusCode == 200) {
//         if (response.data['Success'] == true) {
//           AppUtils.showSnackBar('Voucher Updated Successfully');
//         }
//         getBankPaymentData();
//       }
//     } catch (e) {
//       print(e);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ! RESET FITERS
//   resetFilters() {
//     getBankPaymentData();
//   }
//
//   // ! Search Functionality
//   TextEditingController searchController = TextEditingController();
//
//   void filterData(String searchText) {
//     final query = searchText.toLowerCase().trim();
//
//     if (query.isEmpty) {
//       filteredBankPaymentList.assignAll(bankPaymentList);
//     } else {
//       filteredBankPaymentList.assignAll(
//         bankPaymentList.where((item) {
//           final mBranch = item.mBranch?.toLowerCase() ?? '';
//           final credit = (item.credit ?? 0.0).toString();
//           final debit = (item.debit ?? 0.0).toString();
//           final docDate = (item.docDate ?? 0.0).toString();
//           final mainType = (item.mainType ?? 0.0).toString();
//
//           return mBranch.contains(query) ||
//               credit.contains(query) ||
//               docDate.contains(query) ||
//               mainType.contains(query) ||
//               debit.contains(query);
//         }),
//       );
//     }
//
//     bankPaymentDataSource.updateDataSource(filteredBankPaymentList);
//   }
//
//   // ! Grid Pagination
//   var rowsPerPage = 10.obs;
//
//   void changeRowsPerPage(int newRowsPerPage) {
//     rowsPerPage.value = newRowsPerPage;
//     bankPaymentDataSource.setRowsPerPage(newRowsPerPage);
//   }
//
//   // ! Handle Action Menu Selection
//   TextEditingController remarkController = TextEditingController();
//
//   void handleMenuSelection(String value, BankPaymentModel bankPayment) {
//     if (value == 'View') {
//       getBankpaymentReport(bankPayment);
//     } else if (value == 'Approve') {
//       Get.dialog(
//         GenericDialogBox(
//           headerText: 'Approve Bank Payment',
//           content: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: Column(
//               children: [
//                 AppText(
//                   'Are you sure you want to Approve?',
//                   softWrap: true,
//                   style: TextStyles.medium(Get.context!),
//                 ),
//                 20.heightGap,
//                 buildRemarkField(),
//               ],
//             ),
//           ),
//           primaryButtonText: 'Approve',
//           secondaryButtonText: 'Cancel',
//           onPrimaryButtonPressed: () {
//             postFinanceVoucher(bankPayment, paymentStatus: 'Approve');
//           },
//           onSecondaryButtonPressed: () {
//             Get.back();
//           },
//         ),
//       );
//     } else if (value == 'Reject') {
//       Get.dialog(
//         GenericDialogBox(
//           headerText: 'Reject Bank Payment',
//           content: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: AppText(
//               'Are you sure you want to Reject?',
//               softWrap: true,
//               style: TextStyles.medium(Get.context!),
//             ),
//           ),
//           primaryButtonText: 'Reject',
//           secondaryButtonText: 'Cancel',
//           onPrimaryButtonPressed: () {
//             postFinanceVoucher(bankPayment, paymentStatus: 'Reject');
//           },
//           onSecondaryButtonPressed: () {
//             Get.back();
//           },
//         ),
//       );
//     }
//   }
//
//   Widget buildRemarkField() {
//     return AppTextField(
//       controller: remarkController,
//       hint: 'Enter Remarks',
//       validator: validateRemarks,
//       width: Get.width,
//       maxLines: 3,
//       height: 80.0,
//     );
//   }
//
//   String? validateRemarks(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter Remarks';
//     }
//     return null;
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     tabController = TabController(vsync: this, length: myTabs.length);
//   }
// }

class FinanceController extends GetxController
    with GetTickerProviderStateMixin {
  RxBool isLoading = false.obs;

  final userModel = LocalDB.getUserModel();
  MenuType currentMenu = MenuType.finance;
  SubMenuType currentSubMenu = SubMenuType.bankPayment;

  late TabController tabController;
  List<Tab> myTabs = [];
  List<Widget> tabViews = [];

  // ! Two lists to hold the Api data and filtered data for Bank Payment
  RxList<BankPaymentModel> bankPaymentList = <BankPaymentModel>[].obs;
  RxList<BankPaymentModel> filteredBankPaymentList = <BankPaymentModel>[].obs;

  // ! Two lists to hold the Api data and filtered data for Bank Receipt
  RxList<BankPaymentModel> bankReceiptList = <BankPaymentModel>[].obs;
  RxList<BankPaymentModel> filteredBankReceiptList = <BankPaymentModel>[].obs;

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

  // ! GET Bank Receipt Data
  Future<void> getBankReceiptData() async {
    isLoading.value = true;
    try {
      final matchedUserDetail = userModel?.getDetailFor(
        currentMenu,
        currentSubMenu,
      );

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
        if (response.statusCode == 200) {
          List<BankPaymentModel> payment = BankPaymentModel.fromDecodedJsonList(
            response.data ?? [],
          );
          bankReceiptList.assignAll(payment);
          bankPaymentDataSource.updateDataSource(bankReceiptList);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

 // ! GET All Data
  Future<void> getAllData() async {
    isLoading.value = true;
    try {
      final matchedUserDetail = userModel?.getDetailFor(
        currentMenu,
        currentSubMenu,
      );

      if (matchedUserDetail != null) {
        final param = {
          'mUser': userModel?.mUser,
          'mType': matchedUserDetail.type,
          'mDeviceType': 'web'
        };
        final response = await ApiService.getData(
          ApiUrl.getAuthorisationListFilter,
          queryParams: param,
        );
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
  Future<void> getBankpaymentReport(BankPaymentModel bankPayment) async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(
        ApiUrl.getBankpaymentReport,
        queryParams: {
          // 'mbranch': bankPayment.mBranch,
          'mLinkField': bankPayment.linkField,
          // 'mType': bankPayment.type,
          // 'mSrl': bankPayment.srl,
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

  // ! Authorize Finance Voucher
  Future<void> postFinanceVoucher(
    BankPaymentModel bankPayment, {
    required String paymentStatus,
  }) async {
    isLoading.value = true;
    try {
      final matchedUserDetail = userModel?.getDetailFor(
        currentMenu,
        currentSubMenu,
      );
      final response = await ApiService.postData(
        ApiUrl.authoriseFinanceVoucher,
        queryParams: {
          'mUser': userModel?.mUser,
          'mUserLevel': matchedUserDetail?.userLevel,
          'LinkField': bankPayment.linkField,
          'mAuthorise': paymentStatus,
          'mRemarks': 'test',
        },
      );
      if (response.statusCode == 200) {
        if (response.data['Success'] == true) {
          AppUtils.showSnackBar('Voucher Updated Successfully');
        }
        getBankPaymentData();
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

  void filterData(String searchText) {
    final query = searchText.toLowerCase().trim();

    if (query.isEmpty) {
      filteredBankPaymentList.assignAll(bankPaymentList);
    } else {
      filteredBankPaymentList.assignAll(
        bankPaymentList.where((item) {
          final mBranch = item.mBranch?.toLowerCase() ?? '';
          final credit = (item.credit ?? 0.0).toString();
          final debit = (item.debit ?? 0.0).toString();
          final docDate = (item.docDate ?? 0.0).toString();
          final mainType = (item.mainType ?? 0.0).toString();
          final party = (item.party ?? 0.0).toString();
          final authIds = (item.authIds ?? 0.0).toString();

          return mBranch.contains(query) ||
              credit.contains(query) ||
              docDate.contains(query) ||
              mainType.contains(query) ||
              party.contains(query) ||
              authIds.contains(query) ||
              debit.contains(query);
        }),
      );
    }

    bankPaymentDataSource.updateDataSource(filteredBankPaymentList);
  }

  // ! Grid Pagination
  var rowsPerPage = 10.obs;

  void changeRowsPerPage(int newRowsPerPage) {
    rowsPerPage.value = newRowsPerPage;
    bankPaymentDataSource.setRowsPerPage(newRowsPerPage);
  }

  // ! Handle Action Menu Selection
  TextEditingController remarkController = TextEditingController();

  void handleMenuSelection(String value, BankPaymentModel bankPayment) {
    if (value == 'View') {
      getBankpaymentReport(bankPayment);
    } else if (value == 'Approve') {
      Get.dialog(
        GenericDialogBox(
          headerText: 'Approve Bank Payment',
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                AppText(
                  'Are you sure you want to Approve?',
                  softWrap: true,
                  style: TextStyles.medium(Get.context!),
                ),
                20.heightGap,
                buildRemarkField(),
              ],
            ),
          ),
          primaryButtonText: 'Approve',
          secondaryButtonText: 'Cancel',
          onPrimaryButtonPressed: () {
            postFinanceVoucher(bankPayment, paymentStatus: 'Approve');
          },
          onSecondaryButtonPressed: () {
            Get.back();
          },
        ),
      );
    } else if (value == 'Reject') {
      Get.dialog(
        GenericDialogBox(
          headerText: 'Reject Bank Payment',
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: AppText(
              'Are you sure you want to Reject?',
              softWrap: true,
              style: TextStyles.medium(Get.context!),
            ),
          ),
          primaryButtonText: 'Reject',
          secondaryButtonText: 'Cancel',
          onPrimaryButtonPressed: () {
            postFinanceVoucher(bankPayment, paymentStatus: 'Reject');
          },
          onSecondaryButtonPressed: () {
            Get.back();
          },
        ),
      );
    }
  }

  Widget buildRemarkField() {
    return AppTextField(
      controller: remarkController,
      hint: 'Enter Remarks',
      validator: validateRemarks,
      width: Get.width,
      maxLines: 3,
      height: 80.0,
    );
  }

  String? validateRemarks(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Remarks';
    }
    return null;
  }

@override
void onInit() {
  super.onInit();

  // Fetch submenus immediately (no need to delay using addPostFrameCallback)
  final subMenus = userModel?.getSubMenusFor(MenuType.finance) ?? [];

  final tabs = <Tab>[];
  final views = <Widget>[];

  if (subMenus.contains(SubMenuType.bankPayment)) {
    tabs.add(const Tab(text: 'Bank Payment'));
    views.add(BankPayment());
  }

  if (subMenus.contains(SubMenuType.bankReceipt)) {
    tabs.add(const Tab(text: 'Bank Receipt'));
    views.add(BankReceipt());
  }

  if (subMenus.contains(SubMenuType.cashPayment)) {
    tabs.add(const Tab(text: 'Cash Payment'));
    views.add(CashPayment());
  }

  if (subMenus.contains(SubMenuType.cashReceipt)) {
    tabs.add(const Tab(text: 'Cash Receipt'));
    views.add(CashPayment());
  }

  myTabs = tabs;
  tabController = TabController(length: myTabs.length, vsync: this);

  bankPaymentDataSource = BankPaymentDataSource(
    bankPaymentList,
    rowsPerPage: rowsPerPage.value,
  );

  getBankPaymentData();
}


  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}

