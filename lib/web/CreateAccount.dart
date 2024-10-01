import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/web/CustomTextFields.dart';
import 'package:itx/web/SetupScreen.dart';
import 'package:itx/web/SignInWeb.dart';

class MainSignupWeb extends StatefulWidget {
  @override
  _MainSignupWebState createState() => _MainSignupWebState();
}

class _MainSignupWebState extends State<MainSignupWeb> {
  final _formKey = GlobalKey<FormState>();

  bool _isBuyer = false;
  bool _isProducer = false;
  bool _isTrader = false;
  bool confirmSecure = false;
  bool passwordSecure = false;

  String? _email;
  String? _phoneNumber;
  String? _password;
  String? _confirmPassword;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'ITX',
          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.grey, thickness: 0.5),
          Container(
            margin: EdgeInsets.only(top: 60, left: 200),
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create your account', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600)),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    width: MediaQuery.of(context).size.width * 0.4, // Email field width
                    labelText: 'Email',
                    hintText: 'you@example.com',
                    onSaved: (value) => _email = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your email';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Please enter a valid email';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    width: MediaQuery.of(context).size.width * 0.4, // Phone number field width
                    labelText: 'Phone number',
                    hintText: '123-456-7890',
                    onSaved: (value) => _phoneNumber = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your phone number';
                      if (!RegExp(r'^\d{10}$').hasMatch(value)) return 'Please enter a valid 10-digit phone number';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: constraints.maxWidth > 600 // Adjust according to your layout preferences
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      width: MediaQuery.of(context).size.width * 0.18, // Password field width
                                      labelText: 'Password',
                                      hintText: 'Enter password',
                                      isPassword: true,
                                      controller: _passwordController,
                                      obscureText: passwordSecure,
                                      toggleVisibility: () {
                                        setState(() {
                                          passwordSecure = !passwordSecure;
                                        });
                                      },
                                      onSaved: (value) => _password = value,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) return 'Please enter a password';
                                        if (value.length < 6) return 'Password must be at least 6 characters long';
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 15), // Add space between fields
                                  Expanded(
                                    child: CustomTextFormField(
                                      width: MediaQuery.of(context).size.width * 0.18, // Confirm password field width
                                      labelText: 'Confirm password',
                                      hintText: 'Confirm password',
                                      isPassword: true,
                                      controller: _confirmPasswordController,
                                      obscureText: confirmSecure,
                                      toggleVisibility: () {
                                        setState(() {
                                          confirmSecure = !confirmSecure;
                                        });
                                      },
                                      onSaved: (value) => _confirmPassword = value,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) return 'Please confirm your password';
                                        if (value != _passwordController.text) return 'Passwords do not match';
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  CustomTextFormField(
                                    width: MediaQuery.of(context).size.width * 0.4, // Password field width on small screens
                                    labelText: 'Password',
                                    hintText: 'Enter password',
                                    isPassword: true,
                                    controller: _passwordController,
                                    obscureText: passwordSecure,
                                    toggleVisibility: () {
                                      setState(() {
                                        passwordSecure = !passwordSecure;
                                      });
                                    },
                                    onSaved: (value) => _password = value,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Please enter a password';
                                      if (value.length < 6) return 'Password must be at least 6 characters long';
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 15), // Space between fields
                                  CustomTextFormField(
                                    width: MediaQuery.of(context).size.width * 0.4, // Confirm password field width on small screens
                                    labelText: 'Confirm password',
                                    hintText: 'Confirm password',
                                    isPassword: true,
                                    controller: _confirmPasswordController,
                                    obscureText: confirmSecure,
                                    toggleVisibility: () {
                                      setState(() {
                                        confirmSecure = !confirmSecure;
                                      });
                                    },
                                    onSaved: (value) => _confirmPassword = value,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Please confirm your password';
                                      if (value != _passwordController.text) return 'Passwords do not match';
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Add Checkbox Rows and Continue Button...
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
