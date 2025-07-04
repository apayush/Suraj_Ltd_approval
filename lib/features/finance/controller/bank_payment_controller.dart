import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/api_url.dart';
import '../../../core/service/api_service.dart';

class BankPaymentController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static BankPaymentController get instance => Get.find();

  final _apiService = ApiService();
  RxBool isLoading = false.obs;

  Future<void> getBankPaymentData() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getData(ApiUrl.baseUrl);
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
    getBankPaymentData();
  }
}
