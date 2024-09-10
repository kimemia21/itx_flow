import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/requests/Requests.dart';
import 'package:provider/provider.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/authentication/LoginScreen.dart';

class MainSignup extends StatefulWidget {
  const MainSignup({Key? key}) : super(key: key);

  @override
  State<MainSignup> createState() => _MainSignupState();
}

class _MainSignupState extends State<MainSignup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedUserType;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        _showErrorToast('Password Error',
            'Make sure the password and confirm password match');
      } else if (_selectedUserType == null) {
        _showErrorToast('Role Error', 'Please select a user role');
      } else {
        AuthRequest.register(
          context: context,
          email: _emailController.text,
          password: _passwordController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          user_type: _selectedUserType!,
        );
      }
    }
  }

  void _showErrorToast(String title, String message) {
    CherryToast.warning(
      title:
          Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      description: Text(message, style: GoogleFonts.abel()),
      animationDuration: Duration(milliseconds: 200),
      animationCurve: Curves.easeInOut,
    ).show(context);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword
            ? (isPassword == true ? _obscurePassword : _obscureConfirmPassword)
            : false,
        keyboardType: isPassword ? TextInputType.visiblePassword : keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPassword == true
                        ? (_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility)
                        : (_obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                    color: Colors.grey[600],
                  ),
                  onPressed: () => setState(() => isPassword == true
                      ? _obscurePassword = !_obscurePassword
                      : _obscureConfirmPassword = !_obscureConfirmPassword),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field is required";
          }

          if (keyboardType == TextInputType.phone) {
            // Custom phone number validation
            if (!RegExp(r'^[+]?[0-9]{10,13}$').hasMatch(value)) {
              return "Please enter a valid phone number";
            }
          }

          return null;
        },
      ),
    );
  }

  Widget _buildRadioButton({required String text, required String value}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: RadioListTile<String>(
        title: Text(text,
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
        value: value,
        groupValue: _selectedUserType,
        onChanged: (String? value) => setState(() => _selectedUserType = value),
        activeColor: Colors.green.shade700,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _emailController.text = "gasepol988@rogtat.com";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("Sign Up",
            style: GoogleFonts.poppins(
                color: Colors.black87, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Globals.switchScreens(
              context: context, screen: MainLoginScreen()),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Join as a Buyer, Producer, or Trader",
                  style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(height: 10),
                Text(
                  "Please provide your information to get started.",
                  style: GoogleFonts.poppins(
                      fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 30),
                _buildTextField(
                  controller: _emailController,
                  label: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Email is required";
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) return "Enter a valid email";
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _phoneNumberController,
                  label: "Phone Number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Phone number is required";
                    if (!RegExp(r'^\d{10}$').hasMatch(value))
                      return "Enter a valid 10-digit phone number";
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Password is required";
                    if (value.length < 6)
                      return "Password must be at least 6 characters long";
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: "Confirm Password",
                  icon: Icons.lock,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Confirm password is required";
                    if (value != _passwordController.text)
                      return "Passwords do not match";
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Select your role",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                SizedBox(height: 10),
                _buildRadioButton(text: "Buyer", value: "Buyer"),
                _buildRadioButton(text: "Producer", value: "Producer"),
                _buildRadioButton(text: "Trader", value: "Trader"),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSignup,
                    child: context.watch<appBloc>().isLoading
                        ? LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white, size: 25)
                        : Text("Sign Up",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade500,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
