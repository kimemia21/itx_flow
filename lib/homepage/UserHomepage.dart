import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Commodities.dart/ComRequest.dart';
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
  bool orderIsEmpty = false;
  Future<List<model>>? commId;
  int? initialId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // Future<void> _fetchCommodities() async {
  //   try {
  //     print("Fetching commodities...");
  //     // _commodities =
  //     commId = CommodityRequest.fetchCommodities(context);
  //     initialId = 

  //     setState(() {
  //       // _isLoading = false;
  //     });
  //   } catch (e) {
  //     print('Error fetching commodities: $e');
  //     setState(() {
  //       // _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ITXAppBar(
        title: "EACX",
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.45,
                child: HomePageOrders(
                    onOrderCountChanged: (onOrderCountChanged) {})),
            HomepageContractsWidget(),
          ],
        ),
      ),
    );
  }
}
