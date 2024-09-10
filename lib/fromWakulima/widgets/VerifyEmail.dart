import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/authentication/SignUp.dart';
import 'package:itx/fromWakulima/FirebaseFunctions/FirebaseFunctions.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:itx/global/globals.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class VerifyEmail extends StatefulWidget {
  final String email;

  const VerifyEmail({super.key, required this.email});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState(email: email);
}

class _VerifyEmailState extends State<VerifyEmail>
    with SingleTickerProviderStateMixin {
  final String email;
  late AnimationController _animationController;
  late Timer timer;

  _VerifyEmailState({required this.email});

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      Globals.auth.currentUser?.reload();
      if (Globals.auth.currentUser?.emailVerified == true) {
        print("----------------------authenticated-----------------------");
        // Globals().checkDocVerified(context: context);
        Globals.switchScreens(context: context, screen: GlobalsHomePage());
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.elasticOut,
                ),
                child: Lottie.asset(
                  "assets/gif/AnimationOne.json",
                  height: 150,
                  width: 150,
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeIn,
                ),
                child: Text(
                  "Email Verification",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.5, 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Please check your inbox at $email and click the verification link to verify your email address.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => resendLink(context: context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => Globals.switchScreens(
                    context: context, screen: MainLoginScreen()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => Globals.switchScreens(
                          context: context, screen: MainSignup()),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "Back to Signup",
                      style: GoogleFonts.poppins(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
