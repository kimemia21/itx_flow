// ignore_for_file: prefer_const_constructors

// import 'package:widgets/CurrentUserProvider.dart';
// import 'package:widgets/authentication/ForgotPassword.dart';
// import 'package:widgets/authentication/Signup.dart';
// import 'package:widgets/firebase_functions/firebase_fun.dart';

import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/SignUp.dart';
import 'package:itx/authentication/SplashScreen.dart';
import 'package:itx/fromWakulima/FirebaseFunctions/FirebaseFunctions.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/Requests.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// import 'package:or/or.dart';
import 'package:transparent_image/transparent_image.dart';

class MainLoginScreen extends StatefulWidget {
  const MainLoginScreen({super.key});

  @override
  State<MainLoginScreen> createState() => _MainLoginScreenState();
}

class _MainLoginScreenState extends State<MainLoginScreen> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  late StreamSubscription<List<ConnectivityResult>> subscription;
  bool isLoading = false;
  bool isConnected = false;
  bool darkMode = false;
  ThemeMode get themeMode => darkMode ? ThemeMode.dark : ThemeMode.light;

  AuthButtonType? buttonType;
  AuthIconType? iconType;

  bool visibility = true;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  final Connectivity _connectivity = Connectivity();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _emailController.text = "meshak1@gmail.com";
    _passwordController.text = "1234567";
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        centerTitle: true,
        title: Text(
          "Login",
          style: GoogleFonts.poppins(
              color: Colors.black54, fontWeight: FontWeight.w500),
        ),
        leading: Container(
          margin: EdgeInsets.only(left: screenWidth * 0.02),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            onPressed: () {

              Globals.switchScreens(context: context, screen: Splashscreen());
              
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          width: screenWidth,
          height: screenHeight,
          margin: EdgeInsets.only(top: screenHeight * 0.05),
          padding: EdgeInsets.only(top: screenHeight * 0.03),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Form(
            key: _formState,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                    child: Text(
                      "Login to your Account",
                      style: GoogleFonts.abel(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                    child: Text(
                      "Welcome to our App, Please login to continue",
                      style: GoogleFonts.abel(
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                    alignment: Alignment.center,
                    height: screenHeight * 0.08,
                    width: screenWidth * 0.75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: Colors.black,
                        ),
                        prefixIcon: Icon(
                          CupertinoIcons.mail_solid,
                          color: Colors.black54,
                        ),
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is empty";
                        }
                        if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.02),
                    alignment: Alignment.center,
                    height: screenHeight * 0.08,
                    width: screenWidth * 0.75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      obscureText: visibility,
                      controller: _passwordController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: Colors.black,
                        ),
                        prefixIcon: Icon(
                          CupertinoIcons.padlock_solid,
                          color: Colors.black54,
                        ),
                        suffixIcon: IconButton(
                          icon: visibility
                              ? Icon(
                                  CupertinoIcons.eye_slash_fill,
                                  color: Colors.black54,
                                )
                              : Icon(
                                  CupertinoIcons.eye_fill,
                                  color: Colors.black54,
                                ),
                          onPressed: () {
                            setState(() {
                              visibility = !visibility;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is Empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  GestureDetector(
                    onTap: () {
                      if (_formState.currentState!.validate()) {
                        AuthRequest.login(
                            context: context,
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim());
                        // signInWithEmailAndPassword(
                        //   context: context,
                        //   email: _emailController.text.trim(),
                        //   password: _passwordController.text.trim(),
                        // );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.green.shade500,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: context.watch<appBloc>().isLoading
                          ? LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white, size: screenWidth * 0.06)
                          : Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.02),
                    child: GoogleAuthButton(
                      onPressed: () async {
                        // bool connection = await checkInternetConnection(context);
                        // if (connection) {
                        //   Authentication.signInWithGoogle(context: context);
                        // } else {
                        //   Globals().nointernet(context: context);
                        // }
                      },
                      themeMode: themeMode,
                      isLoading: isLoading,
                      style: AuthButtonStyle(
                        width: screenWidth * 0.75,
                        textStyle: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.045,
                        ),
                        buttonType: buttonType,
                        iconType: iconType,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.02),
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Globals.switchScreens(
                              context: context, screen: MainSignup());
                        },
                        child: Text(
                          "Sign up",
                          style: GoogleFonts.abel(
                            color: Colors.blue.shade300,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
