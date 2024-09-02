import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/web/ContractsScreen.dart';

class TradeAuthorizationScreen extends StatefulWidget {
  @override
  _TradeAuthorizationScreenState createState() =>
      _TradeAuthorizationScreenState();
}

class _TradeAuthorizationScreenState extends State<TradeAuthorizationScreen> {
  String selectedDocument = 'Search...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar:
      // AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: Text('Global Exchange', style: TextStyle(color: Colors.black)),
      //   actions: [
      //     TextButton(child: Text('Home'), onPressed: () {}),
      //     TextButton(child: Text('Markets'), onPressed: () {}),
      //     TextButton(child: Text('Trade'), onPressed: () {}),
      //     TextButton(child: Text('Balances'), onPressed: () {}),
      //     TextButton(child: Text('Orders'), onPressed: () {}),
      //     IconButton(
      //         icon: Icon(Icons.notifications_none, color: Colors.black),
      //         onPressed: () {}),
      //     IconButton(
      //         icon: Icon(Icons.settings, color: Colors.black),
      //         onPressed: () {}),
      //     CircleAvatar(backgroundColor: Colors.grey[300], radius: 15),
      //   ],
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trade Authorization',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Step 1: Verify your identity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
                'Complete the form below to verify your identity. This is required to trade on Global Exchange.'),
            SizedBox(height: 20),
            _buildTextField('Commodity', 'copper, iron, etc'),
            SizedBox(height: 10),
            Text("Required Regulatory Document"),
            SizedBox(height: 10),
            _buildDropdown('Required Regulatory Document', selectedDocument,
                (String? newValue) {
              setState(() {
                selectedDocument = newValue!;
              });
            }),
            SizedBox(height: 10),

            _buildTextField('Date of Expiry', 'MM/DD/YYYY'),
            SizedBox(height: 10),
            _buildTextField('Document description', ''),
            SizedBox(height: 20),
            // ElevatedButton(
            //   child: Text('Next'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.green,
            //     minimumSize: Size(double.infinity, 50),
            //   ),
            //   onPressed: () {},
            // ),
            SizedBox(height: 30),
            Text('Step 2: Upload documents',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
                'Upload a photo of a government-issued ID, such as a driver\'s license or passport, and a selfie.'),
            SizedBox(height: 20),
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('assets/drivers_license.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.2,
              height: 30,
              child: ElevatedButton(
                child: Text(
                  'Next',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePageWeb(title: "title")));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hintText) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label, String value, void Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(label),
          onChanged: onChanged,
          items: <String>['Search...', 'Option 1', 'Option 2', 'Option 3']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
