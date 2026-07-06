import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../model/ffd_model.dart';

class FfdReportPdfHelper {
  static Future<String> generateFfdReportPdf({
    required DateTime? startDate,
    required DateTime? endDate,
    required List<FFDReportEntry> entries,
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
                pw.Text('FFD FORMING REPORT',
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

  static pw.Widget _buildDataTable(List<FFDReportEntry> entries) {
    final headers = [
      'DATE',
      'DEPARTMENT',
      'ELBOW QTY',
      'ELBOW TOT.',
      'TEE QTY',
      'TEE TOT.',
      'RED. QTY',
      'RED. TOT.',
      'CAP QTY',
      'CAP TOT.',
    ];

    int totalElbow = 0;
    int totalTee = 0;
    int totalReducer = 0;
    int totalCap = 0;

    final data = entries.map((e) {
      totalElbow += e.elbowQty;
      totalTee += e.teeQty;
      totalReducer += e.reducerQty;
      totalCap += e.capQty;

      return [
        e.date,
        e.department,
        e.elbowQty.toString(),
        e.elbowTotal.toString(),
        e.teeQty.toString(),
        e.teeTotal.toString(),
        e.reducerQty.toString(),
        e.reducerTotal.toString(),
        e.capQty.toString(),
        e.capTotal.toString(),
      ];
    }).toList();

    // Add total row
    data.add([
      'TOTAL',
      '',
      totalElbow.toString(),
      '',
      totalTee.toString(),
      '',
      totalReducer.toString(),
      '',
      totalCap.toString(),
      '',
    ]);

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      headerStyle: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
          fontSize: 8),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      cellHeight: 25,
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4),
      cellStyle: const pw.TextStyle(fontSize: 8),
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
        6: pw.Alignment.centerRight,
        7: pw.Alignment.centerRight,
        8: pw.Alignment.centerRight,
        9: pw.Alignment.centerRight,
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
