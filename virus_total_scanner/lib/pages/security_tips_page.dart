import 'package:flutter/material.dart';

class SecurityTipsPage extends StatelessWidget {
  final bool isArabic;
  final VoidCallback toggleLanguage;
  final VoidCallback toggleDarkMode;

  const SecurityTipsPage({
    super.key,
    required this.isArabic,
    required this.toggleLanguage,
    required this.toggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color unifiedColor = isDarkMode ? const Color(0xFFE3F6F5) : const Color(0xFF2C698D);
    final Color backgroundColor = isDarkMode ? const Color(0xFF272643) : const Color(0xFFE3F6F5);
    final tips = isArabic ? _tipsArabic : _tipsEnglish;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
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
            onPressed: toggleDarkMode,
            tooltip: isArabic ? "الوضع الداكن" : "Dark Mode",
            color: unifiedColor,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF2C698D).withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: unifiedColor.withOpacity(0.3)),
            ),
            child: Text(
              tips[index],
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
            ),
          );
        },
      ),
    );
  }

  List<String> get _tipsArabic => [
    '.لا تضغط على روابط مشبوهة تُرسل عبر الرسائل أو البريد',
    '.استخدم برامج حماية موثوقة وحدّثها باستمرار',
    '.تأكد من وجود علامة القفل (HTTPS) عند إدخال بياناتك ',
    '.لا تشارك معلوماتك الشخصية مع أي جهة غير موثوقة',
    '.غيّر كلمات المرور بشكل دوري، واستخدم كلمات مرور قوية',
  ];

  List<String> get _tipsEnglish => [
    'Do not click suspicious links sent via messages or emails.',
    'Use trusted antivirus software and keep it updated.',
    'Ensure the website has a lock icon (HTTPS) before entering data.',
    'Never share personal information with untrusted sources.',
    'Change your passwords regularly and use strong ones.',
  ];
}
