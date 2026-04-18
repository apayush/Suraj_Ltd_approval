import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/utills/device_type.dart';
import 'package:suraj_approval/core/utills/table_data_sources/sales_module/sales_credit_note_data_source.dart';
import 'package:suraj_approval/features/notifications/controller/notification_controller.dart';

import '../../../core/constants/api_url.dart';
import '../../../core/constants/app_enum.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/local_db.dart';
import '../../../core/utills/app_module_container.dart';
import '../../../core/utills/app_utills.dart';
import '../../../core/utills/table_data_sources/sales_module/sales_enquiry_data_source.dart';
import '../../../core/utills/table_data_sources/sales_module/sales_order_data_source.dart';
import '../../../core/utills/table_data_sources/sales_module/sales_quotation_data_source.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../finance/model/bank_payment_model.dart';
import '../view/widgets/tabs/widgets/sales_view.dart';

class SalesController extends GetxController {
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

  MenuType currentMenu = MenuType.sales;
  final Rx<SubMenuType> currentSubMenu = SubMenuType.salesOrder.obs;

  RxInt selectedTabIndex = 0.obs;
  List<String> myTabs = [];
  List<Widget> tabViews = [];

  final GlobalKey<FormState> approveFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> rejectFormKey = GlobalKey<FormState>();

  // ! Two lists to hold the Api data and filtered data for Sales Order
  RxList<VoucherModel> salesOrderList = <VoucherModel>[].obs;
  RxList<VoucherModel> filteredSalesOrderList = <VoucherModel>[].obs;

  // ! Two lists to hold the Api data and filtered data for Sales Quotation
  RxList<VoucherModel> salesQuotationList = <VoucherModel>[].obs;
  RxList<VoucherModel> filteredSalesQuotationList = <VoucherModel>[].obs;

  // ! Two lists to hold the Api data and filtered data for Sales Quotation
  RxList<VoucherModel> salesEnquiryList = <VoucherModel>[].obs;
  RxList<VoucherModel> filteredSalesEnquiryList = <VoucherModel>[].obs;

  // ! Two lists to hold the Api data and filtered data for Sales Quotation
  RxList<VoucherModel> salesCreditNoteList = <VoucherModel>[].obs;
  RxList<VoucherModel> filteredSalesCreditNoteList = <VoucherModel>[].obs;

  //! DataGridSource for the SfDataGrid
  late SalesOrderDataSource salesOrderDataSource;
  late SalesQuotationDataSource salesQuotationDataSource;
  late SalesEnquiryDataSource salesEnquiryDataSource;
  late SalesCreditNoteDataSource salesCreditNoteDataSource;

