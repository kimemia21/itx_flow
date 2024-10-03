import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Serializers/UserTypes.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/Requests.dart';
import 'package:itx/authentication/CustomTextFields.dart';
import 'package:itx/web/authentication/OtpVerification.dart';
import 'package:itx/web/authentication/SignInWeb.dart';
import 'package:itx/web/requests/AuthRequest.dart';
import 'package:itx/web/state/Webbloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart'; // Ensure you import the UserTypeModel

class MainSignupWeb extends StatefulWidget {
  @override
  _MainSignupWebState createState() => _MainSignupWebState();
}

class _MainSignupWebState extends State<MainSignupWeb>
    with SingleTickerProviderStateMixin {
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
   String? _errorMessage;

  String? _selectedUserType;
  List<UserTypeModel> _userTypes = [];
  List roleType = [];
  bool _isLoading = true;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserTypes(); // Fetch user types when the widget initializes
  }

   Future<void> _fetchUserTypes() async {
    try {
      final userTypes = await AuthRequest.getUserType(context);
      setState(() {
        _userTypes = userTypes;
        _isLoading = false;

        roleType.clear();
        for (var userType in _userTypes) {
          print(userType);
          roleType.add(userType.name);
        }
        print("--------------- $roleType ---------------");
      });
    } catch (e) {
      print('Error fetching user types: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to fetch user types. Please try again later.';
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildRadioButton({required String text, required String value}) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust font size and padding based on screen width
    double fontSize = screenWidth > 800 ? 14 : 12; // Smaller font size
    double paddingHorizontal =
        screenWidth > 800 ? 15 : 10; // Less horizontal padding
    double containerWidth = screenWidth > 800
        ? screenWidth * 0.4
        : screenWidth * 0.7; // Smaller width for responsiveness

    return Container(
      width: containerWidth, // Container width is now smaller
      margin: EdgeInsets.only(bottom: 10), // Reduced bottom margin
      decoration: BoxDecoration(
        color: _selectedUserType == value ? Colors.green.shade50 : Colors.white,
        borderRadius:
            BorderRadius.circular(12), // Slightly smaller corner radius
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2, // Reduced blur radius
            offset: Offset(0, 1), // Reduced shadow offset
          ),
        ],
      ),
      child: RadioListTile<String>(
        title: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: fontSize, // Reduced font size
            fontWeight: FontWeight.w500,
            color: _selectedUserType == value
                ? Colors.green.shade700
                : Colors.black87,
          ),
        ),
        value: value,
        groupValue: _selectedUserType,
        onChanged: (String? value) => setState(() => _selectedUserType = value),
        activeColor: Colors.green.shade700,
        contentPadding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal, vertical: 5), // Reduced padding
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)), // Smaller corner radius
        tileColor: _selectedUserType == value ? Colors.green.shade50 : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _emailController.text = "bobbymbogo711@gmail.com";
    _phoneController.text = "0769922984";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'ITX',
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(10),
                color: Colors.green),
            child: TextButton(
              onPressed: () =>
                  Globals.switchScreens(context: context, screen: SignInWeb()),
              child: Text("SignIn",
                  style: GoogleFonts.poppins(color: Colors.white)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
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
                    Text('Create your account',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.w600)),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _emailController,
                      width: MediaQuery.of(context).size.width * 0.4,
                      labelText: 'Email',
                      hintText: 'you@example.com',
                      onSaved: (value) => _email = value,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter your email';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                          return 'Please enter a valid email';
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _phoneController,
                      width: MediaQuery.of(context).size.width * 0.4,
                      labelText: 'Phone number',
                      hintText: '123-456-7890',
                      onSaved: (value) => _phoneNumber = value,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter your phone number';
                        if (!RegExp(r'^\d{10}$').hasMatch(value))
                          return 'Please enter a valid 10-digit phone number';
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: constraints.maxWidth > 600
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomTextFormField(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.18,
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
                                          if (value == null || value.isEmpty)
                                            return 'Please enter a password';
                                          if (value.length < 6)
                                            return 'Password must be at least 6 characters long';
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: CustomTextFormField(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.18,
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
                                        onSaved: (value) =>
                                            _confirmPassword = value,
                                        validator: (value) {
                                          if (value == null || value.isEmpty)
                                            return 'Please confirm your password';
                                          if (value != _passwordController.text)
                                            return 'Passwords do not match';
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    CustomTextFormField(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
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
                                        if (value == null || value.isEmpty)
                                          return 'Please enter a password';
                                        if (value.length < 6)
                                          return 'Password must be at least 6 characters long';
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 15),
                                    CustomTextFormField(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
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
                                      onSaved: (value) =>
                                          _confirmPassword = value,
                                      validator: (value) {
                                        if (value == null || value.isEmpty)
                                          return 'Please confirm your password';
                                        if (value != _passwordController.text)
                                          return 'Passwords do not match';
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                        );
                      },
                    ),
                 
                    SizedBox(height: 20),
                    Text('Select your role',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600)),
                    SizedBox(height: 10),
                    if (_isLoading)
                      Center(child: CircularProgressIndicator())
                    else if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      )
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 600) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: _userTypes.map((usertype) {
                                return Expanded(
                                  child: _buildRadioButton(
                                      text: usertype.name,
                                      value: usertype.id.toString()),
                                );
                              }).toList(),
                            );
                          } else {
                            return Column(
                              children: _userTypes
                                  .map((usertype) => _buildRadioButton(
                                      text: usertype.name,
                                      value: usertype.id.toString()))
                                  .toList(),
                            );
                          }
                        },
                      ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.4, // Adjust width to 50% of screen width
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15), // You can also adjust the padding
                        ),
                        child: context.watch<Webbloc>().isLoading
                            ? LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white,
                                size: 25,
                              )
                            : Text('Sign Up',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Handle form submission
      print('Email: $_email');
      print('Phone Number: $_phoneNumber');
      print('Password: $_password');
      print('Selected User Type:  $_selectedUserType');

      final Map<String, dynamic> body = {
        "api":2,
        "email": _email,
        "phonenumber": _phoneNumber,
        "user_type": int.parse(_selectedUserType!),
        "password": _password,
      };






      WebAuthrequest.register(context: context, body: body, isOnOtp: false);
      // Globals.switchScreens(context: context, screen: WebOtpVerification(phoneNumber: _phoneNumber!,));
    }
  }
}
