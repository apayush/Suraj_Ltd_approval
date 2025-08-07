class ApiUrl {
  // ! BASE URL
  static String baseUrlGlobal = 'http://124.123.122.112:7081/Report';

  // ! LOGIN API
  static const String loginApi = '/Login';
  static const String updateFCMId = '/LogOut';
  static const String updatePwd = '/UpdatePwd';

  // ! Common API
  static const String saveBaseURL = '/SaveBaseURL';
  // SaveBaseUrl?mUrlString=http://124.123.122.112:7081/Report&mUser=Admin
  static const String getBaseUrl = 'http://124.123.122.112:7081/Report/GetBaseUrl';
  static const String getNotificationLogs = '/GetNotificationLogs';
  static const String updateNotificationLogs = '/UpdateNotificationLogs';

  // ! FINANCE MODULE API
  static const String getVoucherApprovalDashboard = '/GetVoucherApprovalDashboard';
  static const String getAuthorisationList = '/GetAuthorisationList';
  static const String authoriseVoucher = '/AuthoriseFinanceVoucher';
  static const String getAuthorisationListFilter =
      '/GetAuthorisationListFilter';
  static const String getAllAuthorisationList = '/GetAllAuthorisationList';
  static const String getHoldVoucher = '/GetHoldFinance';
  // http://124.123.122.112:7081/Report/GetHoldFinance?mUser=Mihir&mUserLevel=3&MainType=Bank Payment

  // ! Get PDF Report
  static const String getVoucherReport = '/getBankpaymentReport';
}
