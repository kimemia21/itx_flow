import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/SignUp.dart';
import 'package:itx/authentication/SplashScreen.dart';
import 'package:itx/fromWakulima/FirebaseFunctions/FirebaseFunctions.dart';
import 'package:itx/fromWakulima/globals.dart';
import 'package:itx/web/CreateAccount.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../fromWakulima/AppBloc.dart';

class SigninWeb extends StatefulWidget {
  const SigninWeb({super.key});

  @override
  State<SigninWeb> createState() => _SigninWebState();
}

class _SigninWebState extends State<SigninWeb> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  late StreamSubscription<List<ConnectivityResult>> subscription;
  bool isLoading = false;
  bool visibility = true;
  bool isConnected = false;
  bool darkMode = false;
  ThemeMode get themeMode => darkMode ? ThemeMode.dark : ThemeMode.light;

  AuthButtonType? buttonType;
  AuthIconType? iconType;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
    double screenWidth = MediaQuery.of(context).size.width;
    double formWidth = screenWidth > 600 ? 600 : screenWidth * 0.75;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.grey.shade100,
        centerTitle: true,
        title: Text(
          "Login",
          style: GoogleFonts.poppins(
              color: Colors.black54, fontWeight: FontWeight.w500),
        ),
        // leading: Container(
        //   margin: EdgeInsets.only(left: 10),
        //   width: 2,
        //   height: 2,
        //   decoration: BoxDecoration(
        //     color: Colors.grey.shade300,
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   child: IconButton(
        //     onPressed: () {
        //       Globals.switchScreens(context: context, screen: Splashscreen());
        //     },
        //     icon: Icon(
        //       Icons.arrow_back,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: formWidth,
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Form(
              key: _formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Login to your Account",
                    style: GoogleFonts.abel(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome to our App, Please login to continue",
                    style: GoogleFonts.abel(),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    labelText: "Email",
                    icon: CupertinoIcons.mail_solid,
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
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: _passwordController,
                    labelText: "Password",
                    icon: CupertinoIcons.padlock_solid,
                    obscureText: visibility,
                    suffixIcon: IconButton(
                      icon: Icon(
                        visibility
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_fill,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          visibility = !visibility;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _buildLoginButton(context),
                  SizedBox(height: 15),
                  // _buildGoogleButton(context),
                  SizedBox(height: 15),
                  _buildSignUpButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.black,
          ),
          prefixIcon: Icon(icon, color: Colors.black54),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_formState.currentState!.validate()) {
          signInWithEmailAndPassword(
            context: context,
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.green.shade500,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: () async {
            if (_formState.currentState!.validate()) {
              bool connection = await checkInternetConnection(context);
              if (connection) {
                signInWithEmailAndPassword(
                  context: context,
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );
              } else {
                Globals().nointernet(context: context);
              }
            }
          },
          child: context.watch<CurrentUserProvider>().isLoading
              ? LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white, size: 25)
              : Text(
                  "Login",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  // Widget _buildGoogleButton(BuildContext context) {
  //   return GoogleAuthButton(
  //     onPressed: () async {
  //       bool connection = await checkInternetConnection(context);
  //       if (connection) {
  //         Authentication.signInWithGoogle(context: context);
  //       } else {
  //         Globals().nointernet(context: context);
  //       }
  //     },
  //     themeMode: themeMode,
  //     isLoading: isLoading,
  //     style: AuthButtonStyle(
  //       width: MediaQuery.of(context).size.width > 600
  //           ? 600 * 0.75
  //           : MediaQuery.of(context).size.width * 0.75,
  //       textStyle: GoogleFonts.poppins(
  //         color: Colors.black54,
  //         fontWeight: FontWeight.w600,
  //       ),
  //       buttonType: buttonType,
  //       iconType: iconType,
  //     ),
  //   );
  // }

  Widget _buildSignUpButton(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width > 600
          ? 600 * 0.25
          : MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          Globals.switchScreens(context: context, screen: CreateAccountScreen());
        },
        child: Text(
          "Sign up",
          style: GoogleFonts.abel(
            color: Colors.blue.shade300,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
