import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/uploadCerts/Regulator.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

void showAuthorizationAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          textAlign: TextAlign.center,
          'Not Authorized',
          style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent),
        ),
        content: Text(
          'You are not authorized to trade.\nClick the button below to upload your documents for authorization.',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
            
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: Regulators(),
                  withNavBar: true,
                );
                // Close the dialog
                // Navigate to document upload page
                // Navigator.push(context, MaterialPageRoute(builder: (_) => UploadDocumentScreen()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file,color: Colors.white,),
                  Text(
                    'Upload Document',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
