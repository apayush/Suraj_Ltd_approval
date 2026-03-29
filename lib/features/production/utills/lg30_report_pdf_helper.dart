import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../model/lg30_pilger_model.dart';

class LG30ReportPdfHelper {
  static Future<String> generateLG30ReportPdf({
    required String department,
    required DateTime reportDate,
    required List<LG30ReportEntry> entries,
    required int totalNos,
    required double totalKgs,
  }) async {
    final pdf = pw.Document();

    // Load logo if available
    pw.MemoryImage? logo;
    try {
      final logoData = await rootBundle.load('assets/logo/surajLogo.png');
      logo = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (e) {
      print('Logo not found for PDF: $e');
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(logo, department, reportDate),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          pw.SizedBox(height: 20),
          _buildDataTable(entries, totalNos, totalKgs),
          pw.SizedBox(height: 40),
          _buildSignatureSection(),
        ],
      ),
    );

    final bytes = await pdf.save();
    return base64Encode(bytes);
  }

  static pw.Widget _buildHeader(
      pw.MemoryImage? logo, String department, DateTime reportDate) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            if (logo != null)
              pw.Image(logo, width: 100)
            else
              pw.Text('SURAJ LTD.',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 20)),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('LG30 / PILGER PRODUCTION REPORT',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 14)),
                pw.Text(department.toUpperCase(),
                    style: pw.TextStyle(
                        fontSize: 12, color: PdfColors.grey700)),
                pw.Text(
                    'Date: ${DateFormat('dd MMM yyyy').format(reportDate)}',
                    style: pw.TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        pw.Divider(thickness: 2, color: PdfColors.blue900),
      ],
    );
  }

  static pw.Widget _buildDataTable(
      List<LG30ReportEntry> entries, int totalNos, double totalKgs) {
    final headers = [
      'MACHINE NAME',
      'NOS',
      'KGS',
      'MAINTENANCE',
      'NO RM',
      'MANPOWER',
      'OTHER',
    ];

    final data = entries.map((e) {
      return [
        e.machineName,
        e.nos == 0 ? '-' : e.nos.toString(),
        e.kgs == 0 ? '-' : e.kgs.toStringAsFixed(1),
        e.maint,
        e.rm,
        e.man,
        e.other,
      ];
    }).toList();

    // Add total row
    data.add([
      'TOTAL',
      totalNos.toString(),
      totalKgs.toStringAsFixed(1),
      '',
      '',
      '',
      '',
    ]);

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      headerStyle: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
          fontSize: 10),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      cellHeight: 25,
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6),
      cellStyle: const pw.TextStyle(fontSize: 9),
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerLeft,
        5: pw.Alignment.centerLeft,
        6: pw.Alignment.centerLeft,
      },
    );
  }

  static pw.Widget _buildSignatureSection() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        _signatureBox('Operator Signature'),
        _signatureBox('Supervisor Signature'),
        _signatureBox('Manager Signature'),
      ],
    );
  }

  static pw.Widget _signatureBox(String label) {
    return pw.Column(
      children: [
        pw.Container(
          width: 120,
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(width: 1)),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        'Page ${context.pageNumber} of ${context.pagesCount}',
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
      ),
    );
  }
}
