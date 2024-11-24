import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/fromWakulima/widgets/DocsVerification.dart';
import 'package:itx/fromWakulima/widgets/contant.dart';
import 'package:itx/global/GlobalsHomepage.dart';


class Globals {
  // final BuildContext context;
  // Globals({required this.context});
  double raduis = 20.0;

  static FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<void> initUserDb(
      {required String phoneNumber, required String role}) async {
    await Globals()
        .firebaseFirestore
        .collection("${Globals.auth.currentUser?.email}")
        .doc(Globals.auth.currentUser?.email)
        .set({
      "createdOn": FieldValue.serverTimestamp(),
      "doc": "",
      "docUrl": "",
      "docVerified": false,
      "phoneNumber": phoneNumber,
      "role": role
    });
  }

  static Future<String> userRole({required BuildContext context}) async {
    String functionName = StackTrace.current.toString().split('\n')[0];
    print("Function called: $functionName");
    print("called");
    try {
      String? email = Globals.auth.currentUser?.email;

      DocumentReference docRef =
          FirebaseFirestore.instance.collection("$email").doc(email);

      // Fetch the document
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data =
            docSnapshot.data() as Map<String, dynamic>?;
        String role = data?["role"];
        print("this is the  role $role");
        return role;
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> slowSwitchScreens(
      {required BuildContext context, required Widget screen}) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration:
            Duration(seconds: 1), // Increase duration for a smoother transition
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final opacityTween = Tween(begin: 0.0, end: 1.0);
          final scaleTween = Tween(
              begin: 0.95,
              end: 1.0); // Slight scale transition for ambient effect
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut, // Use easeInOut for a smoother transition
          );

          return FadeTransition(
            opacity: opacityTween.animate(curvedAnimation),
            child: ScaleTransition(
              scale: scaleTween.animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  static Future<void> switchScreens({
    required BuildContext context,
    required Widget screen,
  }) {
    try {
      return Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(
                milliseconds:
                    600), // Increase duration for a smoother transition
            pageBuilder: (context, animation, secondaryAnimation) => screen,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final opacityTween = Tween(begin: 0.0, end: 1.0);
              final scaleTween = Tween(
                  begin: 0.95,
                  end: 1.0); // Slight scale transition for ambient effect
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve:
                    Curves.easeInOut, // Use easeInOut for a smoother transition
              );

              return FadeTransition(
                opacity: opacityTween.animate(curvedAnimation),
                child: ScaleTransition(
                  scale: scaleTween.animate(curvedAnimation),
                  child: child,
                ),
              );
            },
          ));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future checkDocVerified({required BuildContext context}) async {
    try {
      String? email = Globals.auth.currentUser?.email;

      DocumentReference docRef =
          FirebaseFirestore.instance.collection("$email").doc(email);

      // Fetch the document
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Cast the data to a Map<String, dynamic>
        Map<String, dynamic>? data =
            docSnapshot.data() as Map<String, dynamic>?;

        // Check if the 'docVerified' field exists and its value is true
        bool isDocVerified = data?['docVerified'] == true;

        if (isDocVerified) {
          print("The document is verified.");
          switchScreens(context: context, screen: GlobalsHomePage());
        } else {
          print(
              "The document is not verified or 'docVerified' field is missing.");
          switchScreens(context: context, screen: Docsverification());
        }
      } else {
        print("Document does not exist.");
      }
    } catch (e) {
      print("Error checking 'docVerified': $e");
    }
  }

  void nointernet({required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No internet connection'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static void warningsAlerts(
      {required String title,
      required String content,
      required BuildContext context}) {
    CherryToast.warning(
      disableToastAnimation: false,
      animationCurve: Curves.ease,
      animationDuration: Duration(milliseconds: 200),
      title: Text(
        '$title',
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      action: Text(
        content,
        style: GoogleFonts.abel(),
      ),
      actionHandler: () {},
      onToastClosed: () {},
    ).show(context);
  }

  void successAlerts(
      {required String title,
      required String content,
      required BuildContext context}) {
    CherryToast.success(
      disableToastAnimation: false,
      animationCurve: Curves.ease,
      animationDuration: Duration(milliseconds: 500),
      title: Text('$title',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      action: Text(
        "$content",
        style: GoogleFonts.abel(fontWeight: FontWeight.w400),
      ),
      actionHandler: () {},
      onToastClosed: () {},
    ).show(context);
  }

  Widget imagesEdges(
      {required BuildContext context,
      required String image,
      required height,
      required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(raduis),
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget circularWidget(
    ImageUrl,
    String text,
    MaterialPageRoute onpress,
  ) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(2),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              onpress;
            },
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                shape: BoxShape.circle, // Make the container circular
                image: DecorationImage(
                  fit: BoxFit
                      .contain, // Ensure the image covers the entire container
                  image: NetworkImage(
                    ImageUrl,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 6, bottom: 6),
            child: Text(
              text,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget dealsCards(
      {required BuildContext context,
      required String image,
      required String description,
      required String price}) {
    return Container(
      width: AppWidth(context, 0.35),
      height: AppHeight(context, 0.2),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,

                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(22), // Circular border for the image
              child: Image.network(
                image,
                width: AppWidth(context, 0.35),
                height: AppHeight(context, 0.2),
                fit: BoxFit
                    .contain, // Ensures the image covers the area without distortion
              ),
            ),
          ),
          Container(
            width: AppWidth(context, 0.3),
            child: Text(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              description,
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            width: AppWidth(context, 0.3),
            child: Text(
              "Kshs $price",
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildErrorState(
      {required void Function() function, required String items}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 10),
          Text(
            'Error loading $items. Please try again.',
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: function,
            child: Text(
              'Refresh',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

static Widget buildNoDataState({
  required void Function() function,
  required String item,
}) {
  return Center(
    child: Card(
      margin: EdgeInsets.symmetric(horizontal: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 60, color: Colors.blueGrey.shade400),
            const SizedBox(height: 15),
            Text(
              'No ${item == "WareHouse" ? "Orders Placed" : "$item available"}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.blueGrey.shade600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: function,
              icon: Icon(Icons.refresh, color: Colors.white),
              label: Text(
                'Refresh',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

 static  void showErrorToast(String title, String message, BuildContext context) {
    CherryToast.warning(
      title:
          Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      description: Text(message, style: GoogleFonts.abel()),
      animationDuration: Duration(milliseconds: 200),
      animationCurve: Curves.easeInOut,
    ).show(context);
  }


  static void showOperationInProgressSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          CircularProgressIndicator(), // Spinner icon
          SizedBox(width: 20), // Space between spinner and text
          Expanded(
            child: Text(
              'An operation is currently happening, please be patient...',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blueAccent,
      duration: Duration(seconds: 5), // SnackBar duration
    );

    // Show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


 
  static Widget leading({required context, required screen}) {
    return IconButton(
        onPressed: () => switchScreens(context: context, screen: screen),
        icon: Icon(Icons.arrow_back));
  }


 static   Widget MeState() {
  return Container(
    padding: EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.info_outline,
            color: Colors.blue[400],
            size: 32,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Message  Error',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'The Contract Belongs to You',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}



  
}
