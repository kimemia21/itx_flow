import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/global/globals.dart';

class Spottrader extends StatefulWidget {
  const Spottrader({super.key});

  @override
  State<Spottrader> createState() => _SpottraderState();
}

class _SpottraderState extends State<Spottrader> {
  Widget spotTraderButtons(
      {required String title,
      required VoidCallback function,
      textColor,
      buttonColor}) {
    return GestureDetector(
      onDoubleTap: function,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 10),
        height: 50,
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadiusDirectional.circular(10)),
        width: Globals.AppWidth(context: context, width: 0.4),
        child: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 20, color: textColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Trading",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 22),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Spot Trading",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 22),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Authorization Status",
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                  Text(
                    "Approved",
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  spotTraderButtons(
                      title: "Post",
                      function: () {},
                      textColor: Colors.white,
                      buttonColor: Colors.green),
                  spotTraderButtons(
                      title: "Buy",
                      function: () {},
                      textColor: Colors.black,
                      buttonColor: Colors.grey.shade300)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
