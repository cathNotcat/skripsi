import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class CsvUploadViewModel extends ChangeNotifier {
  final baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<void> uploadCsvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      var uri = Uri.parse('$baseUrl/upload-csv');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        print('CSV uploaded successfully!');
      } else {
        print('Upload failed: ${response.statusCode}');
      }
      notifyListeners();
    }
  }
}
