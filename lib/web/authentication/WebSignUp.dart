import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Serializers/UserTypes.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/Requests.dart';
import 'package:itx/web/authentication/OtpVerification.dart';
import 'package:itx/web/authentication/WebLogin.dart';
import 'package:provider/provider.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:itx/state/AppBloc.dart';

class Websignup extends StatefulWidget {
  const Websignup({Key? key}) : super(key: key);

  @override
  State<Websignup> createState() => _WebsignupState();
}

class _WebsignupState extends State<Websignup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _LocationController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedUserType;
  List<UserTypeModel> _userTypes = [];
  List roleType = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserTypes();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserTypes() async {
    try {
      final userTypes = await AuthRequest.getUserType(context);
      setState(() {
        _userTypes = userTypes;
        _isLoading = false;
        roleType.clear();
        for (var userType in _userTypes) {
          roleType.add(userType.name);
        }
      });
    } catch (e) {
      print('Error fetching user types: $e');
      setState(() {
        _isLoading = false;
      });
    }
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
      height: 65,
      width: MediaQuery.of(context).size.width * 0.4,
      margin: EdgeInsets.all(5),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword
            ? (isPassword == true ? _obscurePassword : _obscureConfirmPassword)
            : false,
        keyboardType: isPassword ? TextInputType.visiblePassword : keyboardType,
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
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPassword == true
                        ? (_obscurePassword
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye)
                        : (_obscureConfirmPassword
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye),
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  onPressed: () => setState(() => isPassword == true
                      ? _obscurePassword = !_obscurePassword
                      : _obscureConfirmPassword = !_obscureConfirmPassword),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade400, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
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

  Widget buildWareHouseFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          label: "WareHouse Name",
          icon: Icons.house,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty)
              return "wareHouse name  is required";
          },
        ),
        _buildTextField(
          controller: _LocationController,
          label: "WareHouse Location",
          icon: Icons.map_sharp,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty)
              return "wareHouse location is required";
            // if (!RegExp(
            //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            //     .hasMatch(value)) return "Enter a valid email";
            // return null;
          },
        ),
        _buildTextField(
          controller: _capacityController,
          label: "Storage   Capacity Interms of Kg",
          icon: Icons.storage_outlined,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty)
              return "wareHouse storage capacity is required";
            // if (!RegExp(
            //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            //     .hasMatch(value)) return "Enter a valid email";
            // return null;
          },
        ),
        _buildTextField(
          controller: _rateController,
          label: "Storage Rate For Kilo per day in kshs",
          icon: Icons.attach_money_outlined,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty)
              return "WareHouse Storage rate is required";
            // if (!RegExp(
            //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            //     .hasMatch(value)) return "Enter a valid email";
            // return null;
          },
        ),
      ],
    );
  }

  Widget _buildRadioButton({required String text, required String value}) {
    return Container(
      height: 65,
      width: MediaQuery.of(context).size.width * 0.4,
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: _selectedUserType == value
            ? Colors.green.shade50
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selectedUserType == value
              ? Colors.green.shade400
              : Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: RadioListTile<String>(
        title: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _selectedUserType == value
                ? Colors.green.shade700
                : Colors.grey.shade700,
          ),
        ),
        value: value,
        groupValue: _selectedUserType,
        onChanged: (String? value) => setState(() => _selectedUserType = value),
        activeColor: Colors.green.shade400,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  void _handleSignup() {
      WebVerification(
            context: context,
            email: "email",
            isRegistered: false,
            isWareHouse: false);

         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WebVerification(
            context: context,
            email: "email",
            isRegistered: false,
            isWareHouse: false)));   

            
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        Globals.showErrorToast('Password Error',
            'Make sure the password and confirm password match', context);
      } else if (_selectedUserType == null) {
        Globals.showErrorToast(
            'Role Error', 'Please select a user role', context);
      } else {
        final Map<String, dynamic> userBody = {
          "email": _emailController.text,
          "password": _passwordController.text.trim(),
          "phonenumber": _phoneNumberController.text.trim(),
          "user_type": int.parse(_selectedUserType!),
        };

// name, location, capacity, rate
// POST /user/warehouse

        final warehouseBody = {
          "email": _emailController.text,
          "password": _passwordController.text.trim(),
          "phonenumber": _phoneNumberController.text.trim(),
          "user_type": int.parse(_selectedUserType!),
          "name": _nameController.text,
          "location": _LocationController.text.trim(),
          "capacity": _capacityController.text.trim(),
          "rate": _rateController.text.trim(),
        };

        context.read<appBloc>().changeUserDetails(
            _selectedUserType == "6" ? warehouseBody : userBody);
        WebVerification(
            context: context,
            email: "email",
            isRegistered: false,
            isWareHouse: false);

        // AuthRequest.register(
        //   isWeb: true,
        //   body: _selectedUserType == "6" ? warehouseBody : userBody,
        //   context: context,
        //   isOnOtp: false,
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: LayoutBuilder(builder: (context, constraints) {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;
          bool isMobile = screenWidth < 900;

          return Center(
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
                              height: isMobile
                                  ? screenHeight * 0.9
                                  : screenHeight * 0.85,
                              child: SingleChildScrollView(
                                  child: Flex(
                                      direction: isMobile
                                          ? Axis.vertical
                                          : Axis.horizontal,
                                      children: [
                                    Expanded(
                                        flex: isMobile ? 1 : 4,
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              isMobile ? 20 : 40),
                                          color: Colors.white,
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Create Account",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  "Join as ${roleType.join(", ")}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Text(
                                                  "Select your role",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                SizedBox(height: 15),
                                                _isLoading
                                                    ? Center(
                                                        child: LoadingAnimationWidget
                                                            .staggeredDotsWave(
                                                          color: Colors
                                                              .green.shade400,
                                                          size: 40,
                                                        ),
                                                      )
                                                    : Column(
                                                        children: _userTypes
                                                            .map((userType) {
                                                          return _buildRadioButton(
                                                            text: userType.name
                                                                .toUpperCase(),
                                                            value: userType.id
                                                                .toString(),
                                                          );
                                                        }).toList(),
                                                      ),
                                                SizedBox(height: 30),
                                                Visibility(
                                                    visible:
                                                        _selectedUserType ==
                                                            "6",
                                                    child:
                                                        buildWareHouseFields()),
                                                _buildTextField(
                                                  controller: _emailController,
                                                  label: "Email Address",
                                                  icon: CupertinoIcons.mail,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty)
                                                      return "Email is required";
                                                    if (!RegExp(
                                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                        .hasMatch(value))
                                                      return "Enter a valid email";
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 20),
                                                _buildTextField(
                                                  controller:
                                                      _phoneNumberController,
                                                  label: "Phone Number",
                                                  icon: CupertinoIcons.phone,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty)
                                                      return "Phone number is required";
                                                    if (!RegExp(r'^\d{10}$')
                                                        .hasMatch(value))
                                                      return "Enter a valid 10-digit phone number";
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 20),
                                                _buildTextField(
                                                  controller:
                                                      _passwordController,
                                                  label: "Password",
                                                  icon: CupertinoIcons.lock,
                                                  isPassword: true,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty)
                                                      return "Password is required";
                                                    if (value.length < 6)
                                                      return "Password must be at least 6 characters long";
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 20),
                                                _buildTextField(
                                                  controller:
                                                      _confirmPasswordController,
                                                  label: "Confirm Password",
                                                  icon: CupertinoIcons.lock,
                                                  isPassword: true,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty)
                                                      return "Confirm password is required";
                                                    if (value !=
                                                        _passwordController
                                                            .text)
                                                      return "Passwords do not match";
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  height: 50,
                                                  child: MaterialButton(
                                                    onPressed: _handleSignup,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    color:
                                                        Colors.green.shade400,
                                                    elevation: 0,
                                                    highlightElevation: 0,
                                                    minWidth: double.infinity,
                                                    height: 55,
                                                    child: context
                                                            .watch<appBloc>()
                                                            .isLoading
                                                        ? LoadingAnimationWidget
                                                            .staggeredDotsWave(
                                                            color: Colors.white,
                                                            size: 20,
                                                          )
                                                        : Text(
                                                            "Sign Up",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Already have an account?",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors
                                                            .grey.shade600,
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Weblogin(),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        "Sign In",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors
                                                              .green.shade400,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ))
                                  ])))))));
        }));
  }
}
