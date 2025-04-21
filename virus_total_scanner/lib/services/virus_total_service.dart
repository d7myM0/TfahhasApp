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

    // ننتظر ثواني قليلة قبل الطلب الثاني (اختياري)
    await Future.delayed(Duration(seconds: 3));

    // الآن نطلب نتيجة التحليل
    final finalResult = await _channel.invokeMethod('getAnalysis', {'id': analysisId});
    return jsonDecode(finalResult);
  } catch (e) {
    throw Exception("خطأ في فحص الملف: $e");
  }
}
}