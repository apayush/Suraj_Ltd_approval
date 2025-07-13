import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AppPdfViewer extends StatelessWidget {
  const AppPdfViewer({super.key, this.pdfFile, this.url});
  final File? pdfFile;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body:
          pdfFile != null
              ? SfPdfViewer.file(pdfFile!)
              : SfPdfViewer.network(url!),
    );
  }
}
