/// Model for a single row in the FFD Forming Production report.
/// The API may return flat per-day data; cumulative totals are computed client-side.
class FFDReportEntry {
  final int id;
  final String date;
  final int elbowQty;
  final int elbowTotal; // cumulative running total
  final int teeQty;
  final int teeTotal;
  final int reducerQty;
  final int reducerTotal;
  final int capQty;
  final int capTotal;

  FFDReportEntry({
    required this.id,
    required this.date,
    required this.elbowQty,
    required this.elbowTotal,
    required this.teeQty,
    required this.teeTotal,
    required this.reducerQty,
    required this.reducerTotal,
    required this.capQty,
    required this.capTotal,
  });

  /// Build report entries from raw API list, computing cumulative totals
  /// in chronological order (same logic as the HTML demo).
  static List<FFDReportEntry> fromJsonList(List<dynamic> data) {
    // Sort chronologically so running totals are correct
    final sorted = List<Map<String, dynamic>>.from(
      data.map((e) => e as Map<String, dynamic>),
    )..sort((a, b) => (a['EntryDate'] ?? '').compareTo(b['EntryDate'] ?? ''));

    int runElbow = 0, runTee = 0, runReducer = 0, runCap = 0;
    final result = <FFDReportEntry>[];

    for (int i = 0; i < sorted.length; i++) {
      final json = sorted[i];
      final elbow = _parseInt(json['ElbowQty']);
      final tee = _parseInt(json['TeeQty']);
      final reducer = _parseInt(json['ReducerQty']);
      final cap = _parseInt(json['CapQty']);

      runElbow += elbow;
      runTee += tee;
      runReducer += reducer;
      runCap += cap;

      result.add(FFDReportEntry(
        id: i,
        date: json['EntryDate']?.toString() ?? '',
        elbowQty: elbow,
        elbowTotal: runElbow,
        teeQty: tee,
        teeTotal: runTee,
        reducerQty: reducer,
        reducerTotal: runReducer,
        capQty: cap,
        capTotal: runCap,
      ));
    }

    return result;
  }

  static int _parseInt(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;
}
