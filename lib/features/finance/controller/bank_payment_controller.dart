// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:suraj_approval/core/constants/api_url.dart';
// import 'package:suraj_approval/core/extentions/num_extention.dart';
// import 'package:suraj_approval/core/service/local_db.dart';
// import 'package:suraj_approval/core/utills/app_utills.dart';
// import 'package:suraj_approval/core/widgets/app_text_field.dart';
// import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/bank_payment_approval_dialog.dart';
//
// import '../../../core/constants/app_enum.dart';
// import '../../../core/service/api_service.dart';
// import '../../../core/utills/app_module_container.dart';
// import '../../../core/utills/table_data_sources/bank_payment/bank_payment_data_source.dart';
// import '../../../core/widgets/app_dialog.dart';
// import '../../../core/widgets/common_widgets.dart';
// import '../model/bank_payment_model.dart';
//
// class BankPaymentController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   static BankPaymentController get instance => Get.find();
//
//   RxBool isLoading = false.obs;
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
//   void handleMenuSelection(String value, BankPaymentModel bankPayment) {
//     if (value == 'View') {
//       getBankpaymentReport(bankPayment);
//     } else if (value == 'Approve') {
//       Get.dialog(
//           GenericDialogBox(
//             headerText: 'Approve Bank Payment' ,
//             content: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: Column(
//                 children: [
//                   AppText(
//                     'Are you sure you want to Approve?',
//                     softWrap: true,
//                     style: TextStyles.medium(Get.context!),
//                   ),
//                   20.heightGap,
//                   buildRemarkField(),
//                 ],
//               ),
//             ),
//             primaryButtonText: 'Approve',
//             secondaryButtonText: 'Cancel',
//             onPrimaryButtonPressed: () {
//               postFinanceVoucher(bankPayment, paymentStatus: 'Approve');
//             },
//             onSecondaryButtonPressed: () {
//               Get.back();
//             },
//           )
//       );
//     } else if (value == 'Reject') {
//       Get.dialog(
//           GenericDialogBox(
//             headerText: 'Reject Bank Payment' ,
//             content: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: AppText(
//                 'Are you sure you want to Reject?',
//                 softWrap: true,
//                 style: TextStyles.medium(Get.context!),
//               ),
//             ),
//             primaryButtonText: 'Reject',
//             secondaryButtonText: 'Cancel',
//             onPrimaryButtonPressed: () {
//               postFinanceVoucher(bankPayment, paymentStatus: 'Reject');
//             },
//             onSecondaryButtonPressed: () {
//               Get.back();
//             },
//           )
//       );
//     }
//   }
//
//   Widget buildRemarkField() {
//     return AppTextField(
//         controller: remarkController,
//         hint: 'Enter Remarks',
//         validator: validateRemarks,
//         width: Get.width,
//         maxLines: 3,
//         height: 80.0);
//   }
//
//   String? validateRemarks(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter Remarks';
//     }
//     return null;
//   }
//
//
//   // ! ON INIT
//   @override
//   void onInit() {
//     super.onInit();
//     bankPaymentDataSource = BankPaymentDataSource(
//       bankPaymentList,
//       rowsPerPage: rowsPerPage.value,
//     );
//     getBankPaymentData();
//   }
// }
