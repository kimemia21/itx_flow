
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/fromWakulima/AppBloc.dart';
import 'package:itx/fromWakulima/Detail_view.dart';
import 'package:itx/fromWakulima/contant.dart';
import 'package:itx/fromWakulima/globals.dart';
import 'package:provider/provider.dart';

class Alllisting extends StatefulWidget {
  const Alllisting({super.key});

  @override
  State<Alllisting> createState() => _AlllistingState();
}

class _AlllistingState extends State<Alllisting> {
  final Map<String, dynamic> champion = {
    "name": " item name",
    "quality": "grade 1",
    "quantity": "12 bags",
    "price": "1000 per bag",
    "description": "description text",
    "deliveryDate": " 2 days",
    "imageUrl": Agriculture,
  };

  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    print("----------------------building----------------------------");
    return Container(
      margin: EdgeInsets.only(top: 15),
      width: AppWidth(context, 1),
      // height: AppHeight(context, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () => setState(() {
                          isGrid = true;
                        }),
                    icon: Icon(Icons.grid_4x4_rounded)),
                IconButton(
                    onPressed: () => setState(() {
                          isGrid = false;
                        }),
                    icon: Icon(Icons.list_outlined))
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Wrap(
                spacing: 4,
                runSpacing: 10,
                children: List.generate(all.length, (index) {
                  return _buildGridItem(context, index);
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    return Container(
      width: isGrid
          ? MediaQuery.of(context).size.width / 3 - 4
          : AppWidth(context, 1),
      height: 220, // Divide width by 3 and subtract spacing
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Globals().raduis),
      ),
      margin: EdgeInsets.only(bottom: 10),
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
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Globals().imagesEdges(
                  context: context,
                  image: Agriculture[3],
                  height: 100.0,
                  width: double.infinity,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  child: Text(
                    "Best Seller",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade400,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "Item$index ",
                    style: GoogleFonts.brunoAce(
                      textStyle: TextStyle(
                        fontSize: AppWidth(context, 0.045),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Text(
              " Price \$450",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Spacer(),
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
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    context.read<CurrentUserProvider>().changeCartCount();
                    cartItems.add(champion);
                  },
                  icon: Icon(
                    CupertinoIcons.shopping_cart,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
