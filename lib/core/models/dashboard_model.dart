class DashboardModel {
  final String period;
  final int approveCount;
  final int rejectCount;

  DashboardModel({
    required this.period,
    required this.approveCount,
    required this.rejectCount,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      period: json['Period'] ?? '',
      approveCount: json['ApproveCount'] ?? 0,
      rejectCount: json['RejectCount'] ?? 0,
    );
  }
  factory DashboardModel.empty() {
    return DashboardModel(
      period: '',
      approveCount: 0,
      rejectCount: 0,
    );
  }

  int get totalCount => approveCount + rejectCount;

  double get approvalRate => totalCount > 0 ? (approveCount / totalCount) * 100 : 0;

  String get displayPeriod {
    switch (period) {
      case 'Today':
        return 'Today';
      case 'ThisWeek':
        return 'This Week';
      case 'ThisMonth':
        return 'This Month';
      default:
        return period;
    }
  }
}
