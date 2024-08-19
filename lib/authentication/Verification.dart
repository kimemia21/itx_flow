import 'package:flutter/material.dart';

import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/authentication/Login.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/MyScafold.dart';
import 'package:itx/global/globals.dart';
import 'package:provider/provider.dart';

class Verification extends StatefulWidget {
  final BuildContext context;
  const Verification({required this.context});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  double _progress = 0.0;

  void _updateProgress() {
    setState(() {
      _progress = (_progress + 1).clamp(0.0, 1.0); // Increment progress
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Example of using context to update state or visibility
      context.read<appBloc>().changeNavVisibility(visible: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
              Globals.switchScreens(context: context, screen: LoginScreen());
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Text("Enter the code that we emailed you")),
              SizedBox(
                height: 10,
              ),
              OtpTextField(
                numberOfFields: 5,
                borderColor: Colors.black,
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                  _updateProgress();
                  Future.delayed(Duration(seconds: 2)).then((value) =>
                      Globals.switchScreens(
                          context: context, screen: Commodites()));
                  // showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return AlertDialog(
                  //         title: Text("Verification Code"),
                  //         content: Text('Code entered is $verificationCode'),
                  //       );
                  //     });
                }, // end onSubmit
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: _updateProgress,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.green.shade800,
                      borderRadius: BorderRadiusDirectional.circular(10)),
                  child: Text(
                    "Next",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {}, child: Text("I lost acess to my email")),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: _progress),
                  duration: Duration(seconds: 2),
                  builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(value * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        LinearProgressIndicator(
                          value: value,
                          minHeight: 8.0,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.green,
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
