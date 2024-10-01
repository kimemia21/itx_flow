import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/uploadCerts/Regulator.dart';
import 'package:itx/global/GlobalsHomepage.dart';

import 'package:itx/global/globals.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class Authorization extends StatefulWidget {
  const Authorization({super.key});

  @override
  State<Authorization> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  Widget infoTiles({required String title, required String subtitle}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(10),
          border: Border.all(color: Colors.black54),
          color: Colors.grey.shade300),
      height: 120,
      margin: EdgeInsets.only(right: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check),
          Text(
            title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          Text(subtitle)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () =>
                Globals.switchScreens(context: context, screen: Regulators()),
            icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text("Trading Authorization"),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      infoTiles(
                          title: "Personal info",
                          subtitle: "complete to trade on iTx"),
                          
                      infoTiles(
                          title: "Regulator status",
                          subtitle: "We need a few more details")
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Regulator status"),
                      TextButton(
                          onPressed: () {
                            Globals.switchScreens(
                                context: context, screen: Regulators());
                          },
                          child: Text("Continue")),
                    ],
                  ),
                ),
                Text(
                    "Your regulor status helps us understand your investment experience"),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () => PersistentNavBarNavigator.pushNewScreen(
                      withNavBar: true,
                      context,
                      screen: GlobalsHomePage()
                       
                      ),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.green.shade800,
                        borderRadius: BorderRadiusDirectional.circular(10)),
                    child: Text(
                      "Continue",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
