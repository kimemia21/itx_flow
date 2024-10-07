import 'dart:async'; // Added for Timer functionality
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/web/HomePageWeb.dart';
import 'package:itx/web/requests/AuthRequest.dart';
import 'package:itx/web/state/Webbloc.dart';
import 'package:itx/web/uplaodDocs.dart/GlobalExchange.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class WebOtpVerification extends StatefulWidget {
  final String? phoneNumber;
  final bool isRegistered;

  const WebOtpVerification(
      {super.key, this.phoneNumber, required this.isRegistered});

  @override
  _WebOtpVerificationState createState() => _WebOtpVerificationState();
}

class _WebOtpVerificationState extends State<WebOtpVerification> {
  // Timer logic variables
  late Timer _timer;
  int _start = 30;
  bool _canResendOtp = false;
  final TextEditingController otp = TextEditingController();

  // Starts the OTP resend timer
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

  // Resets the OTP verification state and restarts the timer
  void _resetState() {
    setState(() {
      _start = 30;
      _canResendOtp = false;
      _startTimer();
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer(); // Start the timer when the widget initializes
  }

  @override
  void dispose() {
    _timer.cancel(); // Dispose the timer when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String displayPhoneNumber = widget.phoneNumber ?? 'your phone number';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Padding(
          padding: const EdgeInsets.only(left: 60),
          child: Text(
            'ITX Validation',
            style: GoogleFonts.poppins(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Icon(Icons.person, color: Colors.black),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Container(
              margin: EdgeInsets.only(top: 80, left: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's get you set up",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                  TextField(
                    controller: otp,
                    decoration: InputDecoration(
                      labelText: 'Enter the code sent to $displayPhoneNumber',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "We have sent a code to $displayPhoneNumber to verify it’s yours.",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // OTP Resend Logic
                  TextButton(
                    onPressed: _canResendOtp
                        ? () {
                            WebAuthrequest.WebResendOtp(context: context);
                            // Trigger OTP resend function here
                            // Example: AuthRequest.ResendOtp(context: context);
                            _resetState();
                          }
                        : null,
                    child: _canResendOtp
                        ? Provider.of<Webbloc>(context, listen: false).isLoading
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
                            "Resend OTP in $_start seconds",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                  ),

                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        final String email =  Provider.of<Webbloc>(context,listen: false).userEmail;

                        WebAuthrequest.WebOtp(
                            context: context,
                            email: email,
                            otp: otp.text.trim().toUpperCase(),
                            isRegistered: widget.isRegistered);
                      } catch (e) {
                        print("login error $e");
                      }
                    },
                    child: context.watch<Webbloc>().isLoading
                        ? LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white,
                            size: 25,
                          )
                        : Center(
                            child: Text(
                              'Continue',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "By continuing, you agree to the Commodity Exchange Privacy Policy and Terms of Service.",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black54,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
