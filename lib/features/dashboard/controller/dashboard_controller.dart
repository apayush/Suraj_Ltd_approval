import 'package:get/get.dart';

import '../../../core/constants/api_url.dart';
import '../../../core/models/dashboard_model.dart';
import '../../../core/service/api_service.dart';
import '../../../core/service/local_db.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static DashboardController get instance => Get.find();

  RxBool isLoading = false.obs;
  final RxList<DashboardModel> dashboardData = <DashboardModel>[].obs;
  final RxString error = ''.obs;

  // ! =================== GET DASHBOARD DATA

  Future<void> getVoucherApprovalDashboard() async {
    final userModel = LocalDB.getUserModel();
    isLoading.value = true;
    try {
      final response = await ApiService.getData(
        ApiUrl.getVoucherApprovalDashboard,
        queryParams: {
          'mUser': userModel?.mUser,
        },
      );
      if (response.statusCode == 200) {
        final jsonData = response.data;
        dashboardData.value = (jsonData as List)
            .cast<Map<String, dynamic>>()
            .map((json) => DashboardModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Error Fetching Dashboard Data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await getVoucherApprovalDashboard();
  }

  @override
  void onInit() {
    super.onInit();
    getVoucherApprovalDashboard();
  }

}
