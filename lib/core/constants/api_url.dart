class ApiUrl {
  // ! BASE URL
  static const String baseUrl = 'http://124.123.122.112:7081/Report';

  // ! LOGIN API
  static const String loginApi = '/Login';

  // ! Common API
  static const String saveBaseURL = '/SaveBaseURL';
  static const String getNotificationLogs = '/GetNotificationLogs';

  // ! FINANCE MODULE API
  static const String getAuthorisationList = '/GetAuthorisationList';
  static const String authoriseFinanceVoucher = '/AuthoriseFinanceVoucher';
  static const String getAuthorisationListFilter = '/GetAuthorisationListFilter';
  static const String getAllAuthorisationList = '/GetAllAuthorisationList';

  // ! Get PDF Report
  static const String getBankpaymentReport = '/getBankpaymentReport';
  static const String notificationsList = '/GetNotificationLogs';
}
