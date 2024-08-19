// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:itx/fromWakulima/AddItem.dart';
import 'package:itx/fromWakulima/Analyitics.dart';
import 'package:itx/fromWakulima/AppBloc.dart';
import 'package:itx/fromWakulima/CartPage.dart';
import 'package:itx/fromWakulima/Offers.dart';
import 'package:itx/fromWakulima/Profile.dart';
import 'package:itx/fromWakulima/Sales.dart';
import 'package:itx/fromWakulima/contant.dart';
import 'package:itx/fromWakulima/globals.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late Timer timer;

  @override
  void initState() {
    // timer = Timer.periodic(Duration(seconds: 1), (_) {
    //   Globals().nointernet(context: context);
    // });

    // CherryToast.success(
    //   disableToastAnimation: false,
    //   animationCurve: Curves.ease,
    //   animationDuration: Duration(milliseconds: 500),
    //   title: Text('Success login',
    //       style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
    //   action: Text(
    //     "Logged in as ${FirebaseAuth.instance.currentUser?.email}",
    //     style: GoogleFonts.abel(fontWeight: FontWeight.w400),
    //   ),
    //   actionHandler: () {},
    //   onToastClosed: () {},
    // ).show(context);

    super.initState();
  }

  List<Widget> Screens = [
    Sales(),

    OrderAnalyticsPage(),
    AddOrderPage(),
    // Additem
    // Additem(),
    Offers(),
    // Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: 0,
            items: <Widget>[
              Icon(Icons.shopping_bag, size: 28),
              Icon(Icons.auto_graph, size: 28),
              Icon(Icons.add, size: 28),
              Icon(Icons.compare_arrows, size: 28),
              // Icon(Icons.perm_identity, size: 28),
            ],
            color: Colors.white,
            buttonBackgroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 600),
            onTap: (index) {
              setState(() {
                _page = index;
              });
            },
            letIndexChange: (index) => true,
          ),
          body: Screens[_page]

          //  Container(
          //   color: Colors.red,
          //   child: Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Text(_page.toString(), style: TextStyle(fontSize: 160)),
          //         ElevatedButton(
          //           child: Text('Go To Page of index 1'),
          //           onPressed: () {
          //             final CurvedNavigationBarState? navBarState =
          //                 _bottomNavigationKey.currentState;
          //             navBarState?.setPage(1);
          //           },
          //         )
          //       ],
          //     ),
          //   ),
          // ),

          // body: Center(
          //     child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     TextButton(
          //         onPressed: () {
          //           try {
          //             FirebaseAuth.instance.signOut();
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => LoginScreen()));
          //           } catch (e) {}
          //         },
          //         child: Text("Logout")),
          //     Text(
          //       "${FirebaseAuth.instance.currentUser?.email}",
          //       style: TextStyle(color: Colors.black, fontSize: 30),
          //     ),
          //   ],
          // )),

          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {},
          //   tooltip: 'Increment',
          //   child: const Icon(Icons.add),
          // ), // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }
}
