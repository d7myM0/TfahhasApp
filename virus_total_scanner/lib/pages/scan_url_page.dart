import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tfahhas/services/virus_total_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'success_page.dart';
import 'dart:convert';
import 'Loading_Screen_page.dart';


class ScanUrlPage extends StatefulWidget {
  final bool isArabic;
  final VoidCallback toggleLanguage;

  const ScanUrlPage({
    super.key,
    required this.isArabic,
    required this.toggleLanguage,
  });

  @override
  State<ScanUrlPage> createState() => _ScanUrlPageState();
}

class _ScanUrlPageState extends State<ScanUrlPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> recentUrls = [];

  // 🟢 SECTION 1: التخزين والمعالجة
  @override
  void initState() {
    super.initState();
    _loadRecentUrls();
  }

  Future<void> _loadRecentUrls() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentUrls = prefs.getStringList('recentUrls') ?? [];
    });
  }

  Future<void> _saveUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> updatedList = [url, ...recentUrls];
    updatedList = updatedList.toSet().toList();
    if (updatedList.length > 10) updatedList = updatedList.sublist(0, 10);
    await prefs.setStringList('recentUrls', updatedList);
    setState(() {
      recentUrls = updatedList;
    });
  }

  Future<void> _deleteAllUrls() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recentUrls');
    setState(() {
      recentUrls = [];
    });
  }

  Future<void> _scanUrl(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    await _saveUrl(url);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoadingScreenPage(url: url,
          isArabic: widget.isArabic,
        ),
      ),
    );
  }

  // 🟦 SECTION 2: واجهة المستخدم
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color unifiedColor = isDarkMode ? const Color(0xFFE3F6F5) : const Color(0xFF2C698D);
    final Color backgroundColor = isDarkMode ? const Color(0xFF272643) : const Color(0xFFE3F6F5);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: unifiedColor,
          tooltip: widget.isArabic ? "رجوع" : "Back",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: widget.toggleLanguage,
            tooltip: widget.isArabic ? "تغيير اللغة" : "Change Language",
            color: unifiedColor,
          ),
        ],
        title: Column(
          children: [
            Text(
              widget.isArabic ? 'فحــص رابـط' : 'Scan a Link',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: unifiedColor),
            ),
            Text(
              widget.isArabic ? 'تحقق من الرابط قبل فتحه' : 'Check link before opening',
              style: TextStyle(fontSize: 12, color: unifiedColor.withOpacity(0.7)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight - 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                        content: Text(widget.isArabic ? 'الرجاء إدخال رابط.' : 'Please enter a URL.'),
                      ),
                    );
                    return;
                  }
                  _scanUrl(url);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  side: BorderSide(color: unifiedColor, width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 30),

              // 🟣 عرض الروابط المحفوظة
              if (recentUrls.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isArabic ? 'الروابط التي تم فحصها مؤخراً' : 'Recently Scanned URLs',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: unifiedColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: widget.isArabic ? 'حذف الكل' : 'Clear All',
                      color: Colors.redAccent,
                      onPressed: _deleteAllUrls,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recentUrls
                      .map((url) => _buildRecentUrlItem(url, isDarkMode))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // 🟧 SECTION 3: عنصر الرابط المفحوص
  Widget _buildRecentUrlItem(String url, bool isDarkMode) {
    return InkWell(
      onTap: () => _scanUrl(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(Icons.link, color: isDarkMode ? Colors.white54 : Colors.grey, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                url,
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
