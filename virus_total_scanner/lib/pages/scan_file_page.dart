import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'Loading_Screen_page.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanFilePage extends StatefulWidget {
  final bool isArabic;
  final VoidCallback toggleLanguage;

  const ScanFilePage({
    super.key,
    required this.isArabic,
    required this.toggleLanguage,
  });

  @override
  State<ScanFilePage> createState() => _ScanFilePageState();
}

class _ScanFilePageState extends State<ScanFilePage> {
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
              widget.isArabic ? 'فحــص ملـف' : 'Scan a File',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: unifiedColor),
            ),
            Text(
              widget.isArabic
                  ? 'قم برفع ملف للتحقق من سلامته'
                  : 'Upload a file to check its safety',
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload_file, size: 80, color: unifiedColor),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  icon: Icon(Icons.file_upload, color: unifiedColor),
                  label: Text(
                    widget.isArabic ? "اختر ملفاً للفحص" : "Choose File to Scan",
                    style: TextStyle(
                      color: unifiedColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    PermissionStatus status = await Permission.storage.request();
                    if (!status.isGranted) {
                      print("الصلاحية غير مفعلة!");
                      return;
                    }

                    await FilePicker.platform.clearTemporaryFiles();
                    FilePickerResult? picked = await FilePicker.platform.pickFiles();

                    if (picked != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoadingScreenPage(
                            filePath: picked.files.single.path!,
                            fileName: picked.files.single.name,
                            isArabic: widget.isArabic,
                          ),
                        ),
                      );
                    }
                  },
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
