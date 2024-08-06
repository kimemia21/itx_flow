// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/Verification.dart';
import 'package:itx/global/globals.dart';

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
    if (_formKey.currentState?.validate() ?? false) {
      // Process the form data
      final username = _emailController.text;
      final email = _phoneController.text;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Username: $username\nEmail: $email\nUser Type: $_selectedUserType'),
        ),
      );
      Globals.switchScreens(context: context, screen: Verification());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    alignment: Alignment.center,
                    child: Text(
                      "Select your Role",
                      style: GoogleFonts.poppins(
                          fontSize: 22, fontWeight: FontWeight.w700),
                    )),
                Container(
                    margin: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    child: Text(
                      "Are You a buyer,producer or trader?",
                      style: GoogleFonts.poppins(
                          fontSize: 22, fontWeight: FontWeight.w700),
                    )),
                Container(
                    margin: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    child: Text(
                      textAlign: TextAlign.center,
                      "We want to make sure you are getting the right experience.\n Please verify your contact information.",
                      style: GoogleFonts.poppins(fontSize: 18),
                    )),
                SizedBox(height: 25.0),
                Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Email",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    )),
                SizedBox(height: 5.0),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      color: const Color.fromARGB(255, 255, 235, 201)),
                  child: TextFormField(
                    controller: _emailController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: InputBorder.none,

                      // label: Text("Email"),
                      hintText: "Enter your email",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Phone number",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    )),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      color: const Color.fromARGB(255, 255, 235, 201)),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    controller: _phoneController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter your phone number",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your phone number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                // Text('User Type'),
                SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      border: Border.all(
                          width: 1, color: Color.fromARGB(255, 99, 87, 65))),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Buyer",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
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
                SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      border: Border.all(
                          width: 1, color: Color.fromARGB(255, 99, 87, 65))),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Producer",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600),
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
                SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      border: Border.all(
                          width: 1, color: Color.fromARGB(255, 99, 87, 65))),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Trader",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600),
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

                Container(
                    margin: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: Text(
                      "Continue as guest",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    )),

                GestureDetector(
                  onTap: _submitForm,
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadiusDirectional.circular(10)),
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
