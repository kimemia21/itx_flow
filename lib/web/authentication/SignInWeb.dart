import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/SignUp.dart';
import 'package:itx/authentication/SplashScreen.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/web/authentication/SignUp.dart';
import 'package:itx/web/requests/AuthRequest.dart';
import 'package:itx/web/state/Webbloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class SignInWeb extends StatefulWidget {
  const SignInWeb({Key? key}) : super(key: key);

  @override
  State<SignInWeb> createState() => _SignInWebState();
}

class _SignInWebState extends State<SignInWeb> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool visibility = true;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Login",
          style: GoogleFonts.poppins(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),

        // leading: Container(
        //   margin: const EdgeInsets.only(left: 16),
        //   decoration: BoxDecoration(
        //     color: Colors.grey.shade300,
        //     borderRadius: BorderRadius.circular(8),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.black.withOpacity(0.1),
        //         blurRadius: 5,
        //         offset: const Offset(0, 2),
        //       ),
        //     ],
        //   ),
        //   child: IconButton(
        //     onPressed: () => Globals.switchScreens(context: context, screen: Splashscreen()),
        //     icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   ),
        // ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Login to your Account",
                      style: GoogleFonts.abel(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Welcome to our App, Please login to continue",
                      style: GoogleFonts.abel(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _buildInputField(
                      controller: _emailController,
                      label: "Email",
                      icon: CupertinoIcons.mail_solid,
                      isPassword: false,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _passwordController,
                      label: "Password",
                      icon: CupertinoIcons.padlock_solid,
                      isPassword: true,
                      visibility: visibility,
                      toggleVisibility: () =>
                          setState(() => visibility = !visibility),
                    ),
                    const SizedBox(height: 32),
                    _buildLoginButton(),
                    const SizedBox(height: 16),
                    _buildSignupButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool? visibility,
    VoidCallback? toggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: isPassword ? visibility! : false,
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black54,
          ),
          prefixIcon: Icon(icon, color: Colors.black54, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    visibility!
                        ? CupertinoIcons.eye_slash_fill
                        : CupertinoIcons.eye_fill,
                    size: 20,
                  ),
                  color: Colors.black54,
                  onPressed: toggleVisibility,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.green.shade400, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          WebAuthrequest.login(
              context: context,
              email: _emailController.text,
              password: _passwordController.text);

          // Add your authentication logic here
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade500,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: context.watch<Webbloc>().isLoading
          ? LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 20,
            )
          : Text(
              "Login",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _buildSignupButton() {
    return TextButton(
      onPressed: () =>
          Globals.switchScreens(context: context, screen: MainSignupWeb()),
      child: Text(
        "Don't have an account? Sign up",
        style: GoogleFonts.abel(
          color: Colors.blue.shade700,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
