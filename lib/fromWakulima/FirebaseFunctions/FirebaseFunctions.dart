//  sign in  with email and password

import 'dart:async';


import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/fromWakulima/AppBloc.dart';
import 'package:itx/fromWakulima/VerifyEmail.dart';
import 'package:itx/fromWakulima/globals.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth _auth = _auth;
User? user;
String _getErrorMessage(String errorCode) {
  return Globals().authErrors[errorCode] ?? "an  undefined error happened";
}

var alertStyle = AlertStyle(
  isCloseButton: false,
  isOverlayTapDismiss: false,
  descStyle: GoogleFonts.abel(
    fontSize: 16,
  ),
  descTextAlign: TextAlign.center,
  animationDuration: Duration(milliseconds: 400),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  titleStyle: GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.bold),
  alertAlignment: Alignment.topCenter,
);

// error codes
Future<void> claudeAIsignup({
  required BuildContext context,
  required String email,
}) async {
  try {
    // Start loading
    context.read<CurrentUserProvider>().changeIsLoading();
    print("in");

    bool connection = await checkInternetConnection(context);
    if (connection) {
      // Configure ActionCodeSettings
      ActionCodeSettings actionCodeSettings = ActionCodeSettings(
        url: 'https://console.firebase.google.com/project/gnovation-wakulima-d5bbc',
        handleCodeInApp: true,
        // iOSBundleId: 'com.example.ios',
        androidPackageName: 'com.example.android',
        androidInstallApp: true,
        androidMinimumVersion: '12',
      );

      // Send sign-in email link
      await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );

      // Save the email locally to use it later
      await saveEmailForSignIn(email);

      // Navigate to the VerifyEmail screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyEmail(email: email)),
      );

    } else {
      Globals().nointernet(context: context);
    }
  } on FirebaseAuthException catch (e) {
    // Handle Firebase-specific errors
    String _error = _getErrorMessage(e.code);
    Globals().warningsAlerts(
        title: "Signup Error", content: _error, context: context);
  } catch (e) {
    print("Signup error $e");
  } finally {
    // Stop loading
    context.read<CurrentUserProvider>().changeIsLoading();
  }
}

// Function to save email locally
Future<void> saveEmailForSignIn(String email) async {
  // Use shared_preferences or another local storage method
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('EMAIL_FOR_SIGN_IN', email);
}

// sign in with email and  password
Future<void> signInWithEmailAndPassword({
  required BuildContext context,
  required String email,
  required String password,
}) async {
  // Start loading state
  context.read<CurrentUserProvider>().changeIsLoading();

  try {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Attempt to sign in with email and password
    await Globals()
        .auth
        .signInWithEmailAndPassword(email: email, password: password);

    // Check if email is verified
    if (Globals().auth.currentUser?.emailVerified == true) {
      // Navigate to home page if email is verified
      Globals().checkDocVerified(context: context);
    } else {
      // Navigate to VerifyEmail screen if email is not verified
      // Globals()
      //     .switchScreens(context: context, screen: VerifyEmail(email: email));
    }

    print("Email signup is $email");
  } on FirebaseAuthException catch (e) {
    // Map FirebaseAuthException codes to user-friendly messages
    final errorMessage = _getErrorMessage(e.code);
    Globals().warningsAlerts(
        title: "Login Error", content: errorMessage, context: context);
  } catch (e) {
    print("Sign in with email and password error: $e");
  } finally {
    // Stop loading state
    context.read<CurrentUserProvider>().changeIsLoading();
  }
}
// signed in user

// function for creating account using email and password

Future<void> signup({
  required BuildContext context,
  required String email_,
  required String password_,
}) async {
  try {
    // Start loading
    context.read<CurrentUserProvider>().changeIsLoading();
    print("in");

    bool connection = await checkInternetConnection(context);
    if (connection) {
      UserCredential userCredential =
    
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email_,
        password: password_,
      );

      // Get the created user
      User? user = userCredential.user;

      // Send email verification if user is not null
      if (user != null) {
        Globals().initUserDb();

        await user.sendEmailVerification();

        // Navigate to the VerifyEmail screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerifyEmail(email: email_)),
        );
      }
    } else {
      Globals().nointernet(context: context);
    }
  } on FirebaseAuthException catch (e) {
    // Handle Firebase-specific errors
    String _error = _getErrorMessage(e.code);
    Globals().warningsAlerts(
        title: "Signup Error", content: _error, context: context);
  } catch (e) {
    print("Signup error $e");
  } finally {
    // Stop loading
    context.read<CurrentUserProvider>().changeIsLoading();
  }
}

