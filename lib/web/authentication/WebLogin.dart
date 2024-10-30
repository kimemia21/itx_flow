import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/requests/Requests.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/web/authentication/WebSignUp.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class Weblogin extends StatefulWidget {
  const Weblogin({super.key});

  @override
  State<Weblogin> createState() => _WebloginState();
}

class _WebloginState extends State<Weblogin> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  bool visibility = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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
      height: 65,
      child: TextFormField(
        scrollPadding: EdgeInsets.all(4),
        controller: controller,
        obscureText: obscureText,
        cursorColor: Colors.green.shade400,
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(icon, color: Colors.green.shade400, size: 22),
          ),
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade200,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green.shade400,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red.shade300,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red.shade300,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;
          bool isMobile = screenWidth < 900;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(
                    "https://live.staticflickr.com/4073/4749322886_e81a8ba878_b.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.0),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                constraints: BoxConstraints(maxWidth: 1200),
                child: Card(
                  elevation: 20,
                  shadowColor: Colors.black.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      height:
                          isMobile ? screenHeight * 0.8 : screenHeight * 0.85,
                      child: Flex(
                        direction: isMobile ? Axis.vertical : Axis.horizontal,
                        children: [
                          if (!isMobile)
                            Expanded(
                              flex: 6,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://live.staticflickr.com/65535/49859907217_53e2e5b861_b.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            flex: isMobile ? 1 : 4,
                            child: Container(
                              padding: EdgeInsets.all(isMobile ? 20 : 40),
                              color: Colors.white,
                              child: Form(
                                key: _formState,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Welcome Back",
                                      style: GoogleFonts.poppins(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Login to your ITX account",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    _buildTextField(
                                      controller: _emailController,
                                      label: "Email Address",
                                      icon: CupertinoIcons.mail,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Email is required";
                                        }
                                        if (!RegExp(
                                                r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                            .hasMatch(value)) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    _buildTextField(
                                      controller: _passwordController,
                                      label: "Password",
                                      icon: CupertinoIcons.lock,
                                      obscureText: visibility,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          visibility
                                              ? CupertinoIcons.eye_slash
                                              : CupertinoIcons.eye,
                                          color: Colors.grey.shade600,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            visibility = !visibility;
                                          });
                                        },
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Password is required";
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          // Add forgot password logic
                                        },
                                        child: Text(
                                          "Forgot Password?",
                                          style: GoogleFonts.poppins(
                                            color: Colors.green.shade400,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    MaterialButton(
                                      onPressed: () {
                                        if (_formState.currentState!
                                            .validate()) {
                                          AuthRequest.login(
                                            isWeb: true,
                                            context: context,
                                            email: _emailController.text.trim(),
                                            password:
                                                _passwordController.text.trim(),
                                          );
                                        }
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      color: Colors.green.shade400,
                                      elevation: 0,
                                      highlightElevation: 0,
                                      minWidth: double.infinity,
                                      height: 55,
                                      child: context.watch<appBloc>().isLoading
                                          ? LoadingAnimationWidget
                                              .staggeredDotsWave(
                                              color: Colors.white,
                                              size: 20,
                                            )
                                          : Text(
                                              "Sign In",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Don't have an account?",
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Websignup(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Sign Up",
                                            style: GoogleFonts.poppins(
                                              color: Colors.green.shade400,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
            ),
          );
        },
      ),
    );
  }
}
