import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/SignUp.dart';
import 'package:itx/fromWakulima/widgets/globals.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/requests/HomepageRequest.dart';
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    // color: Colors.black,
                  ),
                  "Verify Phone"),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    text: "Verification code has being sent to ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: widget.phoneNumber,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OtpTextField(
                textStyle:
                    GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.w600),
                focusedBorderColor: Colors.black54,
                fieldHeight: 85,
                borderWidth: 3,
                fieldWidth: 65,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                cursorColor: Colors.black54,
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
              Text(
                "Didn't get otp code?",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 20),
              ),
              const SizedBox(height: 5),
              TextButton(
                onPressed: () async {
                  Map<String, dynamic> userDetails =
                      Provider.of<appBloc>(context, listen: false).userDetails;
                  AuthRequest.ResendOtp(context: context);
                },
                child: Provider.of<appBloc>(context, listen: false).isLoading
                    ? LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.blue, size: 20)
                    : Text(
                        "Resend Code",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.blue),
                      ),
              ),
              const SizedBox(height: 20),
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
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white, size: 25)
                      : Text(
                          _isSubmitted ? "Verify" : "Next",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
