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

 /// فحص ملف باستخدام Flask API المعدل
  static Future<Map<String, dynamic>> scanFile(String filePath) async {
  try {
    final result = await _channel.invokeMethod('scanFile', {'filePath': filePath});
    final Map<String, dynamic> initial = jsonDecode(result);
    final analysisId = initial['data']?['id'];

    if (analysisId == null) throw Exception("No analysis ID received");

    const int maxRetries = 10;
    const Duration delay = Duration(seconds: 3);

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      await Future.delayed(delay);

      final finalResultRaw = await _channel.invokeMethod('getAnalysis', {'id': analysisId});
      final finalResult = jsonDecode(finalResultRaw);

      final status = finalResult['data']?['attributes']?['status'];
      if (status != null && status != 'queued') {
        return finalResult;
      }

      if (attempt == maxRetries - 1) {
        throw Exception("التحليل لم يكتمل بعد المحاولات القصوى");
      }
    }

    throw Exception("Analysis didn't complete in time");
  } catch (e) {
    throw Exception("خطأ في فحص الملف: $e");
  }
}


}