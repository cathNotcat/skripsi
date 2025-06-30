import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_1/view_models/csv_upload_view_model.dart';

class UploadCsvScreen extends StatelessWidget {
  final CsvUploadViewModel viewModel = CsvUploadViewModel();

  UploadCsvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dashboard',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Center(
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                dashPattern: [8, 4],
                color: Colors.grey,
                strokeWidth: 2,
                child: InkWell(
                  onTap: () {
                    viewModel.uploadCsvFile();
                  },
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file, size: 40, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'Click untuk upload file CSV',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Silakan upload file terbaru dari database',
            ),
          ],
        ),
      ),
    );
  }
}
