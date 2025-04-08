import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback toggleDarkMode;
  final VoidCallback toggleLanguage;
  final bool isArabic;
  final bool isDarkMode;

  const WelcomePage({
    super.key,
    required this.toggleDarkMode,
    required this.toggleLanguage,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final Color unifiedColor = isDarkMode ? const Color(0xFFE3F6F5) : const Color(0xFF2C698D);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFFBAE8E8),
              child: Icon(Icons.shield, size: 60, color: unifiedColor),
            ),
            const SizedBox(height: 30),
            Text(
              isArabic ? 'مرحباً بك في تفحـص' : 'Welcome to TFAHHAS',
              style: GoogleFonts.cairo(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: unifiedColor,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                isArabic
                    ? 'احمِ نفسك من الروابط والملفات الخبيثة'
                    : 'Protect yourself from malicious links & files',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: unifiedColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: Icon(Icons.arrow_forward, color: unifiedColor),
              label: Text(
                isArabic ? 'ابدأ' : 'Get Started',
                style: TextStyle(
                  color: unifiedColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(
                      toggleDarkMode: toggleDarkMode,
                      toggleLanguage: toggleLanguage,
                      isArabic: isArabic,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                side: BorderSide(color: unifiedColor, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
