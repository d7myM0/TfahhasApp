import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'success_page.dart';

class ScanUrlPage extends StatefulWidget {
  final bool isArabic;
  const ScanUrlPage({super.key, required this.isArabic});

  @override
  State<ScanUrlPage> createState() => _ScanUrlPageState();
}

class _ScanUrlPageState extends State<ScanUrlPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> scanUrl() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/scan-url'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': _controller.text}),
    );
    final data = jsonDecode(response.body);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessPage(
          resultText: data['data']?['attributes']?['stats']?.toString() ?? 'No result',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color unifiedColor = isDarkMode ? const Color(0xFFE3F6F5) : const Color(0xFF2C698D);

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
                  style: TextStyle(color: unifiedColor, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: widget.isArabic ? 'أدخل الرابط للفحص' : 'Enter URL to scan',
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
                    style: TextStyle(color: unifiedColor, fontWeight: FontWeight.bold),
                  ),
                  onPressed: scanUrl,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    side: BorderSide(color: unifiedColor, width: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
