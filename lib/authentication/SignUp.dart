import 'package:itx/authentication/Login.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/fromWakulima/AppBloc.dart';
import 'package:itx/fromWakulima/FirebaseFunctions/FirebaseFunctions.dart';

import 'package:itx/fromWakulima/globals.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:cherry_toast/cherry_toast.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/fromWakulima/globals.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
// import 'package:or/or.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();

  bool visibility = true;
  bool confirm_visibilty = true;
  TextEditingController _SignUpPasswordController = TextEditingController();

  TextEditingController _SignemailController = TextEditingController();

  TextEditingController _confirmController = TextEditingController();
  bool isLoading = false;
  bool darkMode = false;
  ThemeMode get themeMode => darkMode ? ThemeMode.dark : ThemeMode.light;

  AuthButtonType? buttonType;
  AuthIconType? iconType;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _SignemailController.dispose();
    _SignUpPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        centerTitle: true,
        title: Text(
          "Signup",
          style: GoogleFonts.poppins(
              color: Colors.black54, fontWeight: FontWeight.w500),
        ),
        leading: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadiusDirectional.all(Radius.circular(30))),
            child: IconButton(
                onPressed: () {
                  Globals()
                      .switchScreens(context: context, screen: WakulimaLoginScreen());
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ))),
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height,
          // padding: EdgeInsets.only(left: 20),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(40),
                  bottomStart: Radius.circular(40)),
              color: Colors.grey.shade100),
          child: Form(
              key: _formState,
              child: SingleChildScrollView(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 4),
                      child: Text(
                        "Create an  Account",
                        style: GoogleFonts.abel(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "See what's going on with your business",
                        style: GoogleFonts.abel(),
                      ),
                    ),

                    // form textfields

                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      alignment: Alignment.center,
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadiusDirectional.circular(5)),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _SignemailController,
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
                      margin: EdgeInsets.only(bottom: 15, top: 15),
                      alignment: Alignment.center,
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadiusDirectional.circular(5)),
                      child: TextFormField(
                        obscureText: visibility,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _SignUpPasswordController,
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

                    Container(
                      margin: EdgeInsets.only(
                        bottom: 25,
                      ),
                      alignment: Alignment.center,
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadiusDirectional.circular(5)),
                      child: TextFormField(
                        obscureText: confirm_visibilty,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _confirmController,
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          // setState(() {
                          //   password = value;
                          // });
                        },
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          prefixIcon: Icon(CupertinoIcons.padlock_solid,
                              color: Colors.black54),
                          suffixIcon: IconButton(
                            icon: confirm_visibilty
                                ? Icon(
                                    CupertinoIcons.eye_slash_fill,
                                    color: Colors.black54,
                                  )
                                : Icon(CupertinoIcons.eye_fill,
                                    color: Colors.black54),
                            onPressed: () {
                              setState(() {
                                confirm_visibilty = !confirm_visibilty;
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
                            return "Confirm Password is Empty";
                          }
                          return null;
                        },
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        print("tapped");
                        if (_formState.currentState!.validate()) {
                          if (_SignUpPasswordController.text !=
                              _confirmController.text) {
                            CherryToast.warning(
                              disableToastAnimation: false,
                              animationCurve: Curves.ease,
                              animationDuration: Duration(milliseconds: 200),
                              title: Text('Password Error',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)),
                              action: Text(
                                'Make sure the password and confirm password match ',
                                style: GoogleFonts.abel(),
                              ),
                              actionHandler: () {},
                              onToastClosed: () {},
                            ).show(context);
                          } else {
                            signup(
                                context: context,
                                email_: _SignemailController.text.trim(),
                                password_:
                                    _SignUpPasswordController.text.trim());
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        alignment: Alignment.center,
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.75,
                        decoration: BoxDecoration(
                            color: Colors.green.shade500,
                            borderRadius: BorderRadiusDirectional.circular(10)),
                        child: TextButton(
                          onPressed: () {
                            print("tapped");
                            if (_formState.currentState!.validate()) {
                              if (_SignUpPasswordController.text !=
                                  _confirmController.text) {
                                CherryToast.warning(
                                  disableToastAnimation: false,
                                  animationCurve: Curves.ease,
                                  animationDuration:
                                      Duration(milliseconds: 200),
                                  title: Text('Password Error',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold)),
                                  action: Text(
                                    'Make sure the password and confirm password match ',
                                    style: GoogleFonts.abel(),
                                  ),
                                  actionHandler: () {},
                                  onToastClosed: () {},
                                ).show(context);
                              } else {
                                signup(
                                    context: context,
                                    email_: _SignemailController.text.trim(),
                                    password_:
                                        _SignUpPasswordController.text.trim());
                              }
                            }
                          },
                          child: context.watch<CurrentUserProvider>().isLoading
                              ? LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.white, size: 25)
                              : Text(
                                  "Sign Up",
                                  style: GoogleFonts.abel(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: GoogleAuthButton(
                          text: "Signup with Google",
                          onPressed: () {},
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
                    //  Container(
                    //   margin: EdgeInsets.only(top: 15),
                    //   child:

                    //    GoogleAuthButton(
                    //       text: "Signup with Google",
                    //       onPressed: () {},
                    //        themeMode: themeMode,
                    //       isLoading: isLoading,
                    //       style: AuthButtonStyle(
                    //         width: MediaQuery.of(context).size.width * 0.75,
                    //         textStyle: GoogleFonts.poppins(
                    //             color: Colors.black54,
                    //             fontWeight: FontWeight.w600),
                    //         buttonType: buttonType,
                    //         iconType: iconType,
                    //       )),
                    // ),

                    // end of text fields
                    // Container(
                    //   width: MediaQuery.of(context).size.width * .25,
                    //   alignment: Alignment.center,
                    //   padding: EdgeInsets.all(5),
                    //   margin: EdgeInsets.all(5),
                    //   child: Or(
                    //     fontSize: 8,
                    //     dividerThickness: 0.2,
                    //     dividerColor: Colors.black54,
                    //   ),
                    // ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
