import 'package:flutter/services.dart';
import 'dart:convert';

class VirusTotalService {
  static const MethodChannel _channel = MethodChannel('virustotal.channel');

  /// فحص رابط باستخدام Kotlin و VirusTotal API
  static Future<Map<String, dynamic>> scanUrl(String url) async {
    try {
      final result = await _channel.invokeMethod('scanUrl', {'url': url});
      return jsonDecode(result);
    } catch (e) {
      throw Exception("خطأ في فحص الرابط: $e");
    }
  }

  /// فحص ملف باستخدام Kotlin و VirusTotal API
  static Future<Map<String, dynamic>> scanFile(String filePath) async {
    try {
      final result = await _channel.invokeMethod('scanFile', {'filePath': filePath});
      final decoded = jsonDecode(result);

      // نتأكد أن data موجودة
      if (decoded['data'] == null) {
        throw Exception("الرد من API لا يحتوي على 'data'");
      }

      // ✅ نعيد الرد بالكامل حتى لو ما فيه attributes
      return decoded;
    } catch (e) {
      throw Exception("خطأ في فحص الملف: $e");
    }
  }
}
