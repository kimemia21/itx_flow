
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/fromWakulima/contant.dart';
import 'package:provider/provider.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 
        
        AppWidth(context, 1),
        height: 50,
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return topbarItems("category $index", context);
            }));
  }
}

Widget topbarItems(String text, BuildContext context) {
  return Container(
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,

            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ]),
    child: Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.black54,fontWeight: FontWeight.w600),
    ),
  );
}
