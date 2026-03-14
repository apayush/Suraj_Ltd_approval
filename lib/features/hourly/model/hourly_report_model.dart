enum ReportType { expansion, pilger, dispatch }

extension ReportTypeExtension on ReportType {
  String get label {
    switch (this) {
      case ReportType.expansion:
        return 'SPD Expansion';
      case ReportType.pilger:
        return 'SPD Pilger';
      case ReportType.dispatch:
        return 'Dispatch';
    }
  }

  String get reportTitle {
    switch (this) {
      case ReportType.expansion:
        return 'SPD EXPANSION REPORT';
      case ReportType.pilger:
        return 'SPD PILGER REPORT';
      case ReportType.dispatch:
        return 'MPD TO SPD DISPATCH';
    }
  }
}

class HourlyEntry {
  final int id;
  final ReportType type;
  final DateTime date;
  final String timeSlot;
  final int target;
  final int actual;
  final String dia;
  final String grade;
  final String size;

  HourlyEntry({
    required this.id,
    required this.type,
    required this.date,
    required this.timeSlot,
    required this.target,
    required this.actual,
    this.dia = '',
    this.grade = '',
    this.size = '',
  });

  HourlyEntry copyWith({
    int? id,
    ReportType? type,
    DateTime? date,
    String? timeSlot,
    int? target,
    int? actual,
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
      dia: dia ?? this.dia,
      grade: grade ?? this.grade,
      size: size ?? this.size,
    );
  }
}

const List<String> kShiftHours = [
  '09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
  '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM',
  '05:00 PM', '06:00 PM', '07:00 PM', '08:00 PM',
  '09:00 PM', '10:00 PM', '11:00 PM', '12:00 AM',
  '01:00 AM', '02:00 AM', '03:00 AM', '04:00 AM',
  '05:00 AM', '06:00 AM', '07:00 AM', '08:00 AM',
];
