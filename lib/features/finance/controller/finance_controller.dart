import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/utills/device_type.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/finance_view.dart';

import '../../../core/constants/api_url.dart';
import '../../../core/constants/app_enum.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/local_db.dart';
import '../../../core/utills/app_module_container.dart';
import '../../../core/utills/app_utills.dart';
import '../../../core/utills/table_data_sources/finance_module/bank_payment_data_source.dart';
import '../../../core/utills/table_data_sources/finance_module/bank_receipt_data_source.dart';
import '../../../core/utills/table_data_sources/finance_module/cash_payment_data_source.dart';
import '../../../core/utills/table_data_sources/finance_module/cash_receipt_data_source.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/common_widgets.dart';
import '../model/bank_payment_model.dart';

class FinanceController extends GetxController
    with GetTickerProviderStateMixin {
  RxBool isLoading = false.obs;
  RxBool isApproveLoading = false.obs;
  RxBool isRejectLoading = false.obs;

  MenuType currentMenu = MenuType.finance;
  final Rx<SubMenuType> currentSubMenu = SubMenuType.bankPayment.obs;

  late TabController tabController;
  List<Tab> myTabs = [];
  List<Widget> tabViews = [];
  final GlobalKey<FormState> approveFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> rejectFormKey = GlobalKey<FormState>();

  // ! Two lists to hold the Api data and filtered data for Bank Payment
  RxList<FinancePaymentModel> bankPaymentList = <FinancePaymentModel>[].obs;
  RxList<FinancePaymentModel> filteredBankPaymentList =
      <FinancePaymentModel>[].obs;

  // ! Two lists to hold the Api data and filtered data for Bank Receipt
  RxList<FinancePaymentModel> bankReceiptList = <FinancePaymentModel>[].obs;
  RxList<FinancePaymentModel> filteredBankReceiptList =
      <FinancePaymentModel>[].obs;

  // ! Two lists to hold the Api data and filtered data for Cash Payment
  RxList<FinancePaymentModel> cashPaymentList = <FinancePaymentModel>[].obs;
  RxList<FinancePaymentModel> filteredCashPaymentList =
      <FinancePaymentModel>[].obs;

  // ! Two lists to hold the Api data and filtered data for Cash Receipt
  RxList<FinancePaymentModel> cashReceiptList = <FinancePaymentModel>[].obs;
  RxList<FinancePaymentModel> filteredCashReceiptList =
      <FinancePaymentModel>[].obs;

  //! DataGridSource for the SfDataGrid
  late BankPaymentDataSource bankPaymentDataSource;
  late BankReceiptDataSource bankReceiptDataSource;
  late CashPaymentDataSource cashPaymentDataSource;
  late CashReceiptDataSource cashReceiptDataSource;

  // ! Get All Finance Module Data Table
  Future<void> getAllData({required SubMenuType mainType}) async {
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
          'mDeviceType': '',
        };
        final response = await ApiService.getData(
          ApiUrl.getAuthorisationListFilter,
          queryParams: param,
        );
        if (response.statusCode == 200) {
          List<FinancePaymentModel> payment =
              FinancePaymentModel.fromDecodedJsonList(response.data ?? []);
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

  // ! GET PDF Report
  Future<void> getBankpaymentReport(FinancePaymentModel bankPayment) async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(
        ApiUrl.getBankpaymentReport,
        queryParams: {'mLinkField': bankPayment.linkField},
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

  // ! Approve Reject Finance Voucher
  Future<void> postFinanceVoucher(
    FinancePaymentModel bankPayment, {
    required String paymentStatus,
  }) async {
    final userModel = LocalDB.getUserModel();
    isLoading.value = true;
    try {
      final matchedUserDetail = userModel?.getDetailFor(
        currentMenu,
        currentSubMenu.value,
      );
      final response = await ApiService.postData(
        ApiUrl.authoriseFinanceVoucher,
        queryParams: {
          'mUser': userModel?.mUser,
          'mUserLevel': matchedUserDetail?.userLevel,
          'LinkField': bankPayment.linkField,
          'mAuthorise': paymentStatus,
          'mRemarks': remarkController.value.text,
          'mDeviceType': DeviceType.isMobile(Get.context!) ? 'mobile' : 'web',
        },
      );
      if (response.statusCode == 200) {
        Get.back();
        if (response.data['Success'] == 'Approve') {
          AppUtils.showSnackBar('Voucher Approved Successfully');
        } else if (response.data['Success'] == 'Reject') {
          AppUtils.showSnackBar('Voucher Rejected Successfully');
        }
        remarkController.clear();
        getAllData(mainType: currentSubMenu.value);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ! RESET FILTERS
  resetFilters() {
    getAllData(mainType: currentSubMenu.value);
  }

  // ! Search Functionality
  TextEditingController searchController = TextEditingController();

  void filterData(String searchText) {
    final query = searchText.toLowerCase().trim();

    List<FinancePaymentModel> sourceList;
    RxList<FinancePaymentModel> filteredList;
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
      default:
        break;
    }
  }

  // ! Handle Action Menu Selection
  TextEditingController remarkController = TextEditingController();

  Future<void> handleMenuSelection(
    String value,
    FinancePaymentModel bankPayment,
  ) async {
    if (value == 'View') {
      getBankpaymentReport(bankPayment);
    } else if (value == 'Approve') {
      await Get.dialog(
        GenericDialogBox(
          headerText: 'Approve Bank Payment',
          content: Form(
            key: approveFormKey,
            child: Container(
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
          ),
          primaryButtonText: 'Approve',
          secondaryButtonText: 'Cancel',
          onPrimaryButtonPressed: () async {
            if (approveFormKey.currentState!.validate()) {
              isApproveLoading.value = true;
              await postFinanceVoucher(bankPayment, paymentStatus: 'Approve');
              isApproveLoading.value = false;
            }
          },
          onSecondaryButtonPressed: () {
            Get.back();
          },
          isLoading: isApproveLoading,
        ),
      );
    } else if (value == 'Reject') {
      await Get.dialog(
        GenericDialogBox(
          headerText: 'Reject Bank Payment',
          content: Form(
            key: rejectFormKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  AppText(
                    'Are you sure you want to Reject?',
                    softWrap: true,
                    style: TextStyles.medium(Get.context!),
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
              isRejectLoading.value = true;
              await postFinanceVoucher(bankPayment, paymentStatus: 'Reject');
              isRejectLoading.value = false;
            }
          },
          onSecondaryButtonPressed: () {
            Get.back();
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
    final tabs = <Tab>[];
    final views = <Widget>[];

    subMenus.forEach((subMenu) {
      tabs.add(Tab(text: subMenu.key));
      views.add(FinanceView(subMenuType: subMenu));
    });

    // if (subMenus.contains(SubMenuType.bankPayment)) {
    //   tabs.add(const Tab(text: 'Bank Payment'));
    //   views.add(FinanceView(subMenuType: SubMenuType.bankPayment));
    // }
    //
    // if (subMenus.contains(SubMenuType.bankReceipt)) {
    //   tabs.add(const Tab(text: 'Bank Receipt'));
    //   views.add(FinanceView(subMenuType: SubMenuType.bankReceipt));
    // }
    //
    // if (subMenus.contains(SubMenuType.cashPayment)) {
    //   tabs.add(const Tab(text: 'Cash Payment'));
    //   views.add(FinanceView(subMenuType: SubMenuType.cashPayment));
    // }
    //
    // if (subMenus.contains(SubMenuType.cashReceipt)) {
    //   tabs.add(const Tab(text: 'Cash Receipt'));
    //   views.add(FinanceView(subMenuType: SubMenuType.cashReceipt));
    // }

    myTabs = tabs;
    tabViews = views;
    tabController = TabController(length: myTabs.length, vsync: this);

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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final menuType = Get.arguments as SubMenuType?;
      goTOSubMenu(menuType);
    });
    getAllData(mainType: currentSubMenu.value);
  }

  void goTOSubMenu(SubMenuType? menuType) {
    if (menuType == null) return;
    final subMenuTypeList =
        LocalDB.getUserModel()?.getSubMenusFor(MenuType.finance) ?? [];
    final index = subMenuTypeList.indexOf(menuType);

    if (menuType == SubMenuType.bankPayment) {
      tabController.animateTo(index);
      currentSubMenu.value = SubMenuType.bankPayment;
    } else if (menuType == SubMenuType.bankReceipt) {
      tabController.animateTo(index);
      currentSubMenu.value = SubMenuType.bankReceipt;
    } else if (menuType == SubMenuType.cashPayment) {
      tabController.animateTo(index);
      currentSubMenu.value = SubMenuType.cashPayment;
    } else if (menuType == SubMenuType.cashReceipt) {
      tabController.animateTo(index);
      currentSubMenu.value = SubMenuType.cashReceipt;
    }
    getAllData(mainType: currentSubMenu.value);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
