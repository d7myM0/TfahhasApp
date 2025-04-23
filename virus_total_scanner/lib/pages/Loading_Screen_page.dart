import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/virus_total_service.dart';
import 'success_page.dart';

class LoadingScreenPage extends StatefulWidget {
  final String? filePath;
  final String? fileName;
  final String? url;
  final bool isArabic;

  const LoadingScreenPage({
    super.key,
    this.filePath,
    this.fileName,
    this.url,
    this.isArabic = true,
  });

  @override
  State<LoadingScreenPage> createState() => _LoadingScreenPageState();
}

class _LoadingScreenPageState extends State<LoadingScreenPage> {
  int retries = 0;
  final int maxRetries = 10;
  @override
  void initState() {
    super.initState();
    widget.url != null ? scanUrl() : scanFile();
  }

  void scanFile() async {
    try {
      final result = await VirusTotalService.scanFile(widget.filePath!);
      final status = result['data']?['attributes']?['status'];

      if (status == 'queued' && retries < maxRetries) {
        retries++;
        Future.delayed(const Duration(seconds: 3), scanFile);
        return;
      }

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
        SnackBar(content: Text(widget.isArabic ? 'فشل فحص الملف' : 'File scan failed')),
      );
      Navigator.pop(context);
    }
  }

  void scanUrl() async {
    try {
      final result = await VirusTotalService.scanUrl(widget.url!);
      final status = result['data']?['attributes']?['status'];

      if (status == 'queued' && retries < maxRetries) {
        retries++;
        Future.delayed(const Duration(seconds: 3), scanUrl);
        return;
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SuccessPage(
            resultText: jsonEncode(result),
            isArabic: widget.isArabic,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.isArabic ? 'فشل فحص الرابط' : 'URL scan failed')),
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
        backgroundColor: backgroundColor,
        elevation: 0,
        toolbarHeight: 0,
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
              widget.url != null
                  ? (widget.isArabic ? "جاري فحص الرابط..." : "Scanning the URL...")
                  : (widget.isArabic ? "جاري فحص الملف..." : "Scanning the file..."),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
