import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/uploadCerts/Regulator.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/warehouse/WareHouseHomepage.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class AuthorizationStatus extends StatefulWidget {
  final bool isWareHouse;
  const AuthorizationStatus({super.key, required this.isWareHouse});

  @override
  State<AuthorizationStatus> createState() => _AuthorizationStatusState();
}

class _AuthorizationStatusState extends State<AuthorizationStatus> {
 Widget infoTiles({
  required String title,
  required String subtitle,
  required bool status,
}) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.4,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.black12, width: 1.5),
      color: Colors.white, // Clean background
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(2, 2),
          blurRadius: 6, // Subtle shadow for modern touch
        ),
      ],
    ),
    height: 120,
    margin: const EdgeInsets.only(right: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Icon(
            status ? Icons.check_circle_outline : Icons.error_outline,
            size: 28,
            color: status ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final authStatus =
        Provider.of<appBloc>(context, listen: false).isAuthorized;
    final bool isWareHouse = context.watch<appBloc>().user_id == 6;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () => Globals.switchScreens(
              context: context,
              screen: Regulators(
                isWareHouse: isWareHouse,
              )),
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text("Trading Authorization Status",style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: authStatus == 'yes'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Icon(Icons.check_circle, color: Colors.green, size: 100),
                    SizedBox(height: 20),
                    Text(
                      "You're authorized to trade!",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Congratulations! You have met all the requirements and can now start trading on iTx.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () => PersistentNavBarNavigator.pushNewScreen(
                          withNavBar: true, context, screen: GlobalsHomePage()),
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green.shade800,
                          borderRadius: BorderRadiusDirectional.circular(10),
                        ),
                        child: Text(
                          "Start Trading",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          infoTiles(
                            title: "Personal info",
                            subtitle: "Complete to trade on iTx",
                            status: true,
                          ),
                          infoTiles(
                            status: authStatus == 'yes',
                            title: "Regulator status",
                            subtitle: "We need a few more details",
                          ),
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
                              PersistentNavBarNavigator.pushNewScreen(context,
                                  screen: Regulators(isWareHouse: isWareHouse));
                            },
                            child: Text("Continue"),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Your regulator status helps us understand your investment experience",
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: isWareHouse
                              ? Commodities(isWareHouse: isWareHouse)
                              : GlobalsHomePage()),
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green.shade800,
                          borderRadius: BorderRadiusDirectional.circular(10),
                        ),
                        child: Text(
                          "Continue",
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
