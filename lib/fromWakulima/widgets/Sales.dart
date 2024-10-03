import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/fromWakulima/widgets/Arrivals.dart';
import 'package:itx/fromWakulima/widgets/Deals.dart';
import 'package:itx/fromWakulima/widgets/Popular.dart';
import 'package:itx/fromWakulima/widgets/TobBar.dart';
import 'package:itx/fromWakulima/widgets/contant.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

import 'package:badges/badges.dart' as badges;

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  final List<String> items =
      List<String>.generate(20, (index) => "Item $index");
  List<Map> Categories = [
    {
      "name": "Coal",
      "imageUrl":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Charcoal_8.jpg/1200px-Charcoal_8.jpg",
      "onPress": MaterialPageRoute(builder: (context) => TopBar()),
    },
    {
      "name": "Gold",
      "imageUrl": "https://www.goodreturns.in/img/2023/03/gold1-1678254479.jpg",
      "onPress": MaterialPageRoute(builder: (context) => TopBar()),
    },
    {
      "name": "Tea",
      "imageUrl":
          "https://media.licdn.com/dms/image/C4E12AQE4P4p2RWx7Xw/article-inline_image-shrink_1000_1488/0/1520170688195?e=1724889600&v=beta&t=nelnt86XuXm3PS-CgLBzkKlTnhdOEI8XUNAUFtWmbp8",
      "onPress": MaterialPageRoute(builder: (context) => TopBar()),
    },
    {
      "name": "Milk",
      "imageUrl":
          "https://5.imimg.com/data5/SELLER/Default/2021/8/AL/BB/PW/4477221/s-s-milk-cans-locking-type-40-ltr--500x500.jpg",
      "onPress": MaterialPageRoute(builder: (context) => TopBar()),
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton.filled(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                PersistentNavBarNavigator.pushNewScreen(
                    withNavBar: false, context, screen: MainLoginScreen());
              },
              icon: Icon(Icons.logout))),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            width: AppWidth(context, 1),
            margin: EdgeInsets.all(2),
            padding: EdgeInsets.all(2),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200,
                  ),
                  width: AppWidth(context, 1),
                  height: 50,
                  child: InkWell(
                    splashColor: Colors.grey,
                    radius: 100,
                    onTap: () async {
                      // await checkInternetConnection(context).then((value) {
                      //   value
                      //       ? PersistentNavBarNavigator.pushNewScreen(context,
                      //           screen: Commodities())
                      //       // Navigator.push(
                      //       //     context,
                      //       //     MaterialPageRoute(
                      //       //         builder: (context) => SearchPage()))
                      //       : Globals().nointernet(context: context);
                      // });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded),
                          SizedBox(width: 10),
                          Text("Search on Cxt"),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "CXT Categories",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  width: AppWidth(context, 1),
                  height: AppHeight(context, 0.3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    // physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns
                      crossAxisSpacing: 2.0, // Spacing between columns
                      mainAxisSpacing: 2.0, // Spacing between rows
                    ),
                    itemCount: Categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          await checkInternetConnection(context).then((value) {
                            value
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Selection()))
                                : Globals().nointernet(context: context);
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey[500],
                              backgroundImage: NetworkImage(
                                Categories[index]["imageUrl"],
                              ),
                            ),
                            Text(
                              Categories[index]["name"],
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20), // Add some space between the sections
                Arrivals(),
                SizedBox(height: 20), // Add some space between the sections
                Deals(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Selection extends StatefulWidget {
  const Selection({super.key});

  @override
  State<Selection> createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: appbar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [TopBar(), popular(context), Arrivals()],
        ),
      ),
    );
  }
}


      // Container(
            //   width: double.infinity,
            //   height: 70,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 15.0),
            //     child: Center(
            //         child: Image.network(
            //       "https://kenyaseed.com/wp-content/uploads/2018/02/smaller-farmer.png",
            //       fit: BoxFit.cover,
            //     )),
            //   ),
            // ),
            // Expanded(
            //   child: Container(
            //     child: VerticalCardPager(
            //       textStyle: GoogleFonts.poppins(color: Colors.white),
            //       titles: champions.map((e) => e.name.toLowerCase()).toList(),
            //       images: champions
            //           .map((e) => Hero(
            //                 tag: e.name.toUpperCase(),
            //                 child: ClipRRect(
            //                   borderRadius: BorderRadius.circular(20.0),
            //                   child: Image.network(
            //                     e.imageUrl,
            //                     fit: BoxFit.cover,
            //                   ),
            //                 ),
            //               ))
            //           .toList(),
            //       onPageChanged: (page) {},
            //       onSelectedItem: (index) {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => DetailView(
            //                     champion: champions[index],
            //                   )),
            //         );
            //       },
            //     ),
            //   ),
            // ),
