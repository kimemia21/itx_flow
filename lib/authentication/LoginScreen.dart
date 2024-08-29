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
import 'package:itx/fromWakulima/AppBloc.dart';
import 'package:itx/fromWakulima/FirebaseFunctions/FirebaseFunctions.dart';
import 'package:itx/fromWakulima/globals.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// import 'package:or/or.dart';
import 'package:transparent_image/transparent_image.dart';

class WakulimaLoginScreen extends StatefulWidget {
  const WakulimaLoginScreen({super.key});

  @override
  State<WakulimaLoginScreen> createState() => _WakulimaLoginScreenState();
}

class _WakulimaLoginScreenState extends State<WakulimaLoginScreen> {
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
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            margin: EdgeInsets.only(left: 10),
            width: 2,
            height: 2,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadiusDirectional.all(Radius.circular(20))),
            child: IconButton(
                onPressed: () {
                  Globals
                      .switchScreens(context: context, screen: Splashscreen());
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ))),
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height,
        // padding: EdgeInsets.only(left: 20),
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadiusDirectional.all(Radius.circular(40)

              // topStart: Radius.circular(40),
              // bottomStart: Radius.circular(40)
              ),
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
                    margin: EdgeInsets.only(bottom: 4),
                    child: Text(
                      "Login to your Account",
                      style: GoogleFonts.abel(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Welcome to our App, Please login to continue",
                      style: GoogleFonts.abel(),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    alignment: Alignment.center,
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.circular(5)),
                    child: TextFormField(
                      // keyboardType: TextInputType.name,
                      controller: _emailController,
                      cursorColor: Colors.black,
                      onChanged: (value) {
                        // setState(() {
                        //   email = value;
                        // });
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 12,
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
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.circular(5)),
                    child: TextFormField(
                      obscureText: visibility,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      cursorColor: Colors.black,
                      onChanged: (value) {
                        // setState(() {
                        //   password = value;
                        // });
                      },
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        prefixIcon: Icon(CupertinoIcons.padlock_solid,
                            color: Colors.black54),
                        suffixIcon: IconButton(
                          icon: visibility
                              ? Icon(
                                  CupertinoIcons.eye_slash_fill,
                                  color: Colors.black54,
                                )
                              : Icon(CupertinoIcons.eye_fill,
                                  color: Colors.black54),
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

                  // Container(
                  //   width: MediaQuery.of(context).size.width * 0.75,
                  //   margin: EdgeInsets.only(
                  //     bottom: 5,
                  //   ),
                  //   alignment: Alignment.bottomRight,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>

                  //                   ForgotPassWord()));
                  //     },
                  //     child: Text("Forgot Password ?"),
                  //   ),
                  // ),
                  SizedBox(height: 20,),

                  GestureDetector(
                    onTap: () {
                      if (_formState.currentState!.validate()) {
                        print(
                            "email is ${_emailController.text.trim()} ${_passwordController.text.trim()}");
                  
                        signInWithEmailAndPassword(
                            context: context,
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim());
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        alignment: Alignment.center,
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.75,
                        decoration: BoxDecoration(
                            color: Colors.green.shade500,
                            borderRadius:
                                BorderRadiusDirectional.circular(10)),
                        child: TextButton(
                          onPressed: () async {
                            if (_formState.currentState!.validate()) {
                              bool connection =
                                  await checkInternetConnection(context);
                              if (connection) {
                                signInWithEmailAndPassword(
                                    context: context,
                                    email: _emailController.text.trim(),
                                    password:
                                        _passwordController.text.trim());
                              } else {
                                Globals().nointernet(context: context);
                              }
                            }
                          },
                          child:
                              context.watch<CurrentUserProvider>().isLoading
                                  ? LoadingAnimationWidget.staggeredDotsWave(
                                      color: Colors.white, size: 25)
                                  : Text(
                                      "Login",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                        )),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: GoogleAuthButton(
                        onPressed: () async {
                          bool connection =
                              await checkInternetConnection(context);
                          if (connection) {
                            Authentication.signInWithGoogle(context: context);
                          } else {
                            Globals().nointernet(context: context);
                          }
                        },
                        themeMode: themeMode,
                        isLoading: isLoading,
                        style: AuthButtonStyle(
                          width: MediaQuery.of(context).size.width * 0.75,
                          textStyle: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600),
                          buttonType: buttonType,
                          iconType: iconType,
                        )),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 5),
                      // alignment: Alignment.center,
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(10)),
                      child: TextButton(
                        onPressed: () async {
                          Globals.switchScreens(
                              context: context, screen: WakulimaSignUp());
                        },
                        child: Text(
                          "Sign up",
                          style: GoogleFonts.abel(
                              color: Colors.blue.shade300,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  // end of text fields
                ],
              ),
            )),
      ),
    );
  }
}
