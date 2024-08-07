import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/Documents.dart';
import 'package:itx/authentication/Verification.dart';
import 'package:itx/global/globals.dart';

class Commodites extends StatefulWidget {
  const Commodites({super.key});

  @override
  State<Commodites> createState() => _CommoditesState();
}

class _CommoditesState extends State<Commodites> {
  final List<Map<String, dynamic>> commodities = [
    {'name': 'Copper', 'unit': '1,000 lbs', 'isChecked': false},
    {'name': 'Wheat', 'unit': '5,000 bu', 'isChecked': false},
    {'name': 'Gold', 'unit': '100 oz', 'isChecked': false},
    {'name': 'Crude Oil', 'unit': '1,000 bbl', 'isChecked': false},
    {'name': 'Soybeans', 'unit': '5,000 bu', 'isChecked': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Globals.switchScreens(context: context, screen: Verification());
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(

          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              child: Text("Add Commodities of interest",style: GoogleFonts.poppins(fontWeight: FontWeight.w600),),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                
                    borderRadius: BorderRadius.circular(10)
                  ),
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
            Expanded(
              child: ListView.builder(
                itemCount: commodities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    trailing: Checkbox(
                      value: commodities[index]['isChecked'] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          commodities[index]['isChecked'] = value!;
                        });
                      },
                    ),
                    title: Text(commodities[index]['name']!),
                    subtitle: Text(commodities[index]['unit']!),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap:()=>Globals.switchScreens(context: context,screen: DocumentsVerification()),
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.green.shade800,
                      borderRadius: BorderRadiusDirectional.circular(10)),
                  child: Text(
                    "Done",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ), 
            )

          ],

        ),
      ),
    );
  }
}
