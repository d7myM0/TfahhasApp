import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class SuccessPage extends StatefulWidget {
  final String resultText;
  final bool isArabic;
  final String? fileName;

  const SuccessPage({
    super.key,
    required this.resultText,
    this.fileName,
    this.isArabic = true,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  late String status;
  late Color statusColor;
  late String scanType;
  late String scanTarget;
  late String scanDate;
  late String scanSummary;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _analyzeResult();
  }

  void _analyzeResult() {
    status = widget.isArabic ? 'غير معروف' : 'Unknown';
    statusColor = Colors.grey;
    scanType = widget.isArabic ? 'غير معروف' : 'Unknown';
    scanTarget = '-';
    scanDate = '-';
    scanSummary = '';

    try {
      final decoded = jsonDecode(widget.resultText);

      if (decoded['meta'] != null && decoded['meta']['url_info'] != null) {
        scanType = widget.isArabic ? 'رابط' : 'Link';
        scanTarget = decoded['meta']['url_info']['url'] ?? '-';
      } else if (decoded['meta'] != null && decoded['meta']['file_info'] != null) {
        scanType = widget.isArabic ? 'ملف' : 'File';
        scanTarget = widget.fileName ?? '-';
      }

      final data = decoded['data'];
      final attributes = data['attributes'];
      final String? analysisStatus = attributes['status'];
      if (analysisStatus == 'queued') {
        // أرجع إلى صفحة التحميل لإعادة المحاولة
        Future.microtask(() {
          Navigator.of(context).pop(); // يغلق صفحة النتيجة
        });
        return; // لا تكمل
      }

      if (attributes['date'] != null) {
        final timestamp = attributes['date'] * 1000;
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
        scanDate = DateFormat('yyyy-MM-dd HH:mm').format(date);
      }

      int malicious = 0;
      int suspicious = 0;
      int scannedEngines = 0;

      if (attributes.containsKey('results') && attributes['results'] is Map) {
        final results = attributes['results'] as Map;

        for (final entry in results.entries) {
          final category = entry.value['category'];
          if (category == 'malicious') {
            malicious++;
            scannedEngines++;
          } else if (category == 'suspicious') {
            suspicious++;
            scannedEngines++;
          } else if (category != 'undetected' && category != null) {
            scannedEngines++;
          }
        }
      }

      int flagged = malicious + suspicious;

      if (scannedEngines > 0) {
        final percent = ((flagged / scannedEngines) * 100).toStringAsFixed(1);
        scanSummary = widget.isArabic
            ? "$percent٪ من المحركات صنّفت الملف كمشبوه أو ضار"
            : "$percent% of scanned engines flagged the file as malicious or suspicious";
      } else {
        status = widget.isArabic ? '⚠️ لم يتم تحليل الملف' : 'File not analyzed';
        scanSummary = widget.isArabic ? "لا توجد نتائج تحليل متاحة" : "No analysis results available";
        statusColor = Colors.grey;
      }

      if (malicious > 0) {
        status = widget.isArabic ? '⚠️ ضار' : 'Malicious';
        statusColor = Colors.red;
      } else if (suspicious > 0) {
        status = widget.isArabic ? '❓ مشبوه' : 'Suspicious';
        statusColor = Colors.orange;
      } else if (scannedEngines > 0) {
        status = widget.isArabic ? '✅ آمن' : 'Safe';
        statusColor = Colors.green;
      }

    } catch (e) {
      print("❌ تحليل النتيجة فشل: $e");
      status = widget.isArabic ? '⚠️ تعذر قراءة النتيجة' : 'Failed to parse result';
      statusColor = Colors.grey;
    }
  }


  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDarkMode ? const Color(0xFF2C698D) : const Color(0xFFE3F6F5);
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black12 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 50, color: statusColor),
                const SizedBox(height: 20),
                Text(
                  widget.isArabic ? "نتيجة الفحص" : "Scan Result",
                  style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 10),
                _infoRow(widget.isArabic ? "النوع" : "Type", scanType, textColor),
                _infoRow(widget.isArabic ? "الرابط/الملف" : "URL/File", scanTarget, textColor),
                _infoRow(widget.isArabic ? "وقت الفحص" : "Scan Time", scanDate, textColor),
                _infoRow(widget.isArabic ? "مستوى الخطورة" : "Risk Level", status, statusColor),
                const SizedBox(height: 16),
                Text(
                  scanSummary,
                  style: GoogleFonts.cairo(fontSize: 14, color: textColor, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(widget.isArabic ? "العودة" : "Back", style: const TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: color)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: GoogleFonts.cairo(color: color)),
          ),
        ],
      ),
    );
  }
}
