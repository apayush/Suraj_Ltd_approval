import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/cash_receipt.dart';

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
import '../view/widgets/tabs/widgets/bank_payment.dart';
import '../view/widgets/tabs/widgets/bank_receipt.dart';
import '../view/widgets/tabs/widgets/cash_payment.dart';

class FinanceController extends GetxController
    with GetTickerProviderStateMixin {
  RxBool isLoading = false.obs;

  final userModel = LocalDB.getUserModel();
  MenuType currentMenu = MenuType.finance;
  final Rx<SubMenuType> currentSubMenu = SubMenuType.bankPayment.obs;

  late TabController tabController;
  List<Tab> myTabs = [];
  List<Widget> tabViews = [];
  final GlobalKey<FormState> approveFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> rejectFormKey = GlobalKey<FormState>();

  // ! Two lists to hold the Api data and filtered data for Bank Payment
  RxList<BankPaymentModel> bankPaymentList = <BankPaymentModel>[].obs;
  RxList<BankPaymentModel> filteredBankPaymentList = <BankPaymentModel>[].obs;

  // ! Two lists to hold the Api data and filtered data for Bank Receipt
  RxList<BankPaymentModel> bankReceiptList = <BankPaymentModel>[].obs;
  RxList<BankPaymentModel> filteredBankReceiptList = <BankPaymentModel>[].obs;

  // ! Two lists to hold the Api data and filtered data for Cash Payment
  RxList<BankPaymentModel> cashPaymentList = <BankPaymentModel>[].obs;
  RxList<BankPaymentModel> filteredCashPaymentList = <BankPaymentModel>[].obs;

  // ! Two lists to hold the Api data and filtered data for Cash Receipt
  RxList<BankPaymentModel> cashReceiptList = <BankPaymentModel>[].obs;
  RxList<BankPaymentModel> filteredCashReceiptList = <BankPaymentModel>[].obs;

  //! DataGridSource for the SfDataGrid
  late BankPaymentDataSource bankPaymentDataSource;
  late BankReceiptDataSource bankReceiptDataSource;
  late CashPaymentDataSource cashPaymentDataSource;
  late CashReceiptDataSource cashReceiptDataSource;

  // ! Get All Finance Module Data Table
  Future<void> getAllData({required SubMenuType mainType}) async {
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
          List<BankPaymentModel> payment = BankPaymentModel.fromDecodedJsonList(
            response.data ?? [],
          );
          switch (mainType) {
            case SubMenuType.bankPayment:
              bankPaymentList.assignAll(payment);
              bankPaymentDataSource.updateDataSource(bankPaymentList);
              break;
            case SubMenuType.bankReceipt:
              bankReceiptList.assignAll(payment);
              bankReceiptDataSource.updateDataSource(bankReceiptList);
              break;
            case SubMenuType.cashPayment:
              cashPaymentList.assignAll(payment);
              cashPaymentDataSource.updateDataSource(cashPaymentList);
              break;
            case SubMenuType.cashReceipt:
              cashReceiptList.assignAll(payment);
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
  Future<void> getBankpaymentReport(BankPaymentModel bankPayment) async {
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
    BankPaymentModel bankPayment, {
    required String paymentStatus,
  }) async {
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
          'mRemarks': 'test',
        },
      );
      if (response.statusCode == 200) {
        Get.back();
        if (response.data['Success'] == true) {
          AppUtils.showSnackBar('Voucher Updated Successfully');
        }
        // formKey.currentState?.reset();
        remarkController.clear();
        getAllData(mainType: currentSubMenu.value);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ! RESET FITERS
  resetFilters() {
    getAllData(mainType: currentSubMenu.value);
  }

  // ! Search Functionality
  TextEditingController searchController = TextEditingController();

  void filterData(String searchText) {
    final query = searchText.toLowerCase().trim();

    List<BankPaymentModel> sourceList;
    RxList<BankPaymentModel> filteredList;
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

    dataSource.updateDataSource(filteredList);
  }

  // ! Grid Pagination
  var rowsPerPage = 10.obs;

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
    BankPaymentModel bankPayment,
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
              await postFinanceVoucher(bankPayment, paymentStatus: 'Approve');
            }
          },
          onSecondaryButtonPressed: () {
            Get.back();
          },
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
          onPrimaryButtonPressed: () {
            if (rejectFormKey.currentState!.validate()) {
              postFinanceVoucher(bankPayment, paymentStatus: 'Reject');
            }
          },
          onSecondaryButtonPressed: () {
            Get.back();
          },
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
    super.onInit();
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
      views.add(CashReceipt());
    }

    myTabs = tabs;
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
      if (menuType == SubMenuType.bankPayment) {
        tabController.animateTo(0);
      } else if (menuType == SubMenuType.bankReceipt) {
        tabController.animateTo(1);
      } else if (menuType == SubMenuType.cashPayment) {
        tabController.animateTo(2);
      } else if (menuType == SubMenuType.cashReceipt) {
        tabController.animateTo(3);
      }
    });
    getAllData(mainType: currentSubMenu.value);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
