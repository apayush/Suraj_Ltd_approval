import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/api_url.dart';
import '../../../core/service/api_service.dart';
import '../../../core/utills/table_data_sources/bank_payment/bank_payment_data_source.dart';
import '../model/bank_payment_model.dart';

class BankPaymentController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static BankPaymentController get instance => Get.find();

  RxBool isLoading = false.obs;

  // Two lists to hold the Api data and filtered data
  RxList<BankPaymentModel> bankPaymentList = <BankPaymentModel>[].obs;
  RxList<BankPaymentModel> filteredBankPaymentList = <BankPaymentModel>[].obs;

  // DataGridSource for the SfDataGrid
  late BankPaymentDataSource bankPaymentDataSource;

  Future<void> getBankPaymentData() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(ApiUrl.baseUrl);
      if (response.statusCode == 200) {
        List<BankPaymentModel> payment = BankPaymentModel.fromDecodedJsonList(
          response.data ?? [],
        );

        // final data = response.data;
        bankPaymentList.assignAll(
          payment,
        ); // Use assignAll to replace all items
        bankPaymentList.assignAll(payment);
        bankPaymentDataSource.updateDataSource(payment);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  resetFilters() {
    getBankPaymentData();
  }

  var rowsPerPage = 10.obs;
  void changeRowsPerPage(int newRowsPerPage) {
    rowsPerPage.value = newRowsPerPage;
    bankPaymentDataSource.setRowsPerPage(newRowsPerPage);
  }

  void handleMenuSelection(String value, BankPaymentModel bankPayment) {
    if (value == 'View') {
    } else if (value == 'Approve') {
    } else if (value == 'Reject') {}
    print('value is $value');
  }

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
