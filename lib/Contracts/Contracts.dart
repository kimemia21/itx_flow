import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Commodities.dart/AdvancedSearch.dart';
import 'package:itx/Contracts/Create.dart';
import 'package:itx/Contracts/MyContracts.dart';
import 'package:itx/authentication/Authorization.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:itx/global/SidePage.dart';
import 'package:itx/global/globals.dart';

class Contracts extends StatefulWidget {
  const Contracts({super.key});

  @override
  State<Contracts> createState() => _ContractsState();
}

class _ContractsState extends State<Contracts> {

int _currentIndex = 0;
late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  Widget searchItem({
    required String title,
    required String subtitle,
    required String price,
  }) {
    double width = Globals.AppWidth(context: context, width: 1);
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: width / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Text(
              price,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.teal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Globals.switchScreens(context: context, screen: CreateContract());

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Floating Action Button Pressed!')),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.green.shade600,
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Globals.switchScreens(
                context: context, screen: Authorization()),
            icon: Icon(Icons.arrow_back)),
        title: Text(
          "Contracts",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Globals.AppWidth(context: context, width: 0.7),
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
                    TextButton(
                        onPressed: () => Navigator.of(context).push(
                            SlideFromSidePageRoute(
                                widget: AdvancedSearchPage())),
                        child: Text(
                          "Advanced",
                          style: GoogleFonts.poppins(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        ))
                  ],
                ),
              ),
              searchItem(
                  title: "Category", subtitle: "sub category", price: "343"),
              searchItem(
                  title: "Category", subtitle: "sub category", price: "343"),
              searchItem(
                  title: "Category", subtitle: "sub category", price: "343"),
            ],
          ),
        ),
      ),
    );
  }
}


//    Widget build(BuildContext context) {
//     return MyScaffold(body:Container(
//         padding: EdgeInsets.all(10),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 margin: EdgeInsets.only(top: 10, bottom: 10),
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       width: Globals.AppWidth(context: context, width: 0.7),
//                       child: TextField(
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           labelText: 'Search commodities',
//                           prefixIcon: Icon(Icons.search),
//                           fillColor: Colors.grey[200],
//                           filled: true,
//                         ),
//                         onChanged: (text) {
//                           // You can add search functionality here if needed
//                         },
//                       ),
//                     ),
//                     TextButton(
//                         onPressed: () => Navigator.of(context).push(
//                             SlideFromSidePageRoute(
//                                 widget: AdvancedSearchPage())),
//                         child: Text(
//                           "Advanced",
//                           style: GoogleFonts.poppins(
//                               color: Colors.blue, fontWeight: FontWeight.w600),
//                         ))
//                   ],
//                 ),
//               ),
//               searchItem(
//                   title: "Category", subtitle: "sub category", price: "343"),
//               searchItem(
//                   title: "Category", subtitle: "sub category", price: "343"),
//               searchItem(
//                   title: "Category", subtitle: "sub category", price: "343"),
//             ],
//           ),
//         ),
//       ),title: "Contracts");
//   }
// }
