class HourlyEntry {
  final int id;
  final String type;
  final DateTime date;
  final String timeSlot;
  final int? target;
  final int? actual;
  final int? cumulativeTarget;
  final int? cumulativeActual;
  final String dia;
  final String grade;
  final String size;

  HourlyEntry({
    required this.id,
    required this.type,
    required this.date,
    required this.timeSlot,
    this.target,
    this.actual,
    this.cumulativeTarget,
    this.cumulativeActual,
    this.dia = '',
    this.grade = '',
    this.size = '',
  });

  factory HourlyEntry.fromJson(Map<String, dynamic> json, String type, DateTime date, int index) {
    return HourlyEntry(
      id: index,
      type: type,
      date: date,
      timeSlot: json['TimeSlot'] ?? '',
      target: json['TargetPerHour'],
      actual: json['ActualPerHour'],
      cumulativeTarget: json['CumulativeTarget'],
      cumulativeActual: json['CumulativeActual'],
      dia: json['DIANumber']?.toString() ?? '',
      grade: json['Grade']?.toString() ?? '',
      size: json['SizeWise']?.toString() ?? '',
    );
  }

  HourlyEntry copyWith({
    int? id,
    String? type,
    DateTime? date,
    String? timeSlot,
    int? target,
    int? actual,
    int? cumulativeTarget,
    int? cumulativeActual,
    String? dia,
    String? grade,
    String? size,
  }) {
    return HourlyEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      target: target ?? this.target,
      actual: actual ?? this.actual,
      cumulativeTarget: cumulativeTarget ?? this.cumulativeTarget,
      cumulativeActual: cumulativeActual ?? this.cumulativeActual,
      dia: dia ?? this.dia,
      grade: grade ?? this.grade,
      size: size ?? this.size,
    );
  }
}

const List<String> kShiftHours = [
  '09:00', '10:00', '11:00', '12:00',
  '13:00', '14:00', '15:00', '16:00',
  '17:00', '18:00', '19:00', '20:00',
  '21:00', '22:00', '23:00', '00:00',
  '01:00', '02:00', '03:00', '04:00',
  '05:00', '06:00', '07:00', '08:00',
];
