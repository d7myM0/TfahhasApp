import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class ApiService {
  static Future<String> scanUrl(String url) async {
    final response = await http.post(
      Uri.parse('https://tfahhasapp.onrender.com/scan-url'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': url}),
    );
    final data = jsonDecode(response.body);
    return data['data']?['attributes']?['stats']?.toString() ?? 'No result';
  }

  static Future<String> scanFile() async {
    FilePickerResult? picked = await FilePicker.platform.pickFiles();
    if (picked != null) {
      File file = File(picked.files.single.path!);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://tfahhasapp.onrender.com/scan-file'),
      );
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      return data['data']?['attributes']?['stats']?.toString() ?? 'No result';
    }
    return 'No file selected';
  }
}
