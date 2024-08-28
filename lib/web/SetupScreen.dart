import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/web/ContractsScreen.dart';

class SetupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ITX Validation',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Handle menu action
          },
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.search, color: Colors.black),
          //   onPressed: () {
          //     // Handle search action
          //   },
          // ),
          // IconButton(
          //   icon: Icon(Icons.notifications, color: Colors.black),
          //   onPressed: () {
          //     // Handle notifications action
          //   },
          // ),
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Icon(Icons.person, color: Colors.black),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Let's get you set up",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "You'll need to provide some basic information about yourself and your trading experience. This should only take a few minutes.",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Enter the code emailed to you',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "We have sent a code to this email to verify it’s yours.",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePageWeb(title: "HOME")));
                        // Handle continue action
                      },
                      child: Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "By continuing, you agree to the Commodity Exchange Privacy Policy and Terms of Service.",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black54,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
