import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/requests/Requests.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


class TestLab extends StatefulWidget {
  @override
  State<TestLab> createState() => _TestLabState();
}

class _TestLabState extends State<TestLab> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("PDF Text Replacement")),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await  AuthRequest.sendPdfToServer("assets/pdf/ContractTemplate.pdf");
            },
            child: Text("Replace Text in PDF"),
          ),
        ),
      ),
    );
  }
}

Future<void> replacePdfText() async {
  try {
    // Step 1: Load PDF from assets
    final ByteData data = await rootBundle.load('assets/pdf/ContractTemplate.pdf');
    final Uint8List pdfBytes = data.buffer.asUint8List();

    // Step 2: Write the PDF to a temporary file
    Directory tempDir = await getTemporaryDirectory();
    String inputPdfPath = p.join(tempDir.path, 'ContractTemplate.pdf');
    File inputPdfFile = File(inputPdfPath);
    await inputPdfFile.writeAsBytes(pdfBytes);

    // Step 3: Define output path for the modified PDF
    String outputPdfPath = p.join(tempDir.path, 'FilledContract.pdf');

    // Step 4: Call the Python script using Process.run
    final result = await Process.run('python3', [
       'lib/python/replace_pdf_text.py',
        // Update this with the path to your Python script
      inputPdfPath, // Input PDF file path
      outputPdfPath, // Output PDF file path
    ]);

    // Step 5: Handle the result
    if (result.exitCode == 0) {
      print('Text replacement succeeded: ${result.stdout}');
    } else {
      print('Error: ${result.stderr}');
    }

    // Step 6: Display the path of the modified PDF
    print('Modified PDF saved to: $outputPdfPath');
  } catch (e) {
    print('Error during PDF text replacement: $e');
  }
}
