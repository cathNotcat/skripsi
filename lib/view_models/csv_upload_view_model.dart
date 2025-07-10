import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class CsvUploadViewModel extends ChangeNotifier {
  final baseUrl = dotenv.env['BASE_URL'] ?? '';
  Future<void> uploadCsvFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );

    if (result != null) {
      try {
        final fileBytes = result.files.first.bytes!;
        final fileName = result.files.first.name;

        var uri = Uri.parse('$baseUrl/upload-csv');
        var request = http.MultipartRequest('POST', uri);

        request.files.add(
          http.MultipartFile.fromBytes('file', fileBytes, filename: fileName),
        );

        var streamedResponse = await request.send();
        final status = streamedResponse.statusCode;
        final body = await streamedResponse.stream.bytesToString();

        if (status == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('CSV uploaded successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: $status\n$body')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    }
  }

  // Future<void> uploadCsvFile(BuildContext context) async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['csv'],
  //     );

  //     if (result != null) {
  //       File file = File(result.files.single.path!);
  //       var uri = Uri.parse('$baseUrl/upload-csv');
  //       var request = http.MultipartRequest('POST', uri);
  //       request.files.add(await http.MultipartFile.fromPath('file', file.path));
  //       var response = await request.send();

  //       if (response.statusCode == 200) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('CSV uploaded successfully!'),
  //             backgroundColor: Colors.green,
  //           ),
  //         );
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //               content: Text(
  //                   'Upload failed. Server error: ${response.statusCode}')),
  //         );
  //       }
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Upload failed: $e')),
  //     );
  //   }
  // }

  // Future<void> uploadCsvFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['csv'],
  //   );

  //   if (result != null) {
  //     File file = File(result.files.single.path!);
  //     var uri = Uri.parse('$baseUrl/upload-csv');
  //     var request = http.MultipartRequest('POST', uri);
  //     request.files.add(await http.MultipartFile.fromPath('file', file.path));
  //     var response = await request.send();

  //     if (response.statusCode == 200) {
  //       print('CSV uploaded successfully!');
  //     } else {
  //       print('Upload failed: ${response.statusCode}');
  //     }
  //     notifyListeners();
  //   }
  // }
}