Future<void> resendLink({required BuildContext context}) async {
  try {
    context.read<CurrentUserProvider>().changeIsLoading();
    await Future.delayed(Duration(seconds: 2));
    await user?.sendEmailVerification();
    Globals().successAlerts(
        title: "Verification Link",
        content:
            "verification link sent to  ${FirebaseAuth.instance.currentUser?.email}",
        context: context);
  } on FirebaseAuthException catch (e) {
    String _error = _getErrorMessage(e.code);
    Globals().warningsAlerts(
        title: "Verification", content: _error, context: context);
  } catch (e) {
    print("Resend Link Error $e");
  } finally {
    context.read<CurrentUserProvider>().changeIsLoading();
  }
}

Future<void> resetPassword({required context, required email}) async {
  try {
    await _auth.sendPasswordResetEmail(email: email);
    Alert(
      context: context,
      style: alertStyle,
      title: "Email Reset",
      desc: "Sent Email Reset Link to $email",
      image: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image:
              "https://global.discourse-cdn.com/business7/uploads/jupiter/original/2X/c/c0297d064f2bfc5ecf73ad80efa3b288e88a80b9.gif",
          height: 200),
      buttons: [
        DialogButton(
          width: 300,
          child: Text(
            "Okay",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.red.shade200,
          radius: BorderRadius.circular(20.0),
        ),
      ],
    ).show();
  } on FirebaseAuthException catch (e) {
    return CherryToast.warning(
      disableToastAnimation: false,
      animationCurve: Curves.ease,
      width: 600,
      animationDuration: Duration(milliseconds: 200),
      title: Text('${e.message}', style: GoogleFonts.abel(fontSize: 18)),
      action: Text(
        e.code,
        style: GoogleFonts.abel(),
      ),
      actionHandler: () {},
      onToastClosed: () {},
    ).show(context);
  }
}

class Authentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    print("Starting Google Sign-In");

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      print("Google Sign-In account retrieved: ${googleSignInAccount != null}");

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);
          user = userCredential.user;
          Globals().initUserDb();

          // await user?.sendEmailVerification();
          if (user?.emailVerified == true) {
            Globals().checkDocVerified(context: context);
          } else {
            // Globals().switchScreens(
            //     context: context, screen: VerifyEmail(email: "${user?.email}"));
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            print('The account already exists with a different credential.');
            // Handle the error accordingly in your app
          } else if (e.code == 'invalid-credential') {
            print('The credential received is malformed or has expired.');
            // Handle the error accordingly in your app
          } else {
            print('FirebaseAuthException: ${e.message}');
            // Handle other FirebaseAuthException errors accordingly in your app
          }
        } catch (e) {
          print("Google sign-up error: $e");
          // Handle other errors accordingly in your app
        }
      } else {
        print("Google Sign-In was canceled by the user.");
        // Handle the scenario where the user cancels the Google Sign-In
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
      // Handle errors related to Google Sign-In process
    }

    return user;
  }
}
// checking if stream has data

Future<int> getNextId() async {
  final DocumentReference counterRef =
      FirebaseFirestore.instance.collection('counters').doc('documentCounter');

  return FirebaseFirestore.instance
      .runTransaction((Transaction transaction) async {
    DocumentSnapshot snapshot = await transaction.get(counterRef);

    if (!snapshot.exists) {
      await transaction.set(counterRef, {'currentId': 1});
      return 1;
    }

    // Cast the snapshot data to Map<String, dynamic>
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    int currentId = data['currentId'];
    int nextId = currentId.toInt() + 1;

    transaction.update(counterRef, {'currentId': nextId});
    return nextId;
  });
}
