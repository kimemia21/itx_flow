import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:intl/intl.dart';

class Specificorder extends StatelessWidget {
  final String item;
  final double price;
  final String quantity;
  // final String companyName;
  // final String companyAddress;
  // final String companyContacts;

  Specificorder({
    required this.item,
    required this.price,
    required this.quantity,
    // required this.companyName,
    // required this.companyAddress,
    // required this.companyContacts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
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
                  '\$${price.toStringAsFixed(2)}',
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
                showDialog(
                  context: context,
                  builder: (context) => PurchaseConfirmationAlert(
                    productName: item,
                    amount: price,
                    quantity: int.parse(quantity),
                    deliveryDate: DateTime.now().add(Duration(days: 7)),
                    contactEmail: "support@example.com",
                    contactPhone: "+1 (555) 123-4567",
                  ),
                );
              },
              child: buildTradeOption(
                  'Buy', 'Market execution', Icons.arrow_upward),
            ),
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
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 28),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                action,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue.shade900,
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
  final int quantity;
  final DateTime deliveryDate;
  final String contactEmail;
  final String contactPhone;

  const PurchaseConfirmationAlert({
    Key? key,
    required this.productName,
    required this.amount,
    required this.quantity,
    required this.deliveryDate,
    required this.contactEmail,
    required this.contactPhone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Confirm Your Purchase',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade800,
            ),
          ),
          SizedBox(height: 15),
          Text(
            productName,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Quantity: $quantity',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Text(
            'Total: \$${(amount * quantity).toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Delivery Date: ${DateFormat('MMM dd, yyyy').format(deliveryDate)}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 15),
          Divider(),
          SizedBox(height: 15),
          Text(
            'Contact Information',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Email: $contactEmail',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            'Phone: $contactPhone',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.red[400],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  CherryToast.success(
                    title: Text("Purchase Confirmed"),
                    description: Text(
                      'You will receive an invoice via email within 10 days.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    animationType: AnimationType.fromRight,
                    animationDuration: Duration(milliseconds: 1000),
                    autoDismiss: true,
                  ).show(context);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  "Confirm Purchase",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
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
