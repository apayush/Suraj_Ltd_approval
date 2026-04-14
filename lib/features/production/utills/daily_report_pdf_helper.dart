import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../model/daily_production_model.dart';

class DailyReportPdfHelper {
  static Future<String> generateDailyReportPdf({
    required DateTime? startDate,
    required DateTime? endDate,
    required List<DailyProductionEntry> entries,
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
        pageFormat: PdfPageFormat.a4.portrait,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(logo, startDate, endDate),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          pw.SizedBox(height: 20),
          _buildDataTable(entries),
          pw.SizedBox(height: 40),
          _buildSignatureSection(),
        ],
      ),
    );

    final bytes = await pdf.save();
    return base64Encode(bytes);
  }

  static pw.Widget _buildHeader(
      pw.MemoryImage? logo, DateTime? startDate, DateTime? endDate) {
    
    String dateRange = 'All Dates';
    if (startDate != null && endDate != null) {
      dateRange = '${DateFormat('dd MMM yyyy').format(startDate)} to ${DateFormat('dd MMM yyyy').format(endDate)}';
    } else if (startDate != null || endDate != null) {
      dateRange = DateFormat('dd MMM yyyy').format(startDate ?? endDate!);
    }

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
                pw.Text('DAILY PRODUCTION REPORT',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 14)),
                pw.Text(
                    'Dates: $dateRange',
                    style: pw.TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        pw.Divider(thickness: 2, color: PdfColors.blue900),
      ],
    );
  }

  static pw.Widget _buildDataTable(List<DailyProductionEntry> entries) {
    final headers = [
      'DATE',
      'CUTTING QTY NOS.',
      'FORMING QTY NOS.',
      'BEVELLING QTY NOS.',
      'TOTAL QTY NOS.',
    ];

    int totalCutting = 0;
    int totalForming = 0;
    int totalBevelling = 0;
    int grandTotal = 0;

    final data = entries.map((e) {
      totalCutting += e.cutting;
      totalForming += e.forming;
      totalBevelling += e.bevelling;
      grandTotal += e.dailyTotal;

      return [
        e.date,
        e.cutting.toString(),
        e.forming.toString(),
        e.bevelling.toString(),
        e.dailyTotal.toString(),
      ];
    }).toList();

    // Add total row
    data.add([
      'TOTAL',
      totalCutting.toString(),
      totalForming.toString(),
      totalBevelling.toString(),
      grandTotal.toString(),
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
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
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
