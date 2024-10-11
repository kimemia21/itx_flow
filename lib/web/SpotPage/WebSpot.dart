import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/web/contracts/Contract.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class WebSpottrader extends StatefulWidget {
  const WebSpottrader({super.key});

  @override
  State<WebSpottrader> createState() => _WebSpottraderState();
}

class _WebSpottraderState extends State<WebSpottrader> with SingleTickerProviderStateMixin {
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
    final screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth < 600
        ? screenWidth * 0.8 // Mobile width
        : screenWidth * 0.4; // Tablet or larger

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
        width: buttonWidth,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: screenWidth < 600 ? 16 : 20, // Adjust font size for mobile
            color: textColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Trading",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: screenWidth < 600 ? 18 : 22, // Adjust title size for smaller screens
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: screenWidth < 600 ? true : false, // Scrollable on mobile
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
          Center(child: Text('Minerals Content', style: GoogleFonts.poppins(fontSize: screenWidth < 600 ? 14 : 18))),
          WebContracts(filtered: true, showAppbarAndSearch: false, isWareHouse: false, isSpot: true),
          Center(child: Text('Energy Content', style: GoogleFonts.poppins(fontSize: screenWidth < 600 ? 14 : 18))),
          Center(child: Text('Crafts Content', style: GoogleFonts.poppins(fontSize: screenWidth < 600 ? 14 : 18))),
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
