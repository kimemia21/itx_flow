import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/authentication/Login.dart';
import 'package:itx/authentication/Regulator.dart';
import 'package:itx/authentication/Verification.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:itx/fromWakulima/globals.dart';
import 'package:provider/provider.dart';

class DocumentsVerification extends StatefulWidget {
  const DocumentsVerification();

  @override
  State<DocumentsVerification> createState() => _DocumentsVerificationState();
}

class _DocumentsVerificationState extends State<DocumentsVerification> {
  late Future<String> role;
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // Example of using context to update state or visibility
    //   context.read<appBloc>().changeNavVisibility(visible: false);
    // });
    role=Globals.userRole(context: context);
  }

  Widget docsType({
    required String title,
    required String subtitle,
    required VoidCallback action,
  }) {
    return GestureDetector(
      onTap: action,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.file_copy),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Documents",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       // PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
        //       //   withNavBar: true,
        //       //   context, screen: Commodites(), settings: const RouteSettings(name: "/Commadites"),);
        //       PersistentNavBarNavigator.pushNewScreen(context,
        //           screen: Verification(context: context));
        //       // Globals.switchScreens(
        //       //     context: context, screen: Verification(context: context));
        //     },
        //     icon: Icon(Icons.close),
        //   ),
        // ],
      ),
      body: Container(
        margin: EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  "Upload Documents",
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              docsType(
                title: "Authorization",
                subtitle:
                    "Add a document to prove your are authorized to sell this product ${context.watch<appBloc>().userCommodities.join(',')}",
                // ${widget.userItems.toString()}",
                action: () {
                  Globals.switchScreens(context: context, screen: Regulators());
                },
              ),
              docsType(
                title: "Compliance",
                subtitle:
                    "Add a document to prove this product is eligable for sale of ${context.watch<appBloc>().userCommodities.join(',')}",
                // ${widget.userItems.toString()}",
                action: () {
                  Globals.switchScreens(context: context, screen: Regulators());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
