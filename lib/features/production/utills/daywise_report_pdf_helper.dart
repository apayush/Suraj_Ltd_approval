import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../model/daywise_report_model.dart';

class DaywiseReportPdfHelper {
  static Future<String> generateDaywiseReportPdf({
    required String reportType,
    required DateTime startDate,
    required DateTime endDate,
    required List<DaywiseEntry> entries,
    required bool isFullType,
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
        header: (context) => _buildHeader(logo, reportType, startDate, endDate),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          pw.SizedBox(height: 20),
          _buildDataTable(entries, isFullType),
          pw.SizedBox(height: 40),
          _buildSignatureSection(),
        ],
      ),
    );

    final bytes = await pdf.save();
    return base64Encode(bytes);
  }

  static pw.Widget _buildHeader(pw.MemoryImage? logo, String reportType, DateTime startDate, DateTime endDate) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            if (logo != null)
              pw.Image(logo, width: 100)
            else
              pw.Text('SURAJ LTD.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('DAYWISE PRODUCTION REPORT',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                pw.Text(reportType.toUpperCase(),
                    style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                pw.Text('Period: ${DateFormat('dd MMM').format(startDate)} to ${DateFormat('dd MMM yyyy').format(endDate)}',
                    style: pw.TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        pw.Divider(thickness: 2, color: PdfColors.blue900),
      ],
    );
  }

  static pw.Widget _buildDataTable(List<DaywiseEntry> entries, bool isFullType) {
    final headers = [
      'Date',
      'Shift',
      'Target (Day)',
      'Target (Total)',
      if (isFullType) ...['Weight Kgs (Day)', 'Weight Kgs (Total)'],
      'Prod Nos (Day)',
      'Prod Nos (Total)',
      'Mtr (Day)',
      'Mtr (Total)',
    ];

    final data = entries.map((e) {
      return [
        DateFormat('dd/MM/yyyy').format(e.date),
        e.shift,
        e.target.toString(),
        e.cumulativeTarget.toString(),
        if (isFullType) ...[
          e.actualKgs.toString(),
          e.cumulativeKgs.toString(),
        ],
        e.actualNos.toString(),
        e.cumulativeNos.toString(),
        e.actualMtr.toString(),
        e.cumulativeMtr.toString(),
      ];
    }).toList();

    final cellAlignments = <int, pw.Alignment>{
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.centerLeft,
      for (var i = 2; i < headers.length; i++) i: pw.Alignment.centerRight,
    };

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      cellHeight: 25,
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellAlignments: cellAlignments,
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
