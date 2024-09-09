import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/Documents.dart';
import 'package:itx/authentication/Regulator.dart';
import 'package:itx/authentication/Verification.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green.shade800,
        title: Text(
          'Commodities of Interest',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              child: Text(
                "Add Commodities of Interest",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.green.shade800,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Search Commodities',
                  labelStyle: TextStyle(color: Colors.green.shade800),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.green.shade800,
                  ),
                  fillColor: Colors.green.shade50,
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
                        'No commodities available',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade600,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredCommodities.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 6.0),
                          elevation: 2,
                          child: ListTile(
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
                                    userItems.add(
                                        filteredCommodities[index]['name']);
                                    context
                                        .read<appBloc>()
                                        .changeCommodites(userItems);
                                  }
                                } else {
                                  userItems.remove(
                                      filteredCommodities[index]['name']);
                                  context
                                      .read<appBloc>()
                                      .changeCommodites(userItems);
                                }
                              });
                            },
                            trailing: Checkbox(
                              value: filteredCommodities[index]['isChecked'] ??
                                  false,
                              activeColor: Colors.green.shade800,
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
                                    }
                                  } else {
                                    userItems.remove(
                                        filteredCommodities[index]['name']);
                                    context
                                        .read<appBloc>()
                                        .changeCommodites(userItems);
                                  }
                                });
                              },
                            ),
                            title: Text(
                              filteredCommodities[index]['name']!,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              filteredCommodities[index]['unit']!,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Text(
              userItems.isNotEmpty
                  ? 'Selected: ${userItems.join(', ')}'
                  : "No commodities selected",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 16),
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
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else {
                    PersistentNavBarNavigator.pushNewScreen(
                      withNavBar: true,
                      context,
                      screen: DocumentsVerification(),
                    );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green.shade800,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    "Done",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
