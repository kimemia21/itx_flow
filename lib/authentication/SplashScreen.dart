// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/authentication/SignUp.dart';
import 'package:itx/global/globals.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> with SingleTickerProviderStateMixin {
  late AnimationController splashAnimation;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  bool isLoading = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    super.initState();
    splashAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: splashAnimation, curve: Curves.easeInOut),
    );
    
    slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: splashAnimation, curve: Curves.easeOutCubic));
    
    splashAnimation.forward();
  }

  @override
  void dispose() {
    splashAnimation.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and Title
                    Container(
                      margin: EdgeInsets.only(bottom: 24),
                      child: Text(
                        "EACX",
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    
                    // Welcome Text
                    Container(
                      margin: EdgeInsets.only(bottom: 32),
                      child: Text(
                        "Welcome! Please Log In",
                        style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                    // Animation Container
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.shade500.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Lottie.asset(
                          "assets/gif/AnimationLogin.json",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // "Continue With" text with decorative lines
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.black26)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Continue With",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.black26)),
                      ],
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Email Button
                    GestureDetector(
                      onTap: () => Globals.switchScreens(
                        context: context,
                        screen: MainLoginScreen(),
                      ),
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green.shade500, Colors.green.shade600],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.shade500.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Email",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Sign Up Link
                    GestureDetector(
                      onTap: () async {
                        try {
                            Globals.switchScreens(
                              context: context,
                              screen: MainSignup(),
                            );
                          // bool connection = await checkInternetConnection(context);
                          // if (connection) {
                          //   Globals.switchScreens(
                          //     context: context,
                          //     screen: MainSignup(),
                          //   );
                          // } else {
                          //   Globals().nointernet(context: context);
                          // }
                        } catch (e) {
                          print("Got this error in splashScreen $e");
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.green.shade500),
                        ),
                        child: Text(
                          "Sign up",
                          style: GoogleFonts.poppins(
                            color: Colors.blue.shade400,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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