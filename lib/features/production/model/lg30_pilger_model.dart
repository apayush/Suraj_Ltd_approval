import 'package:flutter/material.dart';

/// Represents a single machine row in the LG30 entry form.
/// Each machine has its own set of TextEditingControllers for user input.
class LG30MachineEntry {
  final String machineName;
  final TextEditingController nosController;
  final TextEditingController kgsController;
  final TextEditingController maintController;
  final TextEditingController rmController;
  final TextEditingController manController;
  final TextEditingController otherController;

  LG30MachineEntry({
    required this.machineName,
    TextEditingController? nosController,
    TextEditingController? kgsController,
    TextEditingController? maintController,
    TextEditingController? rmController,
    TextEditingController? manController,
    TextEditingController? otherController,
  })  : nosController = nosController ?? TextEditingController(),
        kgsController = kgsController ?? TextEditingController(),
        maintController = maintController ?? TextEditingController(),
        rmController = rmController ?? TextEditingController(),
        manController = manController ?? TextEditingController(),
        otherController = otherController ?? TextEditingController();

  /// Build the JSON payload for submission
  Map<String, dynamic> toJson({
    required String date,
    required String dept,
    required String createdBy,
  }) {
    return {
      'Date': date,
      'Dept': dept,
      'Machine': machineName,
      'Nos': int.tryParse(nosController.text) ?? 0,
      'Kgs': double.tryParse(kgsController.text) ?? 0.0,
      'Maint': maintController.text,
      'Rm': rmController.text,
      'Man': manController.text,
      'Other': otherController.text,
      'CreatedBy': createdBy,
    };
  }

  void dispose() {
    nosController.dispose();
    kgsController.dispose();
    maintController.dispose();
    rmController.dispose();
    manController.dispose();
    otherController.dispose();
  }
}

/// Represents a single machine row returned from the report API.
class LG30ReportEntry {
  final int id;
  final String machineName;
  final int nos;
  final double kgs;
  final String maint;
  final String rm;
  final String man;
  final String other;

  LG30ReportEntry({
    required this.id,
    required this.machineName,
    required this.nos,
    required this.kgs,
    this.maint = '',
    this.rm = '',
    this.man = '',
    this.other = '',
  });

  factory LG30ReportEntry.fromJson(Map<String, dynamic> json, int index) {
    return LG30ReportEntry(
      id: index,
      machineName: json['Machine'] ?? json['MachineName'] ?? '',
      nos: json['Nos'] ?? 0,
      kgs: (json['Kgs'] ?? 0).toDouble(),
      maint: json['Maint'] ?? json['Maintenance'] ?? '',
      rm: json['Rm'] ?? json['RmIssue'] ?? '',
      man: json['Man'] ?? json['Manpower'] ?? '',
      other: json['Other'] ?? '',
    );
  }
}
