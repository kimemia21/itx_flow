
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/fromWakulima/widgets/Detail_view.dart';
import 'package:itx/fromWakulima/widgets/contant.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:provider/provider.dart';

Widget popular(BuildContext context) {
  return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(AppWidth(context, 0.04))),
      margin: EdgeInsets.symmetric(
          horizontal: AppWidth(
        context,
        0.02,
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 10, top: 10),
              child: Text(
                "Popular",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              )),
          Container(
            height: AppHeight(context, 0.371),
            width: AppWidth(context, 1),
            child: ListView.builder(
                itemCount: context.watch<CurrentUserProvider>().list.length,
                physics: BouncingScrollPhysics(
                    parent: ScrollPhysics(),
                    decelerationRate: ScrollDecelerationRate.normal),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int Index) {
                  Map champion = {
                    "name": " item name",
                    "quality": "grade 1",
                    "quantitiy": "12 bags",
                    "price": "1000 per bag",
                    "description": "description text",
                    "deliveryDate": " 2 days",
                    "imageUrl": Agriculture,
                  };

                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Globals().raduis)),
                    margin: EdgeInsets.only(
                        left: AppWidth(context, 0.04),
                        right: AppWidth(context, 0.01),
                        top: AppWidth(context, 0.04),
                        bottom: AppWidth(context, 0.04)),
                    width: AppWidth(context, 0.45),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("this is pressed");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailView(
                                          champion: champion,
                                        )));
                            DetailView(champion: champion);
                          },
                          child: Column(
                            children: [
                              Globals().imagesEdges(
                                  context: context,
                                  image: context
                                      .watch<CurrentUserProvider>()
                                      .list[Index],
                                  height: 150.0,
                                  width: 150.0),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                child: Text(
                                  "Best Seller",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 13,
                                          color: Colors.blue.shade400)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: AppHeight(context, 0.002),
                                    horizontal: AppHeight(context, 0.005)),
                                child: Text(
                                  "Item$Index ",
                                  style: GoogleFonts.brunoAce(
                                      textStyle: TextStyle(
                                          fontSize: AppWidth(context, 0.045),
                                          color: Colors.black)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          child: Text(
                            " Price \$450",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 13, color: Colors.black)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(3),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                child: IconButton(
                                    onPressed: () {
                                      context
                                          .read<CurrentUserProvider>()
                                          .changeCartCount();
                                      cartItems.add(champion);
                                    },
                                    icon: Icon(
                                      CupertinoIcons.shopping_cart,
                                      color: Colors.white,
                                      size: 20,
                                    ))),
                          ],
                        )
                      ],
                    ),
                  );
                }),
          ),
        ],
      ));
}
