import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/SignUp.dart';
import 'package:itx/authentication/SplashScreen.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/Requests.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class MainLoginScreen extends StatefulWidget {
  const MainLoginScreen({super.key});

  @override
  State<MainLoginScreen> createState() => _MainLoginScreenState();
}

class _MainLoginScreenState extends State<MainLoginScreen> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  late StreamSubscription<List<ConnectivityResult>> subscription;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool isLoading = false;
  bool isConnected = false;
  bool darkMode = false;
  bool visibility = true;
  
  ThemeMode get themeMode => darkMode ? ThemeMode.dark : ThemeMode.light;
  AuthButtonType? buttonType;
  AuthIconType? iconType;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
    

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if(kDebugMode){
          // Set default values
    // _emailController.text = "meshak1@gmail.com";
    // _passwordController.text = "1234567";

    // warehouse 
    // _emailController.text = "kikuyu1@gmail.com";
    // _passwordController.text = "1234567";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Login",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.055,
          ),
        ),
        leading: Container(
          margin: EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: IconButton(
            onPressed: () => Globals.switchScreens(context: context, screen: Splashscreen()),
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.04),
                        Text(
                          "Welcome Back",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Please login to continue",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.06),
                        
                        // Email Field
                        _buildTextField(
                          controller: _emailController,
                          label: "Email",
                          icon: CupertinoIcons.mail,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is empty";
                            }
                            if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Password Field
                        _buildTextField(
                          controller: _passwordController,
                          label: "Password",
                          icon: CupertinoIcons.lock,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is Empty";
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: screenHeight * 0.05),
                        
                        // Login Button
                        _buildLoginButton(context, screenWidth, screenHeight),
                        
                        SizedBox(height: screenHeight * 0.03),
                        
                        // Divider with "Or continue with" text
                        // Row(
                        //   children: [
                        //     Expanded(child: Divider(color: Colors.grey.shade300)),
                        //     Padding(
                        //       padding: EdgeInsets.symmetric(horizontal: 16),
                        //       child: Text(
                        //         "Or continue with",
                        //         style: GoogleFonts.poppins(
                        //           color: Colors.grey.shade600,
                        //           fontSize: screenWidth * 0.035,
                        //         ),
                        //       ),
                        //     ),
                        //     Expanded(child: Divider(color: Colors.grey.shade300)),
                        //   ],
                        // ),
                        
                        // SizedBox(height: screenHeight * 0.03),
                        
                        // Google Sign In Button
                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(16),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.grey.shade200,
                        //         blurRadius: 10,
                        //         spreadRadius: 1,
                        //       ),
                        //     ],
                        //   ),
                        //   child: GoogleAuthButton(
                        //     onPressed: () => AuthRequest.registerWithGoogle(context: context),
                        //     themeMode: themeMode,
                        //     isLoading: isLoading,
                        //     style: AuthButtonStyle(
                        //       width: screenWidth * 0.85,
                        //       height: 56,
                        //       borderRadius: 16,
                        //       textStyle: GoogleFonts.poppins(
                        //         color: Colors.black87,
                        //         fontWeight: FontWeight.w500,
                        //         fontSize: screenWidth * 0.04,
                        //       ),
                        //       buttonType: buttonType,
                        //       iconType: iconType,
                        //     ),
                        //   ),
                        // ),
                        
                        SizedBox(height: screenHeight * 0.03),
                        
                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade600,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Globals.switchScreens(context: context, screen: MainSignup()),
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.poppins(
                                  color: Colors.blue.shade600,
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? visibility : false,
        cursorColor: Colors.blue.shade400,
        style: GoogleFonts.poppins(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    visibility ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () => setState(() => visibility = !visibility),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () {
        if (_formState.currentState!.validate()) {
          AuthRequest.login(
            isWeb: false,
            context: context,
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
        }
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade500, Colors.green.shade600],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.shade500,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: context.watch<appBloc>().isLoading
              ? LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: screenWidth * 0.06,
                )
              : Text(
                  "Login",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
        ),
      ),
    );
  }
}