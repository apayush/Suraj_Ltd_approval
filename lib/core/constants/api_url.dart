class ApiUrl {
  // ! BASE URL
  static String baseUrl = 'http://124.123.122.112:7081/Report';

  // ! LOGIN API
  static const String loginApi = '/Login';
  static const String updateFCMId = '/UpdateNotificationLogs';

  // ! Common API
  static const String saveBaseURL = '/SaveBaseURL';
  // SaveBaseUrl?mUrlString=http://124.123.122.112:7081/Report&mUser=Admin
  static const String getBaseUrl = '/GetBaseUrl';
  static const String getNotificationLogs = '/GetNotificationLogs';
  static const String updateNotificationLogs = '/UpdateNotificationLogs';

  // ! FINANCE MODULE API
  static const String getAuthorisationList = '/GetAuthorisationList';
  static const String authoriseFinanceVoucher = '/AuthoriseFinanceVoucher';
  static const String getAuthorisationListFilter =
      '/GetAuthorisationListFilter';
  static const String getAllAuthorisationList = '/GetAllAuthorisationList';

  // ! Get PDF Report
  static const String getBankpaymentReport = '/getBankpaymentReport';
  static const String notificationsList = '/GetNotificationLogs';
}
