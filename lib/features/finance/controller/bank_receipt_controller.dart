import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/api_url.dart';
import '../../../core/service/api_service.dart';

class BankReceiptController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static BankReceiptController get instance => Get.find();

  RxBool isLoading = false.obs;

  Future<void> getBankReceiptData() async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(ApiUrl.baseUrl);
      if (response.statusCode == 200) {
        print('Response Data: ${response.data}');
      }
      print(response.statusCode);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getBankReceiptData();
  }
}
