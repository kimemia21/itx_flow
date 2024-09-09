import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:badges/badges.dart' as badges;
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/fromWakulima/widgets/Homepage.dart';
import 'package:itx/fromWakulima/widgets/contant.dart';
import 'package:itx/global/globals.dart';
import 'package:provider/provider.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({super.key});

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Globals.switchScreens(
                    context: context, screen: MyHomePage(title: "homepage"));
              },
              icon: Icon(Icons.arrow_back)),
          centerTitle: true,
          title: Text(
            "My Cart",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
        ),
        body: cartItems.length < 1
            ? Center(
                child: Text("Cart is empty"),
              )
            : Container(
                height: AppHeight(context, 1),
                width: AppWidth(context, 1),
                child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return cartItem(
                          context: context,
                          image: cartItems[index]["imageUrl"],
                          name: cartItems[index]["name"],
                          price: cartItems[index]["price"]);
                    }),
              ));
  }
}
