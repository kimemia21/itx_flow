import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class Spottrader extends StatefulWidget {
  const Spottrader({super.key});

  @override
  State<Spottrader> createState() => _SpottraderState();
}

class _SpottraderState extends State<Spottrader> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // 4 tabs
  }

  Widget spotTraderButtons({
    required String title,
    required VoidCallback function,
    textColor,
    buttonColor,
  }) {
    return GestureDetector(
      onTap: function,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 10),
        height: 50,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width * 0.4,
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
        // leading: IconButton(
        //   onPressed: () {
        //     PersistentNavBarNavigator.pushNewScreen(
        //       context,
        //       screen: Specificorder(
        //         productName: "bean",
        //         item: "beans",
        //         price: 40,
        //         quantity: "12",
        //         companyId: "1",
        //       ),
        //     );
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Trading",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true, // Allows scrolling for the tabs if needed
          indicatorColor: Colors.green,
          labelColor: Colors.black,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: 'Minerals'),
            Tab(text: 'Agriculture'),
            Tab(text: 'Energy'),
            Tab(text: 'Crafts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // warehouse has no views 
          Center(child: Text('Minerals Content', style: GoogleFonts.poppins(fontSize: 18))),
           Contracts(filtered: true,showAppbarAndSearch: false,isWareHouse: false,isSpot: true,contractName: "Spot",), 
          Center(child: Text('Energy Content', style: GoogleFonts.poppins(fontSize: 18))),
          Center(child: Text('Crafts Content', style: GoogleFonts.poppins(fontSize: 18))),
        ],
      ),
    );
  }

   
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
