import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/SignUp.dart';
import 'package:itx/fromWakulima/widgets/globals.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/requests/Requests.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class Verification extends StatefulWidget {
  final BuildContext context;
  final String email;
  final String phoneNumber;
  const Verification(
      {required this.context, required this.email, required this.phoneNumber});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool _isSubmitted = false;
  String _otpCode = '';

  void _resetState() {
    setState(() {
      _isSubmitted = false;
      _otpCode = ''; // Reset OTP code
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Any additional initialization can go here.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () =>
                Globals.switchScreens(context: context, screen: MainSignup()),
            icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    text: "Enter the code sent to ",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: widget.phoneNumber,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OtpTextField(
                keyboardType: TextInputType.text,
                numberOfFields: 5,
                borderColor: Colors.black,
                showFieldAsBox: true,
                onCodeChanged: (String code) {
                  // Allow re-editing the OTP fields.
                  setState(() {
                    _isSubmitted = false;
                    _otpCode = code;
                  });
                },
                onSubmit: (String verificationCode) {
                  setState(() {
                    _isSubmitted = true;
                    _otpCode = verificationCode;
                  });
                },
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (_isSubmitted) {
                    AuthRequest.otp(
                        context: context,
                        email: widget.email,
                        otp: _otpCode.toUpperCase());
                  } else {
                    // Do something before submission, like validation
                  }
                },
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green.shade800,
                      borderRadius: BorderRadiusDirectional.circular(10),
                    ),
                    child: context.watch<appBloc>().isLoading
                        ? Text(
                            _isSubmitted ? "Verify" : "Next",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        : LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white, size: 25)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Logic to handle the case where the user lost access to the email
                },
                child: const Text("I lost access to my email"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
