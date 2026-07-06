class DaywiseEntry {
  final int id;
  final String dept;
  final DateTime date;
  final int target;
  final int actualNos;
  final double actualKgs;
  final double actualMtr;
  final int cumulativeTarget;
  final int cumulativeNos;
  final double cumulativeKgs;
  final double cumulativeMtr;
  final String shift;

  DaywiseEntry({
    required this.id,
    required this.dept,
    required this.date,
    required this.target,
    required this.actualNos,
    required this.actualKgs,
    required this.shift,
    this.actualMtr = 0.0,
    this.cumulativeTarget = 0,
    this.cumulativeNos = 0,
    this.cumulativeKgs = 0.0,
    this.cumulativeMtr = 0.0,
  });

  factory DaywiseEntry.fromJson(Map<String, dynamic> json, String defaultDept, int index) {
    return DaywiseEntry(
      id: index,
      dept: json['Department'] ?? defaultDept,
      date: DateTime.tryParse(json['EntryDate'] ?? '') ?? DateTime.now(),
      target: json['Target'] ?? 0,
      actualNos: json['Nos'] ?? 0,
      actualKgs: (json['Kgs'] ?? 0).toDouble(),
      actualMtr: (json['Mtr'] ?? 0).toDouble(),
      cumulativeTarget: json['CumTarget'] ?? 0,
      cumulativeNos: json['CumNos'] ?? 0,
      cumulativeKgs: (json['CumKgs'] ?? 0).toDouble(),
      cumulativeMtr: (json['CumMtr'] ?? 0).toDouble(),
      shift: (json['Shift'] ?? ''),
    );
  }

  DaywiseEntry copyWith({
    int? id,
    String? dept,
    DateTime? date,
    int? target,
    int? actualNos,
    double? actualKgs,
    double? actualMtr,
    int? cumulativeTarget,
    int? cumulativeNos,
    double? cumulativeKgs,
    double? cumulativeMtr,
    String? shift,
  }) {
    return DaywiseEntry(
      id: id ?? this.id,
      dept: dept ?? this.dept,
      date: date ?? this.date,
      target: target ?? this.target,
      actualNos: actualNos ?? this.actualNos,
      actualKgs: actualKgs ?? this.actualKgs,
      actualMtr: actualMtr ?? this.actualMtr,
      cumulativeTarget: cumulativeTarget ?? this.cumulativeTarget,
      cumulativeNos: cumulativeNos ?? this.cumulativeNos,
      cumulativeKgs: cumulativeKgs ?? this.cumulativeKgs,
      cumulativeMtr: cumulativeMtr ?? this.cumulativeMtr,
      shift: shift ?? this.shift,
    );
  }
}
