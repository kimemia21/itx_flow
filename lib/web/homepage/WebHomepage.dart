import 'package:flutter/material.dart';

import 'package:itx/global/appbar.dart';
import 'package:itx/web/homepage/HomeContract.dart';
import 'package:itx/web/homepage/HomeOrders.dart';
class WebHomePage extends StatefulWidget {
  const WebHomePage({super.key});

  @override
  State createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  bool orderIsEmpty = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    //  appBar: ITXAppBar(),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure Row children don't stretch vertically
          children: [
            // Bounded height example using SizedBox
            Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadiusDirectional.circular(20)
              ),
              width: MediaQuery.of(context).size.width * 0.55,
              child: WebHomepageContracts(),
            ),
            Container(
              
              margin: EdgeInsets.all(2),
              width: MediaQuery.of(context).size.width * 0.35,

              child: WebHomePageOrders(onOrderCountChanged: (onOrderCountChanged) {}),
            ),
          ],
        ),
      ),
    );
  }
}
