import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Docsverification extends StatefulWidget {
  const Docsverification({super.key});

  @override
  State<Docsverification> createState() => _DocsverificationState();
}

class _DocsverificationState extends State<Docsverification>
    with SingleTickerProviderStateMixin {
  String? _fileName;
  Uint8List? _fileBytes;
  String? _fileExtention;

  double upload_progress = 0.0;
  // FilePickerResult? _file;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> uploadDocument() async {
    String? authUserEmail = Globals.auth.currentUser?.email;
    // var uuid = Uuid().v4();
    context.read<CurrentUserProvider>().changeIsLoading();

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
      context.read<CurrentUserProvider>().changeIsLoading();
      // setState(() {
      //   isuploading = !isuploading;
      // });
    }
  }

  Future<void> SaveDoc({required BuildContext context}) async {
    String? authUserEmail = Globals.auth.currentUser?.email;
    if (_fileBytes != null && _fileExtention != null && _fileName != null) {
      final mimeType = Globals().getMimeType(_fileExtention);
      final metaData = SettableMetadata(contentType: mimeType);
      context.read<CurrentUserProvider>().changeIsLoading();
      try {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref('$authUserEmail/$_fileName')
            .putData(_fileBytes!, metaData);

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            upload_progress = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        });

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        await Globals()
            .firebaseFirestore
            .collection("${Globals.auth.currentUser?.email}")
            .doc(authUserEmail)
            .update({
          "createdOn": FieldValue.serverTimestamp(),
          "doc": _fileName,
          "docUrl": downloadURL,
          "docVerified": true,
        });

        context.read<CurrentUserProvider>().changeIsLoading();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green.shade400,
            content: Text(
              "Uplaoded Success",
              style: GoogleFonts.poppins(color: Colors.white),
            )));

        Future.delayed(Duration(seconds: 1)).then((_) {
          Globals().checkDocVerified(context: context);
        });
      } catch (e) {
        print("saveDoc error $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a file to upload")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Container(
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadiusDirectional.circular(30),
        //       color: Colors.blueGrey.shade100),
        //   child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        // ),
        centerTitle: true,
        title: Text(
          "Upload Document",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload Seller License",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w400),
                // style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 10),
              Text(
                // textAlign: TextAlign.center,
                "Please select a license file you wish to upload.\nEnsure that the file is in an appropriate format and provides a clear and concise information.",
                // style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(height: 10),
              _fileName != null
                  ? Text(
                      "Selected File: ${_fileName}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      "No file Chosen",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
              SizedBox(height: 10),
              DottedBorder(
                color: Colors.black54,
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                padding: EdgeInsets.all(6),
                child: Container(
                    margin: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.file_copy,
                          size: 40,
                          color: Colors.black54,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Select Document to uplaod",
                          style: GoogleFonts.poppins(color: Colors.black54),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            uploadDocument();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(10),
                                color: Colors.grey.shade300),
                            child: Text(
                              textAlign: TextAlign.center,
                              "Choose File",
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  SaveDoc(context: context);
                },
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(10),
                        color: Colors.grey.shade400),
                    width: 250,
                    height: 50,
                    child: context.watch<CurrentUserProvider>().isLoading
                        ? LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white, size: 40)
                        : Text(
                            "Upload",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
