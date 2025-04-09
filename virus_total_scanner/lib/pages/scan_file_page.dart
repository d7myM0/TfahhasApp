import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'success_page.dart';
import 'package:virus_total_scanner/services/virus_total_service.dart';
import 'package:permission_handler/permission_handler.dart';



class ScanFilePage extends StatefulWidget {
  final bool isArabic;

  const ScanFilePage({super.key, required this.isArabic});

  @override
  State<ScanFilePage> createState() => _ScanFilePageState();
}

class _ScanFilePageState extends State<ScanFilePage> {


  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color unifiedColor = isDarkMode ? const Color(0xFFE3F6F5) : const Color(0xFF2C698D);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isArabic ? "فحص ملف" : "Scan a File",
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
                    FilePickerResult? picked = await FilePicker.platform.pickFiles();
                    if (picked != null) {
                      String filePath = picked.files.single.path!;
                      try {
                        final result = await VirusTotalService.scanFile(filePath);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SuccessPage(
                              resultText: result.toString(),
                            ),
                          ),
                        );
                        // ✅ أو مرر النتيجة إلى صفحة SuccessPage مثلاً
                      } catch (e) {
                        print("Error: $e");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    side: BorderSide(color: unifiedColor, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
