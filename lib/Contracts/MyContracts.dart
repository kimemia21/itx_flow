import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/CreateContract.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:itx/global/globals.dart';

class Mycontracts extends StatefulWidget {
  const Mycontracts({Key? key}) : super(key: key);

  @override
  State<Mycontracts> createState() => _MycontractsState();
}

class _MycontractsState extends State<Mycontracts> {
  Widget ContractInfo({
    required String title,
    required String subtitle,
    required String status,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        trailing: Chip(
          label: Text(
            status,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
          ),
          backgroundColor: status == "Signed" ? Colors.green : Colors.orange,
        ),
      ),
    );
  }

  Widget DeliveryInfo({
    required String title,
    required VoidCallback Function,
    required String status,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: Function,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                status,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        title: Text(
          "Dashboard",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                "Active Contracts",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            ContractInfo(
              title: "Soybean, 100 bushels",
              subtitle: "Dec 2023 delivery to Chicago",
              status: "Signed",
            ),
            ContractInfo(
              title: "Corn, 200 bushels",
              subtitle: "Nov 2023 delivery to New York",
              status: "Signed",
            ),
            ContractInfo(
              title: "Wheat, 150 bushels",
              subtitle: "Jan 2024 delivery to Los Angeles",
              status: "Amended",
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                "Upcoming Deliveries",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            DeliveryInfo(
              title: "Soybean, 100 bushels",
              status: "\$2,000",
              Function: () => Globals.switchScreens(
                context: context,
                screen: Specificorder(item: "Soybean",price: 23.0,quantity: "100 bushels",),
              ),
            ),
            DeliveryInfo(
              title: "Corn, 200 bushels",
              status: "\$3,000",
              Function: () => Globals.switchScreens(
                context: context,
                screen: Specificorder(item: "Corn",price: 1.00,quantity: "100 bushels"),
              ),
            ),
            DeliveryInfo(
              title: "Wheat, 150 bushels",
              status: "\$2,300",
              Function: () => Globals.switchScreens(
                context: context,
                screen: Specificorder(item: "Wheat",price: 12.00,quantity: "12",),
              ),
            ),
          ],
        ),
      ),
    );
  }
}