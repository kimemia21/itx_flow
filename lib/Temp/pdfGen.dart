import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

class FileUtils {
  static Future<Directory?> getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        print('Storage permission not granted');
        return null;
      }
    }

    Directory? downloadsDir = await getExternalStorageDirectory();
    if (downloadsDir != null) {
      final downloadsPath = '${downloadsDir.path}/Download';
      final downloadFolder = Directory(downloadsPath);
      
      if (!await downloadFolder.exists()) {
        await downloadFolder.create(recursive: true);
      }
      
      return downloadFolder;
    }
    
    return null;
  }

  static Future<File?> saveFileToDownloads(
    Uint8List fileBytes, 
    String fileName
  ) async {
    try {
      Directory? downloadsDir = await getDownloadsDirectory();
      
      if (downloadsDir == null) {
        print('Could not access downloads directory');
        return null;
      }

      final filePath = '${downloadsDir.path}/$fileName';
      
      File file = File(filePath);
      await file.writeAsBytes(fileBytes);

      print('File saved successfully at: $filePath');
      return file;
    } catch (e) {
      print('Error saving file: $e');
      return null;
    }
  }

  static Future<File?> saveFileWithSAF(
    Uint8List fileBytes, 
    String fileName
  ) async {
    try {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save PDF File',
        fileName: fileName,
        bytes: fileBytes,
      );

      if (result != null) {
        print('File saved at: $result');
        return File(result);
      }
      return null;
    } catch (e) {
      print('Error saving file with SAF: $e');
      return null;
    }
  }
}

class PdfGenerator {
static Future<Uint8List> captureEntireScreen(GlobalKey screenshotKey) async {
  try {
  
    await Future.delayed(Duration(milliseconds: 500));

  
    RenderRepaintBoundary boundary = screenshotKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    
    
    ScrollController? scrollController;
    void findScrollController(Element element) {
      if (element.widget is Scrollable) {
        scrollController = (element.widget as Scrollable).controller;
        return;
      }
      element.visitChildren(findScrollController);
    }

   
    screenshotKey.currentContext!.visitChildElements(findScrollController);

   
    if (scrollController != null) {
      scrollController!.jumpTo(scrollController!.position.maxScrollExtent);
      await Future.delayed(Duration(milliseconds: 500));
    }

 
    ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    return byteData!.buffer.asUint8List();
  } catch (e) {
    print('Error capturing screenshot: $e');
    rethrow;
  }
}

  static Future<File> saveAsPDF(GlobalKey screenshotKey) async {
    try {
      Uint8List imageBytes = await captureEntireScreen(screenshotKey);

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Image(
              pw.MemoryImage(imageBytes),
              fit: pw.BoxFit.contain,
            );
          },
        ),
      );

     String fileName = 'forward_contract_${DateTime.now().millisecondsSinceEpoch}.pdf';

      File? savedFile = await FileUtils.saveFileToDownloads(
        await pdf.save(), 
        fileName
      );

      if (savedFile == null) {
        savedFile = await FileUtils.saveFileWithSAF(
          await pdf.save(), 
          fileName
        );
      }

      return savedFile!;

    } catch (e) {
      print('Error generating PDF: $e');
      rethrow;
    }
  }

  static Future<void> printPDF(GlobalKey screenshotKey) async {
    try {
      Uint8List imageBytes = await captureEntireScreen(screenshotKey);

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Image(
              pw.MemoryImage(imageBytes),
              fit: pw.BoxFit.contain,
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      print('Error printing PDF: $e');
      rethrow;
    }
  }
}