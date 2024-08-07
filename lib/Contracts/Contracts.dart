import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/Authorization.dart';
import 'package:itx/global/globals.dart';

class Contracts extends StatefulWidget {
  const Contracts({super.key});

  @override
  State<Contracts> createState() => _ContractsState();
}

class _ContractsState extends State<Contracts> {
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
          // Add your onPressed code here!
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Floating Action Button Pressed!')),
          );
        },
        child: Icon(Icons.add,color:Colors.white,),
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
