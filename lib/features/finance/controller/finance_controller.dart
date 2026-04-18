import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/utills/device_type.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/finance_view.dart';
import 'package:suraj_approval/features/notifications/controller/notification_controller.dart';

import '../../../core/constants/api_url.dart';
import '../../../core/constants/app_enum.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/local_db.dart';
import '../../../core/utills/app_module_container.dart';
import '../../../core/utills/app_utills.dart';
import '../../../core/widgets/toast/message_type.dart';
import '../../../core/utills/table_data_sources/finance_module/bank_payment_data_source.dart';
import '../../../core/utills/table_data_sources/finance_module/bank_receipt_data_source.dart';
import '../../../core/utills/table_data_sources/finance_module/cash_payment_data_source.dart';
import '../../../core/utills/table_data_sources/finance_module/cash_receipt_data_source.dart';
import '../../../core/utills/table_data_sources/finance_module/journal_voucher_data_source.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/common_widgets.dart';
import '../model/bank_payment_model.dart';

class FinanceController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isApproveLoading = false.obs;
  RxBool isRejectLoading = false.obs;
  RxBool isHoldVoucherModelEnabled = false.obs;

  Rxn<DropDownResponse> selectBranch = Rxn<DropDownResponse>();
  RxList<DropDownResponse> BranchList =
      <DropDownResponse>[
        DropDownResponse(value: '', text: 'Select Branch'),
        DropDownResponse(value: 'THOL', text: 'THOL'),
        DropDownResponse(value: 'CHANDARDA', text: 'CHANDARDA'),
      ].obs;

  onBranchValueChanged(DropDownResponse? value) {
    if (value != null) {
      selectBranch.value = value;
      if (DeviceType.isDesktop(Get.context!))
        getAllData(mainType: currentSubMenu.value);
    } else {
      selectBranch.value = BranchList.first;
    }
  }

  MenuType currentMenu = MenuType.finance;
  final Rx<SubMenuType> currentSubMenu = SubMenuType.bankPayment.obs;

  RxInt selectedTabIndex = 0.obs;
  List<String> myTabs = [];
  List<Widget> tabViews = [];
  final GlobalKey<FormState> approveFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> rejectFormKey = GlobalKey<FormState>();

  // ! Two lists to hold the Api data and filtered data for Bank Payment
  RxList<VoucherModel> bankPaymentList = <VoucherModel>[].obs;
  RxList<VoucherModel> filteredBankPaymentList = <VoucherModel>[].obs;

  // ! Two lists to hold the Api data and filtered data for Bank Receipt
  RxList<VoucherModel> bankReceiptList = <VoucherModel>[].obs;
  RxList<VoucherModel> filteredBankReceiptList = <VoucherModel>[].obs;

  // ! Two lists to hold the Api data and filtered data for Cash Payment
  RxList<VoucherModel> cashPaymentList = <VoucherModel>[].obs;
  RxList<VoucherModel> filteredCashPaymentList = <VoucherModel>[].obs;

  // ! Two lists to hold the Api data and filtered data for Cash Receipt
  RxList<VoucherModel> cashReceiptList = <VoucherModel>[].obs;
  RxList<VoucherModel> filteredCashReceiptList = <VoucherModel>[].obs;

  // ! Two lists to hold the Api data and filtered data for journal Voucher
  RxList<VoucherModel> journalVoucherList = <VoucherModel>[].obs;
  RxList<VoucherModel> filteredJournalVoucherList = <VoucherModel>[].obs;

  //! DataGridSource for the SfDataGrid
  late BankPaymentDataSource bankPaymentDataSource;
  late BankReceiptDataSource bankReceiptDataSource;
  late CashPaymentDataSource cashPaymentDataSource;
  late CashReceiptDataSource cashReceiptDataSource;
  late JournalVoucherDataSource journalVoucherDataSource;

  // ! Get All Finance Module Data Table
  Future<void> getAllData({required SubMenuType mainType}) async {
    if (isHoldVoucherModelEnabled.value) {
      getAllHoldData(mainType: mainType);
      return;
    }
    final userModel = LocalDB.getUserModel();
    isLoading.value = true;
    try {
      final matchedUserDetail = userModel?.getDetailFor(
        currentMenu,
        currentSubMenu.value,
      );

      if (matchedUserDetail != null) {
        final param = {
          'mUser': userModel?.mUser,
          'MainType': mainType.key,
          'mDeviceType': DeviceType.isMobile(Get.context!) ? 'mobile' : 'web',
          'mBranchName': selectBranch.value?.value ?? '',
        };
        final response = await ApiService.getData(
          ApiUrl.getAuthorisationListFilter,
          queryParams: param,
        );
        if (response.statusCode == 200) {
          List<VoucherModel> payment = VoucherModel.fromDecodedJsonList(
            response.data ?? [],
          );
          switch (mainType) {
            case SubMenuType.bankPayment:
              bankPaymentList.assignAll(payment);
              filteredBankPaymentList.value = (payment);
              bankPaymentDataSource.updateDataSource(bankPaymentList);
              break;
            case SubMenuType.bankReceipt:
              bankReceiptList.assignAll(payment);
              filteredBankReceiptList.value = (payment);
              bankReceiptDataSource.updateDataSource(bankReceiptList);
              break;
            case SubMenuType.cashPayment:
              cashPaymentList.assignAll(payment);
              filteredCashPaymentList.value = (payment);
              cashPaymentDataSource.updateDataSource(cashPaymentList);
              break;
            case SubMenuType.cashReceipt:
              cashReceiptList.assignAll(payment);
              filteredCashReceiptList.value = (payment);
              cashReceiptDataSource.updateDataSource(cashReceiptList);
              break;
            case SubMenuType.journalVoucher:
              journalVoucherList.assignAll(payment);
              filteredJournalVoucherList.value = (payment);
              journalVoucherDataSource.updateDataSource(journalVoucherList);
              break;
            default:
              break;
          }
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ! Get Finance Module Hold Data Table
  Future<void> getAllHoldData({required SubMenuType mainType}) async {
    final userModel = LocalDB.getUserModel();
    isLoading.value = true;
    try {
      final matchedUserDetail = userModel?.getDetailFor(
        currentMenu,
        currentSubMenu.value,
      );

      if (matchedUserDetail != null) {
        final param = {'mUser': userModel?.mUser, 'MainType': mainType.key};
        final response = await ApiService.getData(
          ApiUrl.getHoldVoucher,
          queryParams: param,
        );
        if (response.statusCode == 200) {
          List<VoucherModel> payment = VoucherModel.fromDecodedJsonList(
            response.data ?? [],
          );
          switch (mainType) {
            case SubMenuType.bankPayment:
              bankPaymentList.assignAll(payment);
              filteredBankPaymentList.value = (payment);
              bankPaymentDataSource.updateDataSource(bankPaymentList);
              break;
            case SubMenuType.bankReceipt:
              bankReceiptList.assignAll(payment);
              filteredBankReceiptList.value = (payment);
              bankReceiptDataSource.updateDataSource(bankReceiptList);
              break;
            case SubMenuType.cashPayment:
              cashPaymentList.assignAll(payment);
              filteredCashPaymentList.value = (payment);
              cashPaymentDataSource.updateDataSource(cashPaymentList);
              break;
            case SubMenuType.cashReceipt:
              cashReceiptList.assignAll(payment);
              filteredCashReceiptList.value = (payment);
              cashReceiptDataSource.updateDataSource(cashReceiptList);
              break;
            case SubMenuType.journalVoucher:
              journalVoucherList.assignAll(payment);
              filteredJournalVoucherList.value = (payment);
              journalVoucherDataSource.updateDataSource(journalVoucherList);
              break;
            default:
              break;
          }
        }
      }
    } catch (e) {
      print(e);
      switch (mainType) {
        case SubMenuType.bankPayment:
          bankPaymentList.clear();
          filteredBankPaymentList.clear();
          bankPaymentDataSource.updateDataSource(bankPaymentList);
          break;
        case SubMenuType.bankReceipt:
          bankReceiptList.clear();
          filteredBankReceiptList.clear();
          bankReceiptDataSource.updateDataSource(bankReceiptList);
          break;
        case SubMenuType.cashPayment:
          cashPaymentList.clear();
          filteredCashPaymentList.clear();
          cashPaymentDataSource.updateDataSource(cashPaymentList);
          break;
        case SubMenuType.cashReceipt:
          cashReceiptList.clear();
          filteredCashReceiptList.clear();
          cashReceiptDataSource.updateDataSource(cashReceiptList);
          break;
        case SubMenuType.journalVoucher:
          journalVoucherList.clear();
          filteredJournalVoucherList.clear();
          journalVoucherDataSource.updateDataSource(journalVoucherList);
          break;
        default:
          break;
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ! GET PDF Report
  Future<void> getBankpaymentReport(VoucherModel bankPayment) async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(
        ApiUrl.getVoucherReport,
        queryParams: {'mLinkField': bankPayment.linkField},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data.containsKey('Error')) {
          AppUtils.showSnackBar('${data['Error']}', background: Colors.red);
        }
        AppUtils.openPdf(data['Base64Pdf']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ! Approve Reject Finance Voucher
  Future<void> postFinanceVoucher(
    VoucherModel voucher, {
    required String paymentStatus,
  }) async {
    final userModel = LocalDB.getUserModel();
    isLoading.value = true;
    try {
      final response = await ApiService.postData(
        ApiUrl.authoriseVoucher,
        queryParams: {
          'mUser': userModel?.mUser,
          'mUserLevel': voucher.userLevel,
          'LinkField': voucher.linkField,
          'mAuthorise': paymentStatus,
          'mRemarks': remarkController.value.text,
          'mDeviceType': kIsWeb ? 'web' : 'mobile',
        },
      );
      if (response.statusCode == 200) {
        // Dialog closing is now managed by the caller's finally block to avoid race conditions.
        if (response.data['Success'] == 'Approve') {
          AppUtils.showSnackBar('Voucher Approved Successfully');
          remarkController.clear();
          getAllData(mainType: currentSubMenu.value);
        } else if (response.data['Success'] == 'Reject') {
          AppUtils.showSnackBar('Voucher Rejected Successfully');
          remarkController.clear();
          getAllData(mainType: currentSubMenu.value);
        } else if (response.data['Success'] == 'Hold') {
          AppUtils.showSnackBar('Voucher Hold Successfully');
        } else {
          // e.g. "Success": "Failed" — business rule warning, not a system error
          final msg =
              response.data['Message'] ??
              response.data['message'] ??
              'Action could not be completed.';
          AppUtils.showSnackBar(msg, type: MessageType.warning);
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

  // ! RESET FILTERS
  resetFilters() {
    selectBranch.value = BranchList.first;
    getAllData(mainType: currentSubMenu.value);
  }

  // ! Hold Voucher
  getHoldVoucher() {
    isHoldVoucherModelEnabled.value = !isHoldVoucherModelEnabled.value;
    if (isHoldVoucherModelEnabled.value) {
      getAllHoldData(mainType: currentSubMenu.value);
    } else {
      getAllData(mainType: currentSubMenu.value);
    }
  }

  // ! Search Functionality
  TextEditingController searchController = TextEditingController();

  void filterData(String searchText) {
    print(searchText);
    final query = searchText.toLowerCase().trim();
    List<VoucherModel> sourceList;
    RxList<VoucherModel> filteredList;
    dynamic dataSource;

    switch (currentSubMenu.value) {
      case SubMenuType.bankPayment:
        sourceList = bankPaymentList;
        filteredList = filteredBankPaymentList;
        dataSource = bankPaymentDataSource;
        break;
      case SubMenuType.bankReceipt:
        sourceList = bankReceiptList;
        filteredList = filteredBankReceiptList;
        dataSource = bankReceiptDataSource;
        break;
      case SubMenuType.cashPayment:
        sourceList = cashPaymentList;
        filteredList = filteredCashPaymentList;
        dataSource = cashPaymentDataSource;
        break;
      case SubMenuType.cashReceipt:
        sourceList = cashReceiptList;
        filteredList = filteredCashReceiptList;
        dataSource = cashReceiptDataSource;
        break;
      case SubMenuType.journalVoucher:
        sourceList = journalVoucherList;
        filteredList = filteredJournalVoucherList;
        dataSource = journalVoucherDataSource;
        break;
      default:
        return;
    }

    if (query.isEmpty) {
      filteredList.assignAll(sourceList);
    } else {
      filteredList.assignAll(
        sourceList.where((item) {
          return [
                item.mBranch,
                item.type,
                item.srl,
                item.docDate,
                item.party,
                item.debit,
                item.credit,
                item.authIds,
                item.mainType,
              ]
              .map((e) => e?.toString().toLowerCase() ?? '')
              .any((field) => field.contains(query));
        }),
      );
    }
    if (DeviceType.isMobile(Get.context!) ||
        DeviceType.isTablet(Get.context!)) {
      switch (currentSubMenu.value) {
        case SubMenuType.bankPayment:
          filteredBankPaymentList.value = filteredList.toList();
          break;
        case SubMenuType.bankReceipt:
          filteredBankReceiptList.value = filteredList.toList();
          break;
        case SubMenuType.cashPayment:
          filteredCashPaymentList.value = filteredList.toList();
          break;
        case SubMenuType.cashReceipt:
          filteredCashReceiptList.value = filteredList.toList();
          break;
        case SubMenuType.journalVoucher:
          filteredJournalVoucherList.value = filteredList.toList();
          break;
        default:
          break;
      }
    } else {
      dataSource.updateDataSource(filteredList);
    }
  }

  // ! Grid Pagination
  final RxInt rowsPerPage = 10.obs;

  void changeRowsPerPage(int newRowsPerPage) {
    rowsPerPage.value = newRowsPerPage;
    switch (currentSubMenu.value) {
      case SubMenuType.bankPayment:
        bankPaymentDataSource.setRowsPerPage(newRowsPerPage);
        break;
      case SubMenuType.bankReceipt:
        bankReceiptDataSource.setRowsPerPage(newRowsPerPage);
        break;
      case SubMenuType.cashPayment:
        cashPaymentDataSource.setRowsPerPage(newRowsPerPage);
        break;
      case SubMenuType.cashReceipt:
        cashReceiptDataSource.setRowsPerPage(newRowsPerPage);
        break;
      case SubMenuType.journalVoucher:
        journalVoucherDataSource.setRowsPerPage(newRowsPerPage);
        break;
      default:
        break;
    }
  }

  // ! Handle Action Menu Selection
  TextEditingController remarkController = TextEditingController();

  Future<void> handleMenuSelection(
    String value,
    VoucherModel bankPayment,
  ) async {
    if (value == 'View') {
      await getBankpaymentReport(bankPayment);
    } else if (value == 'Approve') {
      await showDialog(
        context: Get.context!,
        builder:
            (context) => GenericDialogBox(
              headerText: 'Approve',
              content: Form(
                key: approveFormKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      AppText(
                        'Are you sure you want to Approve?',
                        softWrap: true,
                        style: TextStyles.medium(context),
                      ),
                      20.heightGap,
                      buildRemarkField(),
                    ],
                  ),
                ),
              ),
              primaryButtonText: 'Approve',
              secondaryButtonText: 'Cancel',
              onPrimaryButtonPressed: () async {
                try {
                  isApproveLoading.value = true;
                  await postFinanceVoucher(
                    bankPayment,
                    paymentStatus: 'Approve',
                  );
                } catch (e) {
                  print('Error approving voucher: $e');
                } finally {
                  isApproveLoading.value = false;
                  Navigator.of(context).pop();
                }
              },
              onSecondaryButtonPressed: () {
                Navigator.of(context).pop();
              },
              isLoading: isApproveLoading,
            ),
      );
    } else if (value == 'Hold') {
      await showDialog(
        context: Get.context!,
        builder:
            (context) => GenericDialogBox(
              headerText: 'Hold',
              content: Form(
                key: approveFormKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      AppText(
                        'Are you sure you want to Hold?',
                        softWrap: true,
                        style: TextStyles.medium(context),
                      ),
                      20.heightGap,
                      buildRemarkField(),
                    ],
                  ),
                ),
              ),
              primaryButtonText: 'Hold',
              secondaryButtonText: 'Cancel',
              onPrimaryButtonPressed: () async {
                if (approveFormKey.currentState!.validate()) {
                  try {
                    isApproveLoading.value = true;
                    await postFinanceVoucher(
                      bankPayment,
                      paymentStatus: 'Hold',
                    );
                  } catch (e) {
                    print('Error holding voucher: $e');
                  } finally {
                    isApproveLoading.value = false;
                    Navigator.of(context).pop();
                  }
                }
              },
              onSecondaryButtonPressed: () {
                Navigator.of(context).pop();
              },
              isLoading: isApproveLoading,
            ),
      );
    } else if (value == 'Reject') {
      await showDialog(
        context: Get.context!,
        builder:
            (context) => GenericDialogBox(
              headerText: 'Reject',
              content: Form(
                key: rejectFormKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      AppText(
                        'Are you sure you want to Reject?',
                        softWrap: true,
                        style: TextStyles.medium(context),
                      ),
                      20.heightGap,
                      buildRemarkField(),
                    ],
                  ),
                ),
              ),
              primaryButtonText: 'Reject',
              secondaryButtonText: 'Cancel',
              onPrimaryButtonPressed: () async {
                if (rejectFormKey.currentState!.validate()) {
                  try {
                    isRejectLoading.value = true;
                    await postFinanceVoucher(
                      bankPayment,
                      paymentStatus: 'Reject',
                    );
                  } catch (e) {
                    print('Error rejecting voucher: $e');
                  } finally {
                    isRejectLoading.value = false;
                    Navigator.of(context).pop();
                  }
                }
              },
              onSecondaryButtonPressed: () {
                Navigator.of(context).pop();
              },
              isLoading: isRejectLoading,
            ),
      );
    }
    remarkController.clear();
  }

  Widget buildRemarkField() {
    return AppTextField(
      controller: remarkController,
      hint: 'Enter Remarks',
      isValidator: true,
      width: Get.width,
      minLines: 3,
      height: 100,
      maxLines: null,
    );
  }

  @override
  void onInit() {
    final userModel = LocalDB.getUserModel();
    super.onInit();
    final subMenus = userModel?.getSubMenusFor(MenuType.finance) ?? [];
    final tabs = <String>[];
    final views = <Widget>[];

    subMenus.forEach((subMenu) {
      tabs.add(subMenu.key);
      views.add(FinanceView(subMenuType: subMenu));
    });
    currentSubMenu.value = subMenus.first;

    myTabs = tabs;
    tabViews = views;

    bankPaymentDataSource = BankPaymentDataSource(
      bankPaymentList,
      rowsPerPage: rowsPerPage.value,
    );
    bankReceiptDataSource = BankReceiptDataSource(
      bankReceiptList,
      rowsPerPage: rowsPerPage.value,
    );
    cashPaymentDataSource = CashPaymentDataSource(
      cashPaymentList,
      rowsPerPage: rowsPerPage.value,
    );
    cashReceiptDataSource = CashReceiptDataSource(
      cashReceiptList,
      rowsPerPage: rowsPerPage.value,
    );
    journalVoucherDataSource = JournalVoucherDataSource(
      journalVoucherList,
      rowsPerPage: rowsPerPage.value,
    );
    selectBranch.value = BranchList.first;
    if (Get.arguments != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final data = Get.arguments;
        if (data == null) return;
        final subMenuType = data['subMenuType'];
        final srl = data['Srl'];
        goTOSubMenu(subMenuType, srl);
      });
    } else {
      getAllData(mainType: currentSubMenu.value);
    }
    Get.find<NotificationController>().fetchNotifications();
  }

  Future<void> goTOSubMenu(SubMenuType? menuType, String srl) async {
    if (menuType == null) return;
    final subMenuTypeList =
        LocalDB.getUserModel()?.getSubMenusFor(MenuType.finance) ?? [];
    final index = subMenuTypeList.indexOf(menuType);

    if (index >= 0) {
      selectedTabIndex.value = index;
      currentSubMenu.value = menuType;
    }

    await getAllData(mainType: currentSubMenu.value);
    searchController.text = srl;
    filterData(srl);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
