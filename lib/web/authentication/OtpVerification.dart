import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/CustomOtp.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/requests/Requests.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class WebVerification extends StatefulWidget {
  final BuildContext context;
  final String email;
  final String? phoneNumber;
  final bool isRegistered;
  final bool isWareHouse;

  const WebVerification({
    Key? key,
    required this.context,
    required this.email,
    this.phoneNumber,
    required this.isRegistered,
    required this.isWareHouse,
  }) : super(key: key);

  @override
  State<WebVerification> createState() => _WebVerificationState();
}

class _WebVerificationState extends State<WebVerification> {
  bool _isSubmitted = false;
  String _otpCode = '';
  bool _canResendOtp = false;
  bool _isOtpValid = true;
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
        _isOtpValid = false;
      });
    } else {
      setState(() {
        _isOtpValid = true;
        _isSubmitted = true;
      });

      AuthRequest.otp(
        isWeb: true,
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
      backgroundColor: Colors.grey.shade300,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;
          bool isMobile = screenWidth < 900;

          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              constraints: BoxConstraints(maxWidth: 1200),
              child: Card(
                elevation: 30,
                shadowColor: Colors.black.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: isMobile ? screenHeight * 0.9 : screenHeight * 0.85,
                    child: Expanded(
                      flex: isMobile ? 1 : 4,
                      child: Container(
                        padding: EdgeInsets.all(isMobile ? 20 : 40),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.isRegistered ? "Verify Otp" : "Verify Otp",
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            if (widget.isRegistered)
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: "Verification code has been sent to ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: widget.phoneNumber,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(height: 40),
                            CustomOtpTextField(
                              textStyle: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                              fieldHeight: 65,
                              fieldWidth: isMobile ? 50 : 60,
                              borderRadius: BorderRadius.circular(16),
                              borderWidth: 1.5,
                              borderColor: _isOtpValid
                                  ? Colors.grey.shade200
                                  : Colors.red.shade300,
                              focusedBorderColor: Colors.green.shade400,
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
                                _validateOtp();
                              },
                            ),
                            if (!_isOtpValid)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  "Please enter a valid 5-digit OTP",
                                  style: GoogleFonts.poppins(
                                    color: Colors.red.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            SizedBox(height: 40),
                            Text(
                              "Didn't receive the code?",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            TextButton(
                              onPressed: _canResendOtp
                                  ? () {
                                      AuthRequest.ResendOtp(
                                        isWeb: true,
                                        context: context,
                                        isWarehouse: widget.isWareHouse,
                                      );
                                      _resetState();
                                    }
                                  : null,
                              child: _canResendOtp
                                  ? context.watch<appBloc>().isLoading
                                      ? LoadingAnimationWidget
                                          .staggeredDotsWave(
                                          color: Colors.green.shade400,
                                          size: 20,
                                        )
                                      : Text(
                                          "Resend Code",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.green.shade400,
                                          ),
                                        )
                                  : Text(
                                      "Resend code in $_start seconds",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                            ),
                            SizedBox(height: 40),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 50,
                              child: MaterialButton(
                                onPressed: _validateOtp,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.green.shade400,
                                elevation: 0,
                                highlightElevation: 0,
                                child: context.watch<appBloc>().isLoading
                                    ? LoadingAnimationWidget.staggeredDotsWave(
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    : Text(
                                        "Verify Code",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
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
            ),
          );
        },
      ),
    );
  }
}
