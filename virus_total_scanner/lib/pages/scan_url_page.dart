import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virus_total_scanner/services/virus_total_service.dart';
import 'success_page.dart';
import 'dart:convert';

class ScanUrlPage extends StatefulWidget {
  final bool isArabic;
  const ScanUrlPage({super.key, required this.isArabic});

  @override
  State<ScanUrlPage> createState() => _ScanUrlPageState();
}

class _ScanUrlPageState extends State<ScanUrlPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color unifiedColor =
    isDarkMode ? const Color(0xFFE3F6F5) : const Color(0xFF2C698D);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isArabic ? "فحص رابط" : "Scan a URL",
          style: TextStyle(color: unifiedColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: unifiedColor,
        leading: Navigator.of(context).canPop()
            ? IconButton(
          icon: Icon(Icons.arrow_back, color: unifiedColor),
          onPressed: () => Navigator.of(context).pop(),
        )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight - 40,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.link, size: 80, color: unifiedColor),
                const SizedBox(height: 30),
                TextField(
                  controller: _controller,
                  style: TextStyle(
                      color: unifiedColor, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: widget.isArabic
                        ? 'أدخل الرابط للفحص'
                        : 'Enter URL to scan',
                    labelStyle: TextStyle(color: unifiedColor),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: unifiedColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.search, color: unifiedColor),
                  label: Text(
                    widget.isArabic ? 'فحص الرابط' : 'Scan URL',
                    style: TextStyle(
                      color: unifiedColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () async {
                    String url = _controller.text.trim().toLowerCase();

                    if (url.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(widget.isArabic
                              ? 'الرجاء إدخال رابط.'
                              : 'Please enter a URL.'),
                        ),
                      );
                      return;
                    }

                    if (!url.startsWith('http://') &&
                        !url.startsWith('https://')) {
                      url = 'https://$url';
                    }

                    try {
                      debugPrint("🔍 Sending URL: $url");
                      final result = await VirusTotalService.scanUrl(url);
                      debugPrint("✅ API Response: $result");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SuccessPage(
                            resultText: jsonEncode(result),
                            isArabic: widget.isArabic,
                          ),
                        ),
                      );
                    } catch (e) {
                      debugPrint("❌ Error: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(widget.isArabic
                              ? 'حدث خطأ أثناء الفحص.'
                              : 'An error occurred during the scan.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    side: BorderSide(color: unifiedColor, width: 2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
