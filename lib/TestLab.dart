import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path/path.dart' as p;  // For joining paths

Future<void> fillPdfWithData(String sellerName, String buyerName, String contractDate) async {
  // Load and modify the PDF
  final ByteData data = await rootBundle.load('assets/pdf/ContractTemplate.pdf');
  List<int> bytes = data.buffer.asUint8List();
  PdfDocument document = PdfDocument(inputBytes: bytes);

  PdfPage page = document.pages[0];
  PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 12);
  page.graphics.drawString(sellerName, font, bounds: const Rect.fromLTWH(150, 200, 200, 20));
  page.graphics.drawString(buyerName, font, bounds: const Rect.fromLTWH(150, 250, 200, 20));
  page.graphics.drawString(contractDate, font, bounds: const Rect.fromLTWH(150, 150, 200, 20));

  // Save the PDF to the Downloads folder
  Directory? downloadsDir = await getDownloadsDirectory();
  if (downloadsDir != null) {
    String downloadsPath = downloadsDir.path;

    // Create Downloads folder if not exists (only for Android or iOS)
    Directory downloadsFolder = Directory(downloadsPath);
    if (!await downloadsFolder.exists()) {
      await downloadsFolder.create(recursive: true);
    }

    // File path to save the PDF
    String filePath = p.join(downloadsFolder.path,'filled_contract.pdf');
    File file = File(filePath);

    // Save PDF
    await file.writeAsBytes(document.saveSync());
    document.dispose();

    print("PDF saved to ${file.path}");
  } else {
    print("Could not find the Downloads folder.");
  }
}

// Get Downloads directory (specific to Android and iOS)
Future<Directory?> getDownloadsDirectory() async {
  if (Platform.isAndroid || Platform.isIOS) {
    return await getExternalStorageDirectory();  // For Android/iOS Downloads
  } else {
    return await getApplicationDocumentsDirectory();  // For web and desktop
  }
}

// Request permission (for Android storage access)
Future<void> requestPermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}


class TestLab extends StatefulWidget {
  const TestLab({super.key});

  @override
  State<TestLab> createState() => _TestLabState();
}

class _TestLabState extends State<TestLab> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: IconButton(
              onPressed: () async {
                fillPdfWithData("John Doe", "Jane Smith", "2023-12-25");
              },
              icon: Icon(
                Icons.picture_as_pdf_rounded,
                size: 40,
              )),
        ),
      ),
    );
  }
}