  // ! Get All Sales Module Data Table
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
          List<VoucherModel> voucher = VoucherModel.fromDecodedJsonList(
            response.data ?? [],
          );
          switch (mainType) {
            case SubMenuType.salesOrder:
              salesOrderList.assignAll(voucher);
              filteredSalesOrderList.value = (voucher);
              salesOrderDataSource.updateDataSource(salesOrderList);
              break;
            case SubMenuType.salesQuotation:
              salesQuotationList.assignAll(voucher);
              filteredSalesQuotationList.value = (voucher);
              salesQuotationDataSource.updateDataSource(salesQuotationList);
              break;
            case SubMenuType.salesEnquiry:
              salesEnquiryList.assignAll(voucher);
              filteredSalesEnquiryList.value = (voucher);
              salesEnquiryDataSource.updateDataSource(salesEnquiryList);
              break;
            case SubMenuType.salesCreditNote:
              salesCreditNoteList.assignAll(voucher);
              filteredSalesCreditNoteList.value = (voucher);
              salesCreditNoteDataSource.updateDataSource(salesCreditNoteList);
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

  // ! Get Sales Module Hold Data Table
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
          List<VoucherModel> voucher = VoucherModel.fromDecodedJsonList(
            response.data ?? [],
          );
          switch (mainType) {
            case SubMenuType.salesOrder:
              salesOrderList.assignAll(voucher);
              filteredSalesOrderList.value = (voucher);
              salesOrderDataSource.updateDataSource(salesOrderList);
              break;
            case SubMenuType.salesQuotation:
              salesQuotationList.assignAll(voucher);
              filteredSalesQuotationList.value = (voucher);
              salesQuotationDataSource.updateDataSource(salesQuotationList);
              break;
            case SubMenuType.salesEnquiry:
              salesEnquiryList.assignAll(voucher);
              filteredSalesEnquiryList.value = (voucher);
              salesEnquiryDataSource.updateDataSource(salesEnquiryList);
              break;
            case SubMenuType.salesCreditNote:
              salesCreditNoteList.assignAll(voucher);
              filteredSalesCreditNoteList.value = (voucher);
              salesCreditNoteDataSource.updateDataSource(salesCreditNoteList);
              break;
            default:
              break;
          }
        }
      }
    } catch (e) {
      print(e);
      switch (mainType) {
        case SubMenuType.salesOrder:
          salesOrderList.clear();
          filteredSalesOrderList.clear();
          salesOrderDataSource.updateDataSource(salesOrderList);
          break;
        case SubMenuType.salesQuotation:
          salesQuotationList.clear();
          filteredSalesQuotationList.clear();
          salesQuotationDataSource.updateDataSource(salesQuotationList);
          break;
        case SubMenuType.salesEnquiry:
          salesEnquiryList.clear();
          filteredSalesEnquiryList.clear();
          salesEnquiryDataSource.updateDataSource(salesEnquiryList);
          break;
        case SubMenuType.salesCreditNote:
          salesCreditNoteList.clear();
          filteredSalesCreditNoteList.clear();
          salesCreditNoteDataSource.updateDataSource(salesCreditNoteList);
          break;
        default:
          break;
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ! GET PDF Report
  Future<void> getVoucherReport(VoucherModel voucher) async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(
        ApiUrl.getVoucherReport,
        queryParams: {'mLinkField': voucher.linkField},
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

  // ! Approve Reject Sales Voucher
  Future<void> postVoucher(
    VoucherModel voucher, {
    required String voucherStatus,
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
          'mAuthorise': voucherStatus,
          'mBranchName': voucher.mBranch,
          'mRemarks': remarkController.value.text,
          'mDeviceType': DeviceType.isMobile(Get.context!) ? 'mobile' : 'web',
        },
      );
      if (response.statusCode == 200) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        if (response.data['Success'] == 'Approve') {
          AppUtils.showSnackBar('Voucher Approved Successfully');
        } else if (response.data['Success'] == 'Hold') {
          AppUtils.showSnackBar('Voucher Hold Successfully');
        } else if (response.data['Success'] == 'Reject') {
          AppUtils.showSnackBar('Voucher Rejected Successfully');
        }
        remarkController.clear();
        getAllData(mainType: currentSubMenu.value);
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

  void toggleHoldMode() {
    isHoldVoucherModelEnabled.value = !isHoldVoucherModelEnabled.value;
    if (isHoldVoucherModelEnabled.value) {
      getAllHoldData(mainType: currentSubMenu.value);
    } else {
      getAllData(mainType: currentSubMenu.value);
    }
  }

  // ! Search Functionality
  TextEditingController searchController = TextEditingController();
  RxBool isSearchActive = false.obs;

  void filterData(String searchText) {
    isSearchActive.value = searchText.trim().isNotEmpty;
    final query = searchText.toLowerCase().trim();
    List<VoucherModel> sourceList;
    RxList<VoucherModel> filteredList;
    dynamic dataSource;

    switch (currentSubMenu.value) {
      case SubMenuType.salesOrder:
        sourceList = salesOrderList;
        filteredList = filteredSalesOrderList;
        dataSource = salesOrderDataSource;
        break;
      case SubMenuType.salesQuotation:
        sourceList = salesQuotationList;
        filteredList = filteredSalesQuotationList;
        dataSource = salesQuotationDataSource;
        break;
      case SubMenuType.salesEnquiry:
        sourceList = salesEnquiryList;
        filteredList = filteredSalesEnquiryList;
        dataSource = salesEnquiryDataSource;
        break;
      case SubMenuType.salesCreditNote:
        sourceList = salesCreditNoteList;
        filteredList = filteredSalesCreditNoteList;
        dataSource = salesCreditNoteDataSource;
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
        case SubMenuType.salesOrder:
          filteredSalesOrderList.value = filteredList.toList();
          break;
        case SubMenuType.salesQuotation:
          filteredSalesQuotationList.value = filteredList.toList();
          break;
        case SubMenuType.salesEnquiry:
          filteredSalesEnquiryList.value = filteredList.toList();
          break;
        case SubMenuType.salesCreditNote:
          filteredSalesCreditNoteList.value = filteredList.toList();
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

  void clearSearch() {
    searchController.clear();
    isSearchActive.value = false;
    filterData('');
  }

  void changeRowsPerPage(int newRowsPerPage) {
    rowsPerPage.value = newRowsPerPage;
    switch (currentSubMenu.value) {
      case SubMenuType.salesOrder:
        salesOrderDataSource.setRowsPerPage(newRowsPerPage);
        break;
      case SubMenuType.salesQuotation:
        salesQuotationDataSource.setRowsPerPage(newRowsPerPage);
        break;
      case SubMenuType.salesEnquiry:
        salesEnquiryDataSource.setRowsPerPage(newRowsPerPage);
        break;
      case SubMenuType.salesCreditNote:
        salesCreditNoteDataSource.setRowsPerPage(newRowsPerPage);
        break;
      default:
        break;
    }
  }

  // ! Handle Action Menu Selection
  TextEditingController remarkController = TextEditingController();

  Future<void> handleMenuSelection(String value, VoucherModel voucher) async {
    if (value == 'View') {
      getVoucherReport(voucher);
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
            await postVoucher(voucher, voucherStatus: 'Approve');
            isApproveLoading.value = false;
            // }
            if (Get.isDialogOpen ?? false) {
              Get.back();
            }
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
              await postVoucher(voucher, voucherStatus: 'Hold');
              isApproveLoading.value = false;
              if (Get.isDialogOpen ?? false) {
                Get.back();
              }
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
              await postVoucher(voucher, voucherStatus: 'Reject');
              isRejectLoading.value = false;
              if (Get.isDialogOpen ?? false) {
                Get.back();
              }
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
    final subMenus = userModel?.getSubMenusFor(MenuType.sales) ?? [];
    final tabs = <String>[];
    final views = <Widget>[];

    subMenus.forEach((subMenu) {
      tabs.add(subMenu.key);
      views.add(SalesView(subMenuType: subMenu));
    });
    currentSubMenu.value = subMenus.first;

    myTabs = tabs;
    tabViews = views;

    salesOrderDataSource = SalesOrderDataSource(
      salesOrderList,
      rowsPerPage: rowsPerPage.value,
    );
    salesQuotationDataSource = SalesQuotationDataSource(
      salesQuotationList,
      rowsPerPage: rowsPerPage.value,
    );
    salesEnquiryDataSource = SalesEnquiryDataSource(
      salesEnquiryList,
      rowsPerPage: rowsPerPage.value,
    );
    salesCreditNoteDataSource = SalesCreditNoteDataSource(
      salesCreditNoteList,
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
        LocalDB.getUserModel()?.getSubMenusFor(MenuType.sales) ?? [];
    final index = subMenuTypeList.indexOf(menuType);

    if (index >= 0) {
      selectedTabIndex.value = index;
      currentSubMenu.value = menuType;
    }

    await getAllData(mainType: currentSubMenu.value);
    searchController.text = srl;
    isSearchActive.value = true;
    filterData(srl);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
