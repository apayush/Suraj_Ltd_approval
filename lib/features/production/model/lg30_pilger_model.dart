import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Represents a single machine row in the LG30 entry form.
/// Each machine has its own set of TextEditingControllers for user input.
class LG30MachineEntry {
  final String machineName;
  final TextEditingController nosController;
  final TextEditingController kgsController;
  final TextEditingController mtrController;
  final RxString selectedShift;
  final TextEditingController maintController;
  final TextEditingController rmController;
  final TextEditingController manController;
  final TextEditingController otherController;

  LG30MachineEntry({
    required this.machineName,
    TextEditingController? nosController,
    TextEditingController? kgsController,
    TextEditingController? mtrController,
    RxString? selectedShift,
    TextEditingController? maintController,
    TextEditingController? rmController,
    TextEditingController? manController,
    TextEditingController? otherController,
  })  : nosController = nosController ?? TextEditingController(),
        kgsController = kgsController ?? TextEditingController(),
        mtrController = mtrController ?? TextEditingController(),
        selectedShift = selectedShift ?? '1st Shift'.obs,
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
      'Mtr': double.tryParse(mtrController.text) ?? 0.0,
      'Maint': maintController.text,
      'Rm': rmController.text,
      'Man': manController.text,
      'Other': otherController.text,
      'CreatedBy': createdBy,
      'Shift': selectedShift.value,
    };
  }

  void dispose() {
    nosController.dispose();
    kgsController.dispose();
    mtrController.dispose();
    maintController.dispose();
    rmController.dispose();
    manController.dispose();
    otherController.dispose();
  }
}

/// Represents a single machine row returned from the report API.
class LG30ReportEntry {
  final int id;
  final String date;
  final String dept;
  final String machineName;
  final String shift;
  final int nos;
  final double kgs;
  final double mtr;
  final String maint;
  final String rm;
  final String man;
  final String other;
  final String createdBy;

  LG30ReportEntry({
    required this.id,
    required this.date,
    required this.dept,
    required this.machineName,
    required this.shift,
    required this.nos,
    required this.kgs,
    required this.mtr,
    this.maint = '',
    this.rm = '',
    this.man = '',
    this.other = '',
    this.createdBy = '',
  });

  factory LG30ReportEntry.fromJson(Map<String, dynamic> json, int index) {
    return LG30ReportEntry(
      id: index,
      date: json['Date']?.toString() ?? '',
      dept: json['Dept']?.toString() ?? '',
      machineName: (json['Machine'] ?? json['MachineName'] ?? '').toString(),
      shift: json['Shift']?.toString() ?? '',
      nos: _parseInt(json['Nos']),
      kgs: _parseDouble(json['Kgs']),
      mtr: _parseDouble(json['Mtr']),
      maint: (json['Maint'] ?? json['Maintenance'] ?? '').toString(),
      rm: (json['Rm'] ?? json['RmIssue'] ?? '').toString(),
      man: (json['Man'] ?? json['Manpower'] ?? '').toString(),
      other: (json['Other'] ?? '').toString(),
      createdBy: json['CreatedBy']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _parseDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
