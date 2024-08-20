import 'dart:async';

import 'package:itx/authentication/Login.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/fromWakulima/globals.dart';
import 'package:itx/fromWakulima/AppBloc.dart';
import 'package:itx/fromWakulima/FirebaseFunctions/FirebaseFunctions.dart';
import 'package:itx/fromWakulima/Homepage.dart';
import 'package:itx/fromWakulima/contant.dart';
import 'package:itx/fromWakulima/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../authentication/SignUp.dart';

class VerifyEmail extends StatefulWidget {
  final String email;
  const VerifyEmail({super.key, required this.email});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState(email: email);
}

class _VerifyEmailState extends State<VerifyEmail>
    with SingleTickerProviderStateMixin {
  final String email;
  _VerifyEmailState({required this.email});

  dynamic _animationController;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animationController.forward();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      Globals().auth.currentUser?.reload();
      if (Globals().auth.currentUser?.emailVerified == true) {
        Globals().checkDocVerified(context: context);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ScaleTransition(
              scale: Tween(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.elasticOut,
                ),
              ),
              child: Lottie.asset(
                "assets/gif/AnimationOne.json", // Ensure you have this animation in your assets
                height: 150,
                width: 150,
              ),
            ),
            SizedBox(height: 20),
            FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeIn,
                ),
              ),
              child: Text(
                "Email Verification",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.5, 1.0),
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(2),
                padding: const EdgeInsets.all(2),
                child: Text(
                  "Please check $email inbox and click  wakulima verification link to verify your email address.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                resendLink(context: context);
                // Add your onPressed code here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: context.watch<CurrentUserProvider>().isLoading
                  ? LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white, size: 25)
                  : Text(
                      "Resend Email",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Globals()
                    .switchScreens(context: context, screen: WakulimaLoginScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Globals()
                            .switchScreens(context: context, screen: WakulimaSignUp());
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                      )),
                  Text(
                    "back to Signup",
                    style: GoogleFonts.poppins(color: Colors.blue),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
