// ignore_for_file: prefer_const_constructors

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/Verification.dart';
import 'package:itx/global/globals.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedUserType;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Check if _selectedUserType is null
    if (_selectedUserType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please select a user type'),
        ),
      );
      return; // Exit the method if the user type is not selected
    }

    // Check if the form is valid
    if (_formKey.currentState?.validate() ?? false) {
      // Process the form data
      final username = _emailController.text;
      final email = _phoneController.text;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Username: $username\nEmail: $email\nUser Type: $_selectedUserType',
          ),
        ),
      );

      // Navigate to the Verification screen
      // Globals.switchScreens(context: context, screen: Verification(context: context));
      PersistentNavBarNavigator.pushNewScreen(context,
          screen: Verification(context: context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    child: Text(
                      "Select your Role",
                      style: GoogleFonts.poppins(
                          fontSize: 24, fontWeight: FontWeight.w700),
                    )),
                Container(
                    margin: EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    child: Text(
                      "Are You a Buyer, Producer, or Trader?",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    )),
                Container(
                    margin: EdgeInsets.only(bottom: 25),
                    alignment: Alignment.center,
                    child: Text(
                      textAlign: TextAlign.center,
                      "We want to make sure you are getting the right experience.\n Please verify your contact information.",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.grey.shade600),
                    )),
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Email",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200),
                  child: TextFormField(
                    controller: _emailController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter your email",
                      hintStyle:
                          GoogleFonts.poppins(color: Colors.grey.shade600),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your email';
                      } else if (EmailValidator.validate(value.trim()) !=
                          true) {
                        return 'Enter  a Valid email';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Phone number",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    controller: _phoneController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter your phone number",
                      hintStyle:
                          GoogleFonts.poppins(color: Colors.grey.shade600),
                    ),
                    validator: (value) {
                      // final phoneRegExp = RegExp(r'^\+?[1-9]\d{1,14}$');
                      final phoneRegExp =
                          RegExp(r'^(\+?[1-9]\d{1,14}|0\d{1,14})$');

                      if (value == null || value.isEmpty) {
                        return 'Enter your phone number';
                      }

                      if (!phoneRegExp.hasMatch(value)) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1, color: Color.fromARGB(255, 99, 87, 65)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Buyer",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Radio<String>(
                        activeColor: Colors.green.shade700,
                        value: 'Buyer',
                        groupValue: _selectedUserType,
                        onChanged: (value) {
                          setState(() {
                            _selectedUserType = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1, color: Color.fromARGB(255, 99, 87, 65)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Producer",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Radio<String>(
                        activeColor: Colors.green.shade700,
                        value: 'Producer',
                        groupValue: _selectedUserType,
                        onChanged: (value) {
                          setState(() {
                            _selectedUserType = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1, color: Color.fromARGB(255, 99, 87, 65)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Trader",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Radio<String>(
                        activeColor: Colors.green.shade700,
                        value: 'Trader',
                        groupValue: _selectedUserType,
                        onChanged: (value) {
                          setState(() {
                            _selectedUserType = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    // Implement guest login action
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    child: Text(
                      "Continue as guest",
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700),
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                GestureDetector(
                  onTap: _submitForm,
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Continue",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
