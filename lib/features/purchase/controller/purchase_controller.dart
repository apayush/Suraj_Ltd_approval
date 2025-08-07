import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/utills/device_type.dart';
import 'package:suraj_approval/features/notifications/controller/notification_controller.dart';
import '../../../core/constants/api_url.dart';
import '../../../core/constants/app_enum.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/local_db.dart';
import '../../../core/utills/app_module_container.dart';
import '../../../core/utills/app_utills.dart';
import '../../../core/utills/table_data_sources/purchase_module/purchase_invoice_data_source.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../finance/model/bank_payment_model.dart';
import '../view/widgets/tabs/widgets/purchase_view.dart';

class PurchaseController extends GetxController
    with GetTickerProviderStateMixin {
  RxBool isLoading = false.obs;

  RxBool isApproveLoading = false.obs;
  RxBool isRejectLoading = false.obs;

  MenuType currentMenu = MenuType.purchase;
  final Rx<SubMenuType> currentSubMenu = SubMenuType.purchaseInvoice.obs;

  late TabController tabController;
  List<Tab> myTabs = [];
  List<Widget> tabViews = [];

  final GlobalKey<FormState> approveFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> rejectFormKey = GlobalKey<FormState>();

  // ! Two lists to hold the Api data and filtered data for Purchase Invoice
  RxList<VoucherModel> purchaseInvoiceList = <VoucherModel>[].obs;
  RxList<VoucherModel> filteredPurchaseInvoiceList =
      <VoucherModel>[].obs;

  //! DataGridSource for the SfDataGrid
  late PurchaseInvoiceDataSource purchaseInvoiceDataSource;

  // ! Get All Purchase Module Data Table
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
          'mDeviceType': DeviceType.isMobile(Get.context!) ? 'mobile' : 'web',
        };
        final response = await ApiService.getData(
          ApiUrl.getAuthorisationListFilter,
          queryParams: param,
        );
        if (response.statusCode == 200) {
          List<VoucherModel> voucher =
          VoucherModel.fromDecodedJsonList(response.data ?? []);
          switch (mainType) {
            case SubMenuType.purchaseInvoice:
              purchaseInvoiceList.assignAll(voucher);
              filteredPurchaseInvoiceList.value = (voucher);
              purchaseInvoiceDataSource.updateDataSource(purchaseInvoiceList);
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

  // ! Get Purchase Module Hold Data Table
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
          List<VoucherModel> voucher =
          VoucherModel.fromDecodedJsonList(response.data ?? []);
          switch (mainType) {
            case SubMenuType.purchaseInvoice:
              purchaseInvoiceList.assignAll(voucher);
              filteredPurchaseInvoiceList.value = (voucher);
              purchaseInvoiceDataSource.updateDataSource(purchaseInvoiceList);
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
  Future<void> getVoucherReport(VoucherModel voucher) async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(
        ApiUrl.getVoucherReport,
        queryParams: {'mLinkField': voucher.linkField},
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

  // ! Approve Reject Purchase Voucher
  Future<void> postVoucher(
      VoucherModel voucher, {
        required String voucherStatus,
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
          'LinkField': voucher.linkField,
          'mAuthorise': voucherStatus,
          'mRemarks': remarkController.value.text,
          'mDeviceType': DeviceType.isMobile(Get.context!) ? 'mobile' : 'web',
        },
      );
      if (response.statusCode == 200) {
        Get.back();
        if (response.data['Success'] == 'Approve') {
          AppUtils.showSnackBar('Voucher Approved Successfully');
        } else if (response.data['Success'] == 'Hold') {
          AppUtils.showSnackBar('Voucher Hold Successfully');
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
    getAllHoldData(mainType: currentSubMenu.value);
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
      case SubMenuType.purchaseInvoice:
        sourceList = purchaseInvoiceList;
        filteredList = filteredPurchaseInvoiceList;
        dataSource = purchaseInvoiceDataSource;
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
        case SubMenuType.purchaseInvoice:
          filteredPurchaseInvoiceList.value = filteredList.toList();
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
      case SubMenuType.purchaseInvoice:
        purchaseInvoiceDataSource.setRowsPerPage(newRowsPerPage);
        break;
      default:
        break;
    }
  }

  // ! Handle Action Menu Selection
  TextEditingController remarkController = TextEditingController();

  Future<void> handleMenuSelection(
      String value,
      VoucherModel voucher,
      ) async {
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
    final subMenus = userModel?.getSubMenusFor(MenuType.purchase) ?? [];
    final tabs = <Tab>[];
    final views = <Widget>[];

    subMenus.forEach((subMenu) {
      tabs.add(Tab(text: subMenu.key));
      views.add(PurchaseView(subMenuType: subMenu));
    });
    currentSubMenu.value = subMenus.first;

    myTabs = tabs;
    tabViews = views;
    tabController = TabController(length: myTabs.length, vsync: this);

    purchaseInvoiceDataSource = PurchaseInvoiceDataSource(
      purchaseInvoiceList,
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
        LocalDB.getUserModel()?.getSubMenusFor(MenuType.purchase) ?? [];
    final index = subMenuTypeList.indexOf(menuType);

    if (menuType == SubMenuType.purchaseInvoice) {
      tabController.animateTo(index);
      currentSubMenu.value = SubMenuType.purchaseInvoice;
    // } else if (menuType == SubMenuType.purchaseIndent) {
    //   tabController.animateTo(index);
    //   currentSubMenu.value = SubMenuType.purchaseIndent;
    // } else if (menuType == SubMenuType.purchaseOrder) {
    //   tabController.animateTo(index);
    //   currentSubMenu.value = SubMenuType.purchaseOrder;
    // } else if (menuType == SubMenuType.gateInward) {
    //   tabController.animateTo(index);
    //   currentSubMenu.value = SubMenuType.gateInward;
    // } else if (menuType == SubMenuType.goodsReceiptNote) {
    //   tabController.animateTo(index);
    //   currentSubMenu.value = SubMenuType.goodsReceiptNote;
    // } else if (menuType == SubMenuType.purchaseCreditNote) {
    //   tabController.animateTo(index);
    //   currentSubMenu.value = SubMenuType.purchaseCreditNote;
    // } else if (menuType == SubMenuType.purchaseDebitNote) {
    //   tabController.animateTo(index);
    //   currentSubMenu.value = SubMenuType.purchaseDebitNote;
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
