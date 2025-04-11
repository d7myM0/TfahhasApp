import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

class SuccessPage extends StatefulWidget {
  final String resultText;
  final bool isArabic;

  const SuccessPage({
    super.key,
    required this.resultText,
    this.isArabic = true,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  late String status;
  late Color statusColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _analyzeResult();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: statusColor.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Text(
            status,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: Text(
                widget.isArabic ? "موافق" : "OK",
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      );
    });
  }

  void _analyzeResult() {
    status = widget.isArabic ? 'غير معروف' : 'Unknown';
    statusColor = Colors.grey;

    try {
      final decoded = jsonDecode(widget.resultText);

      if (decoded['error'] != null) {
        status = widget.isArabic ? '❌ فشل الفحص' : 'Scan Failed';
        statusColor = Colors.red;
        return;
      }

      final data = decoded['data'];
      if (data == null || data is! Map) {
        status = widget.isArabic ? '⚠️ لا يمكن تحليل الملف' : 'Unable to analyze the file';
        statusColor = Colors.grey;
        return;
      }

      final attributes = data['attributes'];
      if (attributes == null || attributes is! Map) {
        status = widget.isArabic
            ? '⚠️ لم يتم العثور على بيانات التحليل'
            : 'No analysis attributes found';
        statusColor = Colors.grey;
        return;
      }

      int malicious = 0;
      int suspicious = 0;

      if (attributes.containsKey('stats') && attributes['stats'] is Map) {
        final stats = attributes['stats'];
        malicious = stats['malicious'] ?? 0;
        suspicious = stats['suspicious'] ?? 0;
      }

      if ((malicious + suspicious) == 0 && attributes.containsKey('results')) {
        final results = attributes['results'];
        if (results is Map) {
          for (final entry in results.entries) {
            final category = entry.value['category'];
            if (category == 'malicious') malicious++;
            if (category == 'suspicious') suspicious++;
          }
        }
      }

      if (malicious > 0) {
        status = widget.isArabic ? '⚠️ ضار' : 'Malicious';
        statusColor = Colors.red;
      } else if (suspicious > 0) {
        status = widget.isArabic ? '❓ مشبوه' : 'Suspicious';
        statusColor = Colors.orange;
      } else {
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
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.shrink(),
    );
  }
}
