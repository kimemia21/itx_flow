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
  final bool isWeb;

  const AuthorizationStatus({
    super.key,
    required this.isWareHouse,
    required this.isWeb,
  });

  @override
  State<AuthorizationStatus> createState() => _AuthorizationStatusState();
}

class _AuthorizationStatusState extends State<AuthorizationStatus> {
  Widget infoTile({
    required String title,
    required String subtitle,
    required bool status,
  }) {
    return Expanded(
      child: Container(
        width: widget.isWeb ? 400 : MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black12, width: 1),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(4, 4),
              blurRadius: 10,
            ),
          ],
        ),
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Icon(
                status ? Icons.check_circle_outline : Icons.error_outline,
                size: 30,
                color: status ? Colors.green : Colors.redAccent,
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
      ),
    );
  }

  Widget _buildContent(bool isAuthorized) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Icon(
          isAuthorized ? Icons.check_circle : Icons.error,
          color: isAuthorized ? Colors.green : Colors.redAccent,
          size: 100,
        ),
        const SizedBox(height: 20),
        Text(
          isAuthorized
              ? "You're authorized to trade!"
              : "Authorization Pending",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: isAuthorized ? Colors.green : Colors.redAccent,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          isAuthorized
              ? "Congratulations! You have met all the requirements and can now start trading on iTx."
              : "Please complete all necessary steps to gain trading authorization.",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        const SizedBox(height: 40),
        _buildActionButton(isAuthorized),
      ],
    );
  }

  Widget _buildActionButton(bool isAuthorized) {
    return GestureDetector(
      onTap: () => PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: isAuthorized
            ? GlobalsHomePage()
            : Commodities(isWareHouse: widget.isWareHouse),
      ),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.green.shade800,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          isAuthorized ? "Start Trading" : "Continue",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAuthorized =
        Provider.of<appBloc>(context, listen: false).isAuthorized == 'yes';
    final bool isWareHouse = context.watch<appBloc>().user_id == 6;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () => Globals.switchScreens(
            context: context,
            screen: Regulators(isWareHouse: isWareHouse),
          ),
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          "Trading Authorization Status",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isAuthorized)
                _buildContent(isAuthorized)
              else
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        infoTile(
                          title: "Personal Info",
                          subtitle: "Complete to trade on iTx",
                          status: true,
                        ),
                        infoTile(
                          title: "Regulator Status",
                          subtitle: "We need a few more details",
                          status: isAuthorized,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildContent(isAuthorized),
                    const SizedBox(height: 20),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GlobalsHomePage()));
                        },
                        child: Text(
                          "Skip",
                          style: GoogleFonts.poppins(color: Colors.blue),
                        ))
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
