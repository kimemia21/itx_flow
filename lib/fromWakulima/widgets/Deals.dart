
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/fromWakulima/widgets/Detail_view.dart';
import 'package:itx/fromWakulima/widgets/contant.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Deals extends StatefulWidget {
  const Deals({super.key});

  @override
  State<Deals> createState() => _DealsState();
}

class _DealsState extends State<Deals> {
  int activeIndex = 0;
  final List<Map> testMap = [
    {
      "name": "kenyan coal",
      "description":
          " High-quality coal with excellent energy output, ideal for heating and industrial use. Low in impurities for a cleaner burn.",
      "price": "2300",
      "quality": "grade 1",
      "quantity": "bulk",
      "deliveryDate": "1 days",
      "imageUrl":
          ["https://5.imimg.com/data5/SELLER/Default/2023/6/318885244/LJ/VI/HC/3855896/charcoal-packing-paper-bags.png"],
    },
    {
      "name": "Gold Subukia",
      "description":
          " Investment-grade 24K gold bars, perfect for secure investments and wealth preservation. Pure and reliable quality",
      "price": "4000",
      "quality": "grade 1",
      "quantity": "bulk",
      "deliveryDate": "4 days",
      "imageUrl": ["https://pngimg.com/d/gold_PNG101019.png"],
    },
    {
      "name": "kericho tea",
      "description":
          "Refreshing and healthy organic green tea, rich in antioxidants. Perfect for a rejuvenating and calming experience",
      "price": "7800",
      "quality": "grade 1",
      "quantity": "bulk",
      "deliveryDate": "10 days",
      "imageUrl":["https://graefenhof-tee.de/wp-content/uploads/2022/02/Gra%CC%88fenhof-Tee-GmbH-BIONo-Plastic-Grafenhof-Tee-GmbH-v2-web.png"],
    },
    {
      "name": "milk kajiado",
      "description":
          "Pure and fresh dairy milk, rich in nutrients and ideal for daily consumption. Creamy taste with natural goodness.",
      "price": "7800",
      "quality": "grade 1",
      "quantity": "bulk",
      "deliveryDate": "1 days",
      "imageUrl":["https://5.imimg.com/data5/SELLER/Default/2021/8/AL/BB/PW/4477221/s-s-milk-cans-locking-type-40-ltr--500x500.jpg"]
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
      decoration:
          BoxDecoration(borderRadius: BorderRadiusDirectional.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.all(AppHeight(context, 0.01)),
            child: Text(
              "Today's Deals",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  textStyle: TextStyle(fontSize: AppHeight(context, 0.02))),
            ),
          ),
          Container(
            width: AppWidth(context, 1),
            height: AppHeight(context, 0.3),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: testMap.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print("PRESSED");
                      try {
                        Map champion = {
                          "name": testMap[index]["name"],
                          "quality": "grade 1",
                          "quantity": testMap[index]["quantity"],
                          "price": testMap[index]["price"],
                          "description": testMap[index]["description"],
                          "deliveryDate": testMap[index]["deliveryDate"],
                          "imageUrl":testMap[index]["imageUrl"],
                        };
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailView(champion: champion)));
                      } catch (e) {
                        print("Got tihs error in Arrivals.dart $e");
                      }
                    },
                    child: Globals().dealsCards(
                        context: context,
                        image: testMap[index]["imageUrl"][0],
                        description: testMap[index]["description"],
                        price: testMap[index]["price"]),
                  );
                }),
          )
        ],
      ),
    );
  }
}

Widget buildImage(
  context,
  String urlImage,
) {
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
                    "Nike Air Jordan 4",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    )),
                  ),
                ),
                Container(
                  child: Text(
                    "\$750",
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
