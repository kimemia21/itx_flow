import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/Verification.dart';
import 'package:itx/global/globals.dart';

class Commodites extends StatefulWidget {
  const Commodites({super.key});

  @override
  State<Commodites> createState() => _CommoditesState();
}

class _CommoditesState extends State<Commodites> {
 final List<Map<String, String>> commodities = [
    {'name': 'Copper', 'unit': '1,000 lbs'},
    {'name': 'Wheat', 'unit': '5,000 bu'},
    {'name': 'Gold', 'unit': '100 oz'},
    {'name': 'Crude Oil', 'unit': '1,000 bbl'},
    {'name': 'Soybeans', 'unit': '5,000 bu'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>Globals.switchScreens(context: context,screen: Verification()), icon:Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search commodities',
                  prefixIcon: Icon(Icons.search),
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: commodities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    trailing: Checkbox(
                      value: false,
                      onChanged: (bool? value) {},
                    ),
                    title: Text(commodities[index]['name']!),
                    subtitle: Text(commodities[index]['unit']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}