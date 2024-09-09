import 'package:itx/authentication/Login.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/fromWakulima/FirebaseFunctions/FirebaseFunctions.dart';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:cherry_toast/cherry_toast.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/fromWakulima/widgets/contant.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/Requests.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
// import 'package:or/or.dart';

class WakulimaSignUp extends StatefulWidget {
  const WakulimaSignUp({super.key});

  @override
  State<WakulimaSignUp> createState() => _WakulimaSignUpState();
}

class _WakulimaSignUpState extends State<WakulimaSignUp> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();

  bool visibility = true;
  bool confirm_visibilty = true;
  TextEditingController _SignUpPasswordController = TextEditingController();

  TextEditingController _SignemailController = TextEditingController();

  TextEditingController _confirmController = TextEditingController();

  TextEditingController _phoneNumberController = TextEditingController();

  bool isLoading = false;
  bool darkMode = false;
  ThemeMode get themeMode => darkMode ? ThemeMode.dark : ThemeMode.light;

  AuthButtonType? buttonType;
  AuthIconType? iconType;
  String? _selectedUserType;

  Widget _radioButton({required String text, required String value}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 10),
      width: AppWidth(context, 0.8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Radio<String>(
            activeColor: Colors.green.shade700,
            value: value,
            groupValue: _selectedUserType,
            onChanged: (value) {
              setState(() {
                _selectedUserType = value;
              });
            },
          ),
        ],
      ),
    );
  }

  _handleSignup() {
    print("actions");

    try {
      if (_formState.currentState!.validate()) {
        if (_SignUpPasswordController.text != _confirmController.text) {
          CherryToast.warning(
            disableToastAnimation: false,
            animationCurve: Curves.ease,
            animationDuration: Duration(milliseconds: 200),
            title: Text('Password Error',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            action: Text(
              'Make sure the password and confirm password match ',
              style: GoogleFonts.abel(),
            ),
            actionHandler: () {},
            onToastClosed: () {},
          ).show(context);
        } else if (_selectedUserType == null) {
          CherryToast.warning(
            disableToastAnimation: false,
            animationCurve: Curves.ease,
            animationDuration: Duration(milliseconds: 200),
            title: Text('Roler Error',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            action: Text(
              'Please Selected a user Role',
              style: GoogleFonts.abel(),
            ),
            actionHandler: () {},
            onToastClosed: () {},
          ).show(context);
        } else {
          print("good");
          Requests.register(
            context: context,
              email: _SignemailController.text.trim(),
              password: _SignUpPasswordController.text.trim(),
              phoneNumber: _phoneNumberController.text.trim(),
              user_type: _selectedUserType!);
       
        }
      }
    } catch (e) {
      print("_handleSignup $e");
    }
  }

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
                  Globals.switchScreens(
                      context: context, screen: WakulimaLoginScreen());
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
          // width: MediaQuery.of(context).size.width * 1,
          // height: MediaQuery.of(context).size.height,
          // padding: EdgeInsets.only(left: 20),
          margin: EdgeInsets.all(1),
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
                        "Are you a buyer,producer or Trader?",
                        style: GoogleFonts.abel(
                            letterSpacing: 1,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        textAlign: TextAlign.center,
                        "We want to make sure you're getting the right experience .Please verify your contact information",
                        style: GoogleFonts.abel(fontSize: 16),
                      ),
                    ),

                    // form textfields

                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      alignment: Alignment.center,
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.8,
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
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadiusDirectional.circular(5)),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _phoneNumberController,
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          // setState(() {
                          //   password = value;
                          // });
                        },
                        decoration: InputDecoration(
                          labelText: "phone number",
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          prefixIcon: Icon(Icons.phone, color: Colors.black54),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          // Check if the value is null or empty
                          if (value == null || value.isEmpty) {
                            return "Phone number is required";
                          }

                          // Define a basic phone number pattern
                          final RegExp phoneNumberPattern = RegExp(
                            r'^\(?\d{3}\)?[\s\-]?\d{3}[\s\-]?\d{4}$',
                            caseSensitive: false,
                          );

                          // Check if the value matches the phone number pattern
                          if (!phoneNumberPattern.hasMatch(value)) {
                            return "Invalid phone number format";
                          }

                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      alignment: Alignment.center,
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.8,
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
                          labelText: "password",
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
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.8,
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
                    Container(
                      // alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Select your role ",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),

                    _radioButton(text: "Buyer", value: "Buyer"),

                    _radioButton(text: "Producer", value: "Producer"),

                    _radioButton(text: "Trader", value: "Trader"),

                    GestureDetector(
                      onTap: () {
                        print("Tappped");

                        _handleSignup();
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        alignment: Alignment.center,
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.green.shade500,
                            borderRadius: BorderRadiusDirectional.circular(10)),
                        child: context.watch<appBloc>().isLoading
                            ? LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white, size: 25)
                            : Text("Continue",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
