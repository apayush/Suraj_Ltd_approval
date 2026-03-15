import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../model/hourly_report_model.dart';

class HourlyReportPdfHelper {
  static Future<String> generateHourlyReportPdf({
    required String reportType,
    required DateTime reportDate,
    required List<HourlyEntry?> entries,
    required int totalTarget,
    required int totalActual,
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

    final isExpansion = reportType.toLowerCase().contains('expansion');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(logo, reportType, reportDate),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          pw.SizedBox(height: 20),
          _buildDataTable(entries, isExpansion, totalTarget, totalActual),
          pw.SizedBox(height: 40),
          _buildSignatureSection(),
        ],
      ),
    );

    final bytes = await pdf.save();
    return base64Encode(bytes);
  }

  static pw.Widget _buildHeader(pw.MemoryImage? logo, String reportType, DateTime date) {
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
                pw.Text('HOURLY PRODUCTION REPORT',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                pw.Text(reportType.toUpperCase(),
                    style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                pw.Text('Date: ${DateFormat('dd MMM yyyy').format(date)}',
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
    List<HourlyEntry?> entries,
    bool isExpansion,
    int totalTarget,
    int totalActual,
  ) {
    final headers = isExpansion
        ? ['DIA No.', 'Grade', 'Time', 'Target', 'Cum.T', 'Actual', 'Cum.A', 'Size']
        : ['Time Slot', 'Target/Hr', 'Cum. Target', 'Actual/Hr', 'Cum. Actual'];

    final data = entries.map((e) {
      if (isExpansion) {
        return [
          e?.dia ?? '-',
          e?.grade ?? '-',
          e?.timeSlot ?? '-',
          e?.target?.toString() ?? '-',
          e?.cumulativeTarget?.toString() ?? '-',
          e?.actual?.toString() ?? '-',
          e?.cumulativeActual?.toString() ?? '-',
          e?.size ?? '-',
        ];
      } else {
        return [
          e?.timeSlot ?? '-',
          e?.target?.toString() ?? '-',
          e?.cumulativeTarget?.toString() ?? '-',
          e?.actual?.toString() ?? '-',
          e?.cumulativeActual?.toString() ?? '-',
        ];
      }
    }).toList();

    // Add footer row to data
    if (isExpansion) {
      data.add([
        '', '', 'TOTAL',
        totalTarget.toString(), '',
        totalActual.toString(), '', '',
      ]);
    } else {
      data.add([
        'TOTAL',
        totalTarget.toString(), '',
        totalActual.toString(), '',
      ]);
    }

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      cellHeight: 25,
      cellAlignments: {
        if (isExpansion) ...{
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
          5: pw.Alignment.centerRight,
          6: pw.Alignment.centerRight,
        } else ...{
          1: pw.Alignment.centerRight,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
        }
      },
      textStyleBuilder: (index, value, rowNum) {
        if (rowNum == data.length) {
          return pw.TextStyle(fontWeight: pw.FontWeight.bold);
        }
        return null;
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
