import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/Documents.dart';
import 'package:itx/authentication/Regulator.dart';
import 'package:itx/authentication/Verification.dart';
import 'package:itx/fromWakulima/AppBloc.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/web/DocumentScreen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class Commodities extends StatefulWidget {
  final ScrollController? scrollController;
  const Commodities({this.scrollController});

  @override
  State<Commodities> createState() => _CommoditiesState();
}

class _CommoditiesState extends State<Commodities> {
  final List<Map<String, dynamic>> commodities = [
    {'name': 'Copper', 'unit': '1,000 lbs', 'isChecked': false},
    {'name': 'Wheat', 'unit': '5,000 bu', 'isChecked': false},
    {'name': 'Gold', 'unit': '100 oz', 'isChecked': false},
    {'name': 'Crude Oil', 'unit': '1,000 bbl', 'isChecked': false},
    {'name': 'Soybeans', 'unit': '5,000 bu', 'isChecked': false},
    {'name': 'Coffee', 'unit': 'grams', 'isChecked': false},
    {'name': 'Tea', 'unit': 'grams', 'isChecked': false},
  ];

  List<Map<String, dynamic>> filteredCommodities = [];
  List userItems = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    filteredCommodities = commodities;
  }


  void _filterCommodities(String text) {
    setState(() {
      searchText = text;
      if (text.isEmpty) {
        filteredCommodities = commodities;
      } else {
        filteredCommodities = commodities
            .where((commodity) =>
                commodity['name'].toLowerCase().contains(text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              child: Text(
                "Add Commodities of interest",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: 'Search commodities',
                  prefixIcon: Icon(Icons.search),
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
                onChanged: (text) {
                  _filterCommodities(text);
                },
              ),
            ),
            Expanded(
              child: filteredCommodities.isEmpty
                  ? Center(
                      child: Text(
                        'Not available',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredCommodities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            setState(() {
                              bool newValue = !(filteredCommodities[index]
                                      ['isChecked'] ??
                                  false);
                              filteredCommodities[index]['isChecked'] =
                                  newValue;
                              if (newValue) {
                                if (!userItems.contains(
                                    filteredCommodities[index]['name'])) {
                                  userItems
                                      .add(filteredCommodities[index]['name']);
                                  // Handle adding to context
                                }
                              } else {
                                userItems
                                    .remove(filteredCommodities[index]['name']);
                                // Handle removing from context
                              }
                            });
                          },
                          trailing: Checkbox(
                              value: filteredCommodities[index]['isChecked'] ??
                                  false,
                              onChanged: (bool? value) {
                                setState(() {
                                  filteredCommodities[index]['isChecked'] =
                                      value!;
                                  if (value) {
                                    if (!userItems.contains(
                                        filteredCommodities[index]['name'])) {
                                      userItems.add(
                                          filteredCommodities[index]['name']);
                                      context
                                          .read<appBloc>()
                                          .changeCommodites(userItems);
                                      // Handle adding to context
                                    }
                                  } else {
                                    userItems.remove(
                                        filteredCommodities[index]['name']);
                                    context
                                        .read<appBloc>()
                                        .changeCommodites(userItems);
                                    // Handle removing from context
                                  }
                                });
                              }),
                          title: Text(filteredCommodities[index]['name']!),
                          subtitle: Text(filteredCommodities[index]['unit']!),
                        );
                      },
                    ),
            ),
            Text(userItems.isNotEmpty
                ? userItems.toString()
                : "No commodities selected"),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  if (userItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.black,
                          content: Text(
                            "Please select a commodity",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          )),
                    );
                  } else {
                    PersistentNavBarNavigator.pushNewScreen(
                        withNavBar: true,
                        context,
                        screen: DocumentsVerification());
                    // Navigate to the next screen
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.green.shade800,
                      borderRadius: BorderRadiusDirectional.circular(10)),
                  child: Text(
                    "Done",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
