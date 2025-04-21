import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/virus_total_service.dart';
import 'success_page.dart';

class LoadingScreenPage extends StatefulWidget {
  final String filePath;
  final String fileName;
  final bool isArabic;

  const LoadingScreenPage({
    super.key,
    required this.filePath,
    required this.fileName,
    this.isArabic = true,
  });

  @override
  State<LoadingScreenPage> createState() => _LoadingScreenPageState();
}

class _LoadingScreenPageState extends State<LoadingScreenPage> {
  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() async {
    try {
      final result = await VirusTotalService.scanFile(widget.filePath);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(
            resultText: jsonEncode(result),
            fileName: widget.fileName,
            isArabic: widget.isArabic,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.isArabic ? 'فشل الفحص' : 'Scan failed')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFFE3F6F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor, // ✅ توحيد اللون
        elevation: 0, // ✅ إزالة الظل
        toolbarHeight: 0, // ✅ إخفاء الـ AppBar تمامًا
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isArabic ? 'الرجاء الانتظار' : 'Please wait',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              widget.isArabic ? "جاري فحص الملف..." : "Scanning the file...",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
