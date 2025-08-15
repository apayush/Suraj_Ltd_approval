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
  RxBool isHoldVoucherModelEnabled = false.obs;

  MenuType currentMenu = MenuType.finance;
  final Rx<SubMenuType> currentSubMenu = SubMenuType.bankPayment.obs;

  late TabController tabController;
  List<Tab> myTabs = [];
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

  //! DataGridSource for the SfDataGrid
  late BankPaymentDataSource bankPaymentDataSource;
  late BankReceiptDataSource bankReceiptDataSource;
  late CashPaymentDataSource cashPaymentDataSource;
  late CashReceiptDataSource cashReceiptDataSource;

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
        final param = {
          'mUser': userModel?.mUser,
          'mUserLevel': matchedUserDetail.userLevel,
          'MainType': mainType.key,
        };
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
  Future<void> getBankpaymentReport(VoucherModel bankPayment) async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(
        ApiUrl.getVoucherReport,
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
    VoucherModel bankPayment, {
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
        ApiUrl.authoriseVoucher,
        queryParams: {
          'mUser': userModel?.mUser,
          'mUserLevel': matchedUserDetail?.userLevel,
          'LinkField': bankPayment.linkField,
          'mAuthorise': paymentStatus,
          'mRemarks': remarkController.value.text,
          'mDeviceType': kIsWeb ? 'web' : 'mobile',
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
    VoucherModel bankPayment,
  ) async {
    if (value == 'View') {
      getBankpaymentReport(bankPayment);
    } else if (value == 'Approve') {
      await Get.dialog(
        GenericDialogBox(
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
            // if (approveFormKey.currentState!.validate()) {
            isApproveLoading.value = true;
            await postFinanceVoucher(bankPayment, paymentStatus: 'Approve');
            isApproveLoading.value = false;
            // }
          },
          onSecondaryButtonPressed: () {
            Get.back();
          },
          isLoading: isApproveLoading,
        ),
      );
    } else if (value == 'Hold') {
      await Get.dialog(
        GenericDialogBox(
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
                    style: TextStyles.medium(Get.context!),
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
              isApproveLoading.value = true;
              await postFinanceVoucher(bankPayment, paymentStatus: 'Hold');
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
    currentSubMenu.value = subMenus.first;

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

    await getAllData(mainType: currentSubMenu.value);
    searchController.text = srl;
    filterData(srl);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
