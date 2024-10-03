import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/global/appbar.dart';
import 'package:itx/homepage/homeOrders.dart';
import 'package:itx/homepage/homeContracts.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class Userhomepage extends StatefulWidget {
  const Userhomepage({super.key});

  @override
  State<Userhomepage> createState() => _UserhomepageState();
}

class _UserhomepageState extends State<Userhomepage> {
  bool orderIsEmpty =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ITXAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 400,
                child: HomePageOrders(
                    onOrderCountChanged: (onOrderCountChanged) {})),
            HomepageContractsWidget(),
          ],
        ),
      ),
    );
  }
}
    