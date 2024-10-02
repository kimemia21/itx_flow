import 'dart:math';


import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/fromWakulima/widgets/Detail_view.dart';
import 'package:itx/fromWakulima/widgets/contant.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Arrivals extends StatefulWidget {
  const Arrivals({super.key});

  @override
  State<Arrivals> createState() => _ArrivalsState();
}

class _ArrivalsState extends State<Arrivals> {
  int activeIndex = 0;

  final List<Map> imageUrl = [
    {
      "imageUrl": [Agriculture[1]],
      "price": "34400"
    },
    {
      "imageUrl": [all[1]],
      "price": "45400"
    },
    {
      "imageUrl": [Agriculture[1]],
      "price": "60400"
    },
    {
      "imageUrl": [mining[2]],
      "price": "30000"
    }
  ];

  Widget buildIndicator() => Container(
        margin:
            EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.025),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSmoothIndicator(
                effect: ExpandingDotsEffect(
                    paintStyle: PaintingStyle.fill,
                    dotWidth: MediaQuery.of(context).size.width * 0.04,
                    dotHeight: MediaQuery.of(context).size.height * 0.0039,
                    activeDotColor: Colors.black),
                activeIndex: activeIndex,
                count: context.watch<CurrentUserProvider>().list.length),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: AppHeight(context, 0.1),
      width: AppWidth(context, 1),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadiusDirectional.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.all(AppHeight(context, 0.01)),
            child: Text(
              "New Commodities",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  textStyle: TextStyle(fontSize: AppHeight(context, 0.02))),
            ),
          ),
          Container(
            height: AppHeight(context, 0.2),
            width: AppWidth(context, 1),
            child: CarouselSlider.builder(
                itemCount: imageUrl.length,
                itemBuilder: (context, index, realindex) {
                  return GestureDetector(
                      onTap: () {
                        print("PRESSED");
                        try {
                          Random id = Random();
                          Map champion = {
                            "id": id,
                            "name": " Arrivals",
                            "quality": "grade 1",
                            "quantitiy": "Available",
                            "price": "1000 per bag",
                            "description": "description text",
                            "deliveryDate": " 2 days",
                            "imageUrl": imageUrl[index]["imageUrl"],
                          };
                          print(
                              "----------$index-------------------${imageUrl[index]["imageUrl"]}---------------------------");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailView(champion: champion)));
                        } catch (e) {
                          print("Got this error in Arrivals.dart $e");
                        }
                      },
                      child: Container(
                          child: buildImage(
                              context,
                              imageUrl[index]["imageUrl"][0],
                              imageUrl[index]["price"])));
                },
                options: CarouselOptions(
                    onPageChanged: (index, reason) =>
                        setState(() => activeIndex = index),
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 2),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.ease,
                    height: MediaQuery.of(context).size.height * 0.5)),
          ),
          SizedBox(
            height: 10,
          ),
          buildIndicator(),
        ],
      ),
    );
  }
}

Widget buildImage(context, String urlImage, String price) {
  return Container(
    width: AppWidth(context, 0.8),
    margin: EdgeInsets.symmetric(
        horizontal: AppWidth(context, 0.005),
        vertical: AppWidth(context, 0.005)),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppHeight(context, 0.02))),
    child: Container(
      padding: EdgeInsets.all(AppWidth(context, 0.02)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: AppWidth(context, 0.02)),
            padding: EdgeInsets.only(top: AppHeight(context, 0.02)),
            // width: AppWidth(context, 0.37),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "Best Choice",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontSize: AppWidth(context, 0.04),
                      color: Colors.blue[300],
                    )),
                  ),
                ),
                Container(
                  child: Text(
                    "item name placeHolder",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    )),
                  ),
                ),
                Container(
                  child: Text(
                    "Kshs $price",
                    style: GoogleFonts.abel(
                        textStyle: TextStyle(
                      fontSize: AppWidth(context, 0.04),
                      color: Colors.black,
                    )),
                  ),
                ),
              ],
            ),
          ),
          Globals().imagesEdges(
              context: context, image: urlImage, height: 100.0, width: 120.0)
        ],
      ),
    ),
  );
}
