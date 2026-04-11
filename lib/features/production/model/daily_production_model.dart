class DailyProductionEntry {
  final String date;
  final int cutting;
  final int forming;
  final int bevelling;

  DailyProductionEntry({
    required this.date,
    required this.cutting,
    required this.forming,
    required this.bevelling,
  });

  int get dailyTotal => cutting + forming + bevelling;

  factory DailyProductionEntry.fromJson(Map<String, dynamic> json) {
    return DailyProductionEntry(
      date: json['EntryDate']?.toString() ?? json['date']?.toString() ?? '',
      cutting: int.tryParse(json['CuttingQty']?.toString() ?? json['cutting']?.toString() ?? '0') ?? 0,
      forming: int.tryParse(json['FormingQty']?.toString() ?? json['forming']?.toString() ?? '0') ?? 0,
      bevelling: int.tryParse(json['BevellingQty']?.toString() ?? json['bevelling']?.toString() ?? '0') ?? 0,
    );
  }
}
