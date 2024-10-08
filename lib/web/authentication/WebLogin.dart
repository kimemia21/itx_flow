import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/web/authentication/WebSignUp.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class Weblogin extends StatefulWidget {
  const Weblogin({super.key});

  @override
  State<Weblogin> createState() => _WebloginState();
}

class _WebloginState extends State<Weblogin> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  bool visibility = true;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool obscureText = false,
  Widget? suffixIcon,
  String? Function(String?)? validator,
}) {
  return Container(
    height: 60,
    child: TextFormField(
      scrollPadding: EdgeInsets.all(4),
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: Colors.black87, // Darker color for better contrast
          fontSize: 16,
          fontWeight: FontWeight.w500, // Slightly bolder text
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.all(10),
          child: Icon(icon, color: Colors.green.shade500),
        ),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.2), // Soft grey border
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12), // Same as container's border radius
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green.shade500, // Green border when focused
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent.shade200, // Red border on error
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent.shade200,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        fillColor: Colors.white,
        filled: true, // Add background color to TextField
      ),
      validator: validator,
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    _emailController.text = "meshak1@gmail.com";
    _passwordController.text = "1234567";

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use MediaQuery for better responsiveness
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;
          bool isMobile = screenWidth < 600;
          print("mobile-------------$isMobile----------------------------");

          return Center(
            child: Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image Section
                  Container(
                    width: isMobile ? screenWidth * 0.8 : screenWidth * 0.6,
                    height: isMobile ? screenHeight * 0.3 : screenHeight * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        "https://as2.ftcdn.net/v2/jpg/03/78/35/67/1000_F_378356757_pdA4QVYMUnBFNSqhiMbf1VA5QipG1Nkh.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(width: isMobile ? 0 : 20, height: isMobile ? 20 : 0),

                  // Form Section
                  Container(
                    width: isMobile ? screenWidth * 0.8 : screenWidth * 0.35,
                    height: isMobile ? screenHeight * 0.5 : screenHeight * 0.8,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.09),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formState,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "ITX",
                                style: GoogleFonts.abel(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  foreground: Paint()
                                    ..shader = LinearGradient(
                                      colors: <Color>[
                                        Colors.black,
                                        Colors.black87
                                      ],
                                    ).createShader(
                                        Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                                  shadows: [
                                    Shadow(
                                      offset: Offset(3.0, 3.0),
                                      blurRadius: 8.0,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ],
                                  letterSpacing: 4.0,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Login to your Account",
                                style: GoogleFonts.abel(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Email TextFormField
                          _buildTextField(
                            controller: _emailController,
                            label: "Email",
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
                          SizedBox(height: 20),

                          // Password TextFormField
                          _buildTextField(
                            controller: _passwordController,
                            label: "Password",
                            icon: CupertinoIcons.padlock_solid,
                            obscureText: visibility,
                            suffixIcon: IconButton(
                              icon: visibility
                                  ? Icon(CupertinoIcons.eye_slash_fill,
                                      color: Colors.black54)
                                  : Icon(CupertinoIcons.eye_fill,
                                      color: Colors.black54),
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

                          // Login Button
                          GestureDetector(
                            onTap: () {
                              if (_formState.currentState!.validate()) {
                                // Add your login logic here
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.green.shade500,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Login",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          // Sign up TextButton
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Websignup()));

                              // Navigate to SignUp screen
                            },
                            child: Text(
                              "Sign up",
                              style: GoogleFonts.abel(
                                color: Colors.blue.shade300,
                                fontWeight: FontWeight.bold,
                              ),
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
        },
      ),
    );
  }
}
