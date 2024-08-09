import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/Create.dart';
import 'package:itx/global/globals.dart';

class Mycontracts extends StatefulWidget {
  const Mycontracts({super.key});

  @override
  State<Mycontracts> createState() => _MycontractsState();
}

class _MycontractsState extends State<Mycontracts> {
  Widget ContractInfo({
    required String title,
    required String subtitle,
    required String status,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 3, bottom: 3),
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 16),
        ),
        trailing: Text(
          status,
          style: TextStyle(fontSize: 16, color: Colors.green),
        ),
      ),
    );
  }

  Widget DeliveryInfo(
      {required String title,
      // required String subtitle ,
      required String status}) {
    return Container(
      margin: EdgeInsets.only(top: 3, bottom: 3),
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text(
        //   subtitle,
        //   style: TextStyle(fontSize: 16),
        // ),
        trailing: Text(
          status,
          style: TextStyle(fontSize: 16, color: Colors.green),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Globals.leading(context: context, screen: CreateContract()),
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    "My Contracts",
                    style: GoogleFonts.poppins(
                        fontSize: 22, fontWeight: FontWeight.w600),
                  )),
              ContractInfo(
                  title: "Soybean, 100 bushels",
                  subtitle: "Dec 2023 delivery to chicago",
                  status: "Signed"),
              ContractInfo(
                  title: "Soybean, 100 bushels",
                  subtitle: "Dec 2023 delivery to chicago",
                  status: "Signed"),
              ContractInfo(
                  title: "Soybean, 100 bushels",
                  subtitle: "Dec 2023 delivery to chicago",
                  status: "Signed"),
              ContractInfo(
                  title: "Soybean, 100 bushels",
                  subtitle: "Dec 2023 delivery to chicago",
                  status: "Signed"),
              Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    "My Deliveries",
                    style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.w600),
                  )),
                    DeliveryInfo(title: "Soybean, 100 bushels",  status: "2000"),
                     DeliveryInfo(title: "Soybean, 100 bushels",  status: "300"),
                        DeliveryInfo(title: "Soybean, 100 bushels",  status: "23000"),
                           DeliveryInfo(title: "Soybean, 100 bushels",  status: "1000"),
            ],
          ),
        ),
      ),
    );
  }
}
