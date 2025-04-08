import 'package:flutter/material.dart';
import 'scan_url_page.dart';
import 'scan_file_page.dart';

class HomePage extends StatelessWidget {
  final VoidCallback toggleDarkMode;
  final VoidCallback toggleLanguage;
  final bool isArabic;

  const HomePage({
    super.key,
    required this.toggleDarkMode,
    required this.toggleLanguage,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // اللون الموحد حسب الوضع
    final Color unifiedColor = isDarkMode ? const Color(0xFFE3F6F5) : const Color(0xFF2C698D);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? 'تفـحص' : 'TFAHHAS',
          style: TextStyle(color: unifiedColor),
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
        actions: [
          IconButton(icon: Icon(Icons.language, color: unifiedColor), onPressed: toggleLanguage),
          IconButton(icon: Icon(Icons.dark_mode, color: unifiedColor), onPressed: toggleDarkMode),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight - 40,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_outlined, size: 80, color: unifiedColor),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  icon: Icon(Icons.link, color: unifiedColor),
                  label: Text(
                    isArabic ? 'فحص رابط' : 'Scan Link',
                    style: TextStyle(color: unifiedColor),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ScanUrlPage(isArabic: isArabic)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    side: BorderSide(color: unifiedColor, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.insert_drive_file, color: unifiedColor),
                  label: Text(
                    isArabic ? 'فحص ملف' : 'Scan File',
                    style: TextStyle(color: unifiedColor),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ScanFilePage(isArabic: isArabic)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    side: BorderSide(color: unifiedColor, width: 2),
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
