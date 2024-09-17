import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Serializers/UserTypes.dart';
import 'package:itx/requests/Requests.dart';
import 'package:provider/provider.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MainSignup extends StatefulWidget {
  const MainSignup({Key? key}) : super(key: key);

  @override
  State<MainSignup> createState() => _MainSignupState();
}

class _MainSignupState extends State<MainSignup>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedUserType;
  List<UserTypeModel> _userTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    _fetchUserTypes();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserTypes() async {
    try {
      final userTypes = await AuthRequest.getContracts(context);
      setState(() {
        _userTypes = userTypes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching user types: $e');
      setState(() {
        _isLoading = false;
      });
      // You might want to show an error message to the user here
    }
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
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
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
                
                labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.green[700]),
                prefixIcon: Icon(icon, color: Colors.green[600]),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          isPassword == true
                              ? (_obscurePassword ? Icons.visibility_off : Icons.visibility)
                              : (_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                          color: Colors.green[600],
                        ),
                        onPressed: () => setState(() => isPassword == true
                            ? _obscurePassword = !_obscurePassword
                            : _obscureConfirmPassword = !_obscureConfirmPassword),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.green.shade200, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.green.shade400, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: validator,
            ),
          ),
        );
      },
    );
  }

  Widget _buildRadioButton({required String text, required String value}) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: RadioListTile<String>(
              title: Text(text,
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
              value: value,
              groupValue: _selectedUserType,
              onChanged: (String? value) => setState(() => _selectedUserType = value),
              activeColor: Colors.green.shade700,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              tileColor: _selectedUserType == value ? Colors.green.shade50 : null,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // _emailController.text = "mimeki5@ofionk.com";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Sign Up',
              textStyle: GoogleFonts.poppins(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              speed: Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Globals.switchScreens(context: context, screen: MainLoginScreen()),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: AnimationLimiter(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 600),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: [
                    Text(
                      "Join as a Buyer, Producer, or Trader",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Please provide your information to get started.",
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 30),
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Email is required";
                        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
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
                        if (value == null || value.isEmpty) return "Phone number is required";
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
                        if (value == null || value.isEmpty) return "Password is required";
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
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    _isLoading
                        ? Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.green,
                              size: 50,
                            ),
                          )
                        : Column(
                            children: _userTypes.map((userType) {
                              return _buildRadioButton(
                                text: userType.name,
                                value: userType.id.toString(),
                              );
                            }).toList(),
                          ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleSignup,
                        child: context.watch<appBloc>().isLoading
                            ? LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white,
                                size: 25,
                              )
                            : Text(
                                "Sign Up",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade500,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
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
  }
}