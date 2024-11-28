import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

// final user = FirebaseAuth.instance.currentUser;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      if (kIsWeb) {
        // For Web
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } else {
        // For Mobile
        final GoogleSignIn googleSignIn = GoogleSignIn();

        // Attempt Google Sign-In
        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn();

        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;

          // Get credentials
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );

          try {
            final UserCredential userCredential =
                await auth.signInWithCredential(credential);

            user = userCredential.user;
          } on FirebaseAuthException catch (e) {
            // Handle Firebase Authentication Errors
            if (e.code == 'account-exists-with-different-credential') {
              print(
                  "The account already exists with a different credential. Please try a different login method.");
            } else if (e.code == 'invalid-credential') {
              print("The credential provided is invalid. Please try again.");
            } else {
              print("An unknown FirebaseAuthException occurred: ${e.message}");
            }
          } catch (e) {
            // Catch any other errors
            print("An unexpected error occurred during sign-in: $e");
          }
        } else {
          print("Google Sign-In was aborted by the user.");
        }
      }
    } catch (e) {
      // General catch block for any other unexpected errors
      print("A general error occurred: $e");
    }

    return user;
  }
}

