import 'package:flutter/material.dart';
import 'scan_url_page.dart';
import 'scan_file_page.dart';
import 'security_tips_page.dart';

class HomePage extends StatefulWidget {
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
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isArabic;

  @override
  void initState() {
    super.initState();
    isArabic = widget.isArabic;
  }

  void toggleLanguage() {
    setState(() {
      isArabic = !isArabic;
    });
    widget.toggleLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color unifiedColor = isDarkMode ? const Color(0xFFE3F6F5) : const Color(0xFF2C698D);
    final Color backgroundColor = isDarkMode ? const Color(0xFF272643) : const Color(0xFFE3F6F5);
    final Color cardColor = isDarkMode ? const Color(0xFF272643) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildHeaderSection(unifiedColor, backgroundColor),
      body: _buildMainSection(unifiedColor, cardColor, isDarkMode),
      bottomNavigationBar: _buildFooterSection(),
    );
  }

  // 🟦 SECTION 1: Header
  PreferredSizeWidget _buildHeaderSection(Color unifiedColor, Color backgroundColor) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.translate),
        onPressed: toggleLanguage,
        tooltip: isArabic ? "تغيير اللغة" : "Change Language",
        color: unifiedColor,
      ),
      title: Column(
        children: [
          Text(
            isArabic ? 'تفـحص' : 'TFAHHAS',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: unifiedColor),
          ),
          Text(
            isArabic
                ? 'حماية من الروابط والملفات الضارة'
                : 'Protection from malicious links & files',
            style: TextStyle(fontSize: 12, color: unifiedColor.withOpacity(0.7)),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.dark_mode),
          onPressed: widget.toggleDarkMode,
          tooltip: isArabic ? "الوضع الداكن" : "Dark Mode",
          color: unifiedColor,
        ),
      ],
    );
  }


  // 🟩 SECTION 2: Main content
  Widget _buildMainSection(Color unifiedColor, Color cardColor, bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildCard(
            icon: Icons.link,
            title: isArabic ? 'فحص رابط' : 'Scan Link',
            subtitle: isArabic ? 'تحقق من أمان الروابط قبل فتحها' : 'Check the safety of links before opening',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ScanUrlPage(
                  isArabic: isArabic,
                toggleLanguage: toggleLanguage,)),
            ),
            cardColor: cardColor,
            textColor: unifiedColor,
            isDarkMode: isDarkMode,
          ),
          _buildCard(
            icon: Icons.insert_drive_file,
            title: isArabic ? 'فحص ملف' : 'Scan File',
            subtitle: isArabic ? 'تأكد من خلو الملفات من البرمجيات الخبيثة' : 'Ensure files are malware-free',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ScanFilePage(
                isArabic: isArabic,
                toggleLanguage: toggleLanguage,
              )),
            ),
            cardColor: cardColor,
            textColor: unifiedColor,
            isDarkMode: isDarkMode,
          ),
          // _buildCard(
          //   icon: Icons.history,
          //   title: isArabic ? 'سجل الفحوصات' : 'Scan History',
          //   subtitle: isArabic ? 'عرض الملفات والروابط التي تم فحصها' : 'View scanned files and links',
          //   onTap: () {},
          //   cardColor: cardColor,
          //   textColor: unifiedColor,
          //   isDarkMode: isDarkMode,
          // ),
          _buildCard(
            icon: Icons.shield,
            title: isArabic ? 'نصائح الأمان' : 'Security Tips',
            subtitle: isArabic ? 'تعلم كيفية البقاء آمناً عبر الإنترنت' : 'Learn how to stay safe online',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SecurityTipsPage(
                  isArabic: isArabic,
                  toggleLanguage: toggleLanguage,
                  toggleDarkMode: widget.toggleDarkMode,
                ),
              ),
            ),
            cardColor: cardColor,
            textColor: unifiedColor,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  // 🟫 SECTION 3: Footer
  Widget _buildFooterSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Text(
        isArabic ? 'تفحص - النسخة 1.0' : 'TFAHHAS - v1.0',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }

  // 💠 بطاقة مخصصة
  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color cardColor,
    required Color textColor,
    required bool isDarkMode,
  }) {
    return Card(
      color: cardColor,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: textColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
