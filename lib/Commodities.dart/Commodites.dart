import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/Documents.dart';
import 'package:itx/authentication/Verification.dart';
import 'package:itx/fromWakulima/contant.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class Commodites extends StatefulWidget {
  final ScrollController? scrollController;
  const Commodites({this.scrollController});

  @override
  State<Commodites> createState() => _CommoditesState();
}

class _CommoditesState extends State<Commodites> {
  final List<Map<String, dynamic>> commodities = [
    {'name': 'Copper', 'unit': '1,000 lbs', 'isChecked': false},
    {'name': 'Wheat', 'unit': '5,000 bu', 'isChecked': false},
    {'name': 'Gold', 'unit': '100 oz', 'isChecked': false},
    {'name': 'Crude Oil', 'unit': '1,000 bbl', 'isChecked': false},
    {'name': 'Soybeans', 'unit': '5,000 bu', 'isChecked': false},
  ];

  List userItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                context,
                withNavBar: false,
                screen: Verification(context: context),
                settings: const RouteSettings(name: "/verification"),
              );
              // Globals.switchScreens(

              //     context: context, screen: Verification(context: context));
            },
            icon: Icon(Icons.arrow_back)),
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
                  // You can add search functionality here if needed
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: commodities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        bool newValue =
                            !(commodities[index]['isChecked'] ?? false);
                        commodities[index]['isChecked'] = newValue;
                        if (newValue) {
                          if (!userItems!
                              .contains(commodities[index]['name'])) {
                            userItems!.add(commodities[index]['name']);
                            context.read<appBloc>().changeCommodites(userItems);
                            print(userItems);
                          }
                        } else {
                          userItems!.remove(commodities[index]['name']);
                          context.read<appBloc>().changeCommodites(userItems);
                        }
                        print("User Items: $userItems");
                      });
                    },
                    trailing: Checkbox(
                        value: commodities[index]['isChecked'] ?? false,
                        onChanged: (bool? value) {
                          print(value);
                          setState(() {
                            commodities[index]['isChecked'] = value!;
                            if (value) {
                              // If checked, add to userItems if not already present
                              if (!userItems!
                                  .contains(commodities[index]['name'])) {
                                userItems!.add(commodities[index]['name']);
                                context
                                    .read<appBloc>()
                                    .changeCommodites(userItems);
                              }
                            } else {
                              // If unchecked, remove from userItems
                              userItems!.remove(commodities[index]['name']);
                              context
                                  .read<appBloc>()
                                  .changeCommodites(userItems);
                            }
                            print("User Items: $userItems");
                          });
                        }),
                    title: Text(commodities[index]['name']!),
                    subtitle: Text(commodities[index]['unit']!),
                  );
                },
              ),
            ),
            Text(userItems!.isNotEmpty
                ? context.watch<appBloc>().userCommodities.toString()
                : "User empty"),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  print("Current userItems: $userItems"); // Add t

                  if (userItems!.isEmpty || userItems!.length < 1) {
                    print("Showing error snackbar");
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
                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings: const RouteSettings(name: "/home"),
                      screen: DocumentsVerification(),
                      // pageTransitionAnimation:
                      //     PageTransitionAnimation.scaleRotate,
                    );
                  }
                },

                //  Globals.switchScreens(
                //     context: context,
                //     screen: DocumentsVerification()),

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
