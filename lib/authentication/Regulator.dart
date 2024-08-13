import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/Authorization.dart';
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/global/globals.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';

class Regulators extends StatefulWidget {
  const Regulators({super.key});

  @override
  State<Regulators> createState() => _RegulatorsState();
}

class _RegulatorsState extends State<Regulators> {
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _expiryDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }


 Future<void> uploadDocument() async {
    // String? authUserEmail = Globals().auth.currentUser?.email;
      String? _fileName;
  Uint8List? _fileBytes;
  String? _fileExtention;
    // var uuid = Uuid().v4();
   


    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null && result.files.isNotEmpty) {
        final PlatformFile file = result.files.first;

        if (file.path != null) {
          final localFile = File(file.path!);
          final Uint8List fileBytes = await localFile.readAsBytes();
          final fileName = result.files.first.name;
          final fileExtension = file.extension;

          print("fileExtension ${fileExtension.runtimeType}");
          print("fileBytes ${fileBytes.runtimeType}");
          setState(() {
            _fileName = fileName;
            _fileBytes = fileBytes;
            _fileExtention = fileExtension;
          });

          if (fileBytes == null || fileExtension == null) {
            print("File picking failed");
            return null;
          }

          // return downloadURL;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select a file to upload")),
        );
      }
    } catch (e) {
      print("got this error in uploadDocument function $e");
    } finally {
      // context.read<CurrentUserProvider>().changeIsLoading();
      // setState(() {
      //   isuploading = !isuploading;
      // });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () =>
                Globals.switchScreens(context: context, screen: Commodites(scrollController: ScrollController(),)),
            icon: Icon(Icons.arrow_back)),
        title: Text('Upload your documents'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload your documents',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text('Document', style: GoogleFonts.poppins(fontSize: 16)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _documentController,
                    decoration: InputDecoration(
                      hintText: 'Document description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed:uploadDocument
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Expiry date', style: GoogleFonts.poppins(fontSize: 16)),
            TextField(
              controller: _expiryDateController,
              decoration: InputDecoration(
                hintText: 'Select date',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 30),
            Text(
              'Documents uploaded',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildUploadedDocument(_expiryDateController.text),
                  _buildUploadedDocument(_expiryDateController.text),
                  _buildUploadedDocument(_expiryDateController.text),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () => Globals.switchScreens(
                    context: context, screen: Authorization()),
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.green.shade800,
                      borderRadius: BorderRadiusDirectional.circular(10)),
                  child: Text(
                    "Continue to trading",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUploadedDocument(String date) {
    return ListTile(
      title:
          Text('Expiry date: $date', style: GoogleFonts.poppins(fontSize: 16)),
      trailing: Icon(Icons.check_circle, color: Colors.green),
    );
  }
}
