import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/CustomOtp.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/authentication/SignUp.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/requests/Requests.dart';
import 'package:itx/web/authentication/ComOfInterest.dart';
import 'package:itx/web/global/WebGlobals.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class WebVerification extends StatefulWidget {
  final BuildContext context;
  final String email;
  final String? phoneNumber;
  final bool isRegistered;
  final bool isWareHouse;

  const WebVerification(
      {super.key,
      required this.context,
      required this.email,
      this.phoneNumber,
      required this.isRegistered,
      required this.isWareHouse});

  @override
  State<WebVerification> createState() => _WebVerificationState();
}

class _WebVerificationState extends State<WebVerification> {
  bool _isSubmitted = false;
  String _otpCode = '';
  bool _canResendOtp = false;
  bool _isOtpValid = true; // For OTP validation
  late Timer _timer;
  int _start = 30;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResendOtp = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _resetState() {
    setState(() {
      _isSubmitted = false;
      _otpCode = '';
      _start = 30;
      _canResendOtp = false;
      _isOtpValid = true;
      _startTimer();
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _validateOtp() {
    if (_otpCode.isEmpty || _otpCode.length < 5) {
      setState(() {
        _isOtpValid = false; // Show error if OTP is not valid
      });
    } else {
      setState(() {
        _isOtpValid = true;
        _isSubmitted = true;
      });

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             WebCommoditiesOfInterest(isWareHouse: false)));

      // Proceed to OTP verification
      AuthRequest.otp(
        isWeb:true,
        isRegistered: widget.isRegistered,
        context: context,
        email: widget.email,
        otp: _otpCode.toUpperCase(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   // leading: IconButton(
      //   //   onPressed: () => Globals.switchScreens(
      //   //       context: context,
      //   //       screen: widget.isRegistered ? MainLoginScreen() : MainSignup()),
      //   //   icon: const Icon(Icons.arrow_back),
      //   // ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Webglobals.itxLogo()),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      widget.isRegistered ? "Verify Phone" : "Verify Login",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (widget.isRegistered)
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: RichText(
                          text: TextSpan(
                            text: "WebVerification code has been sent to ",
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
                    CustomOtpTextField(
                      // Use the custom OTP widget here
                      textStyle: GoogleFonts.abel(
                          fontSize: 20, fontWeight: FontWeight.w600),
                      fieldHeight: 65,
                      fieldWidth: 50,
                      borderRadius: BorderRadius.circular(10),
                      borderWidth: 2,
                      borderColor: _isOtpValid ? Colors.black : Colors.red,
                      focusedBorderColor: Colors.black54,
                      numberOfFields: 5,
                      onCodeChanged: (String code) {
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
                        _validateOtp(); // Trigger validation on submit
                      },
                    ),
                    if (!_isOtpValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Please enter a valid 5-digit OTP",
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text(
                      "Didn't get the OTP code?",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: _canResendOtp
                          ? () {
                              AuthRequest.ResendOtp(
                                 isWeb:true,
                                  context: context,
                                  isWarehouse: widget.isWareHouse);
                              _resetState();
                            }
                          : null,
                      child: _canResendOtp
                          ? Provider.of<appBloc>(context, listen: false)
                                  .isLoading
                              ? LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.blue, size: 20)
                              : Text(
                                  "Resend Code",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.blue),
                                )
                          : Text(
                              "Resend otp in $_start seconds",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        _validateOtp();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: 40,
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
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
