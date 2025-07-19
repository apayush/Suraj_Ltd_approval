import 'dart:io';

import 'package:flutter/material.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AppPdfViewer extends StatelessWidget {
  const AppPdfViewer({super.key, this.pdfFile, this.url});
  final File? pdfFile;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        backgroundColor: AppColors.blue,
      ),
      body:
          pdfFile != null
              ? SfPdfViewer.file(pdfFile!)
              : SfPdfViewer.network(url!),
    );
  }
}
