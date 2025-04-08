import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'pages/welcome_page.dart';

void main() {
  runApp(const VirusScannerApp());
}

class VirusScannerApp extends StatefulWidget {
  const VirusScannerApp({super.key});

  @override
  State<VirusScannerApp> createState() => _VirusScannerAppState();
}

class _VirusScannerAppState extends State<VirusScannerApp> {
  bool isDarkMode = false;
  bool isArabic = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TFAHHAS',
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDarkMode ? Color(0xFF272643) : Color(0xFFE3F6F5),
        textTheme: GoogleFonts.cairoTextTheme().apply(
          bodyColor: isDarkMode ? Color(0xFFE3F6F5) : Color(0xFF2C698D),
          displayColor: isDarkMode ? Color(0xFFE3F6F5) : Color(0xFF2C698D),
        ),
        colorSchemeSeed: const Color(0xFF2C698D),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(
        toggleDarkMode: () => setState(() => isDarkMode = !isDarkMode),
        toggleLanguage: () => setState(() => isArabic = !isArabic),
        isArabic: isArabic,
        isDarkMode: isDarkMode,
      ),
    );
  }
}
