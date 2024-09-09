import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/Contracts/CreateContract.dart';
import 'package:itx/Contracts/LiveAuction.dart';
import 'package:itx/Contracts/MyContracts.dart';
import 'package:itx/Contracts/itemLive.dart';
import 'package:itx/global/globals.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:cherry_toast/cherry_toast.dart';

class Specificorder extends StatelessWidget {
  final String item;
  final double price;
  final String quantity;
  Specificorder(
      {required this.item, required this.price, required this.quantity});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: Globals.leading(context: context, screen: Mycontracts()),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  price.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1D +0.20%',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 1.5),
                        FlSpot(2, 1.4),
                        FlSpot(3, 3.4),
                        FlSpot(4, 2),
                        FlSpot(5, 2.2),
                        FlSpot(6, 1.8),
                      ],
                      isCurved: true,
                      // colors: [Colors.brown],
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildTimePeriodButton('1D', true),
                buildTimePeriodButton('1W', false),
                buildTimePeriodButton('1M', false),
                buildTimePeriodButton('3M', false),
                buildTimePeriodButton('1Y', false),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Trade',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
                onTap: () {
                  print("pressed");
                  showDialog(
                      context: context,
                      builder: (context) => PurchaseConfirmationAlert(
                          productName: item, amount: price));

                  // List<Map<String, dynamic>> itemData = [
                  //   {
                  //     'name': item,
                  //     'price': price as double,
                  //     'unit': 'lbs',
                  //     'endTime': DateTime.now().add(Duration(minutes: 45))
                  //   },
                  // ];
                  // PersistentNavBarNavigator.pushNewScreen(
                  //     withNavBar: true,
                  //     context,
                  //     screen: Itemlive(
                  //       itemData: itemData,
                  //     ));
                },
                child: buildTradeOption(
                    'Buy', 'Market execution', Icons.arrow_upward)),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildTimePeriodButton(String label, bool isSelected) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        color: isSelected ? Colors.black : Colors.grey,
      ),
    );
  }

  Widget buildTradeOption(String action, String description, IconData icon) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                action,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PurchaseConfirmationAlert extends StatelessWidget {
  final String productName;
  final double amount;
  // final VoidCallback onConfirm;
  // final VoidCallback onCancel;

  const PurchaseConfirmationAlert({
    Key? key,
    required this.productName,
    required this.amount,
    // required this.onConfirm,
    // required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.grey[50],
      title: Text(
        'Confirm Your Purchase',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
      content: Container(
        constraints: BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are about to buy:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              productName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Price: \$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Pay before 10 days to receive an invoice to your email',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
          onPressed: () {
            CherryToast.success(
                    description: Text(
                      'Paid before 10 days  to receive an invoice to your email',
                      style: GoogleFonts.poppins(

                        fontSize: 14,
                  
                        color: Colors.grey[600],
                      ),
                    ),
                    animationType: AnimationType.fromRight,
                    animationDuration: Duration(milliseconds: 1000),
                    autoDismiss: true)
                .show(context);
            Navigator.pop(context);
          },
          // onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            'Yes, Buy Now',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
          ],
        ),
        
      ],
    );
  }
}
