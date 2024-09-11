import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:itx/Contracts/PurchaseConfirmationAlert.dart';

class Specificorder extends StatelessWidget {
  final String item;
  final double price;
  final String quantity;
  final String? companyName;
  final String? companyAddress;
  final String? companyContacts;
  final String? companyEmail;
  final String? companyId;

  Specificorder({
    required this.item,
    required this.quantity,
    required this.price,
    this.companyName,
    this.companyAddress,
    this.companyContacts,
    this.companyEmail,
    this.companyId
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
      body: SingleChildScrollView(
        child: Padding(
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
              ).animate().fadeIn(duration: 500.ms).slideX(),
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
                  ).animate().fadeIn(duration: 500.ms).scale(),
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
                  ).animate().fadeIn(duration: 500.ms).slideY(),
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
              ).animate().fadeIn(duration: 800.ms),
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
              ).animate().fadeIn(duration: 500.ms).slideX(),
              SizedBox(height: 20),
              if (companyName != null ||
                  companyAddress != null ||
                  companyContacts != null ||
                  companyEmail != null)
                buildCompanyInfo().animate().fadeIn(duration: 500.ms).slideY(),
              SizedBox(height: 20),
              Text(
                'Trade',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ).animate().fadeIn(duration: 500.ms).slideX(),
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
                      contactEmail: companyEmail ?? "support@example.com",
                      contactPhone: companyContacts ?? "+1 (555) 123-4567",
                    ),
                  );
                },
                child: buildTradeOption(
                    'Buy', 'Market execution', Icons.arrow_upward),
              ).animate().fadeIn(duration: 500.ms).scale(),
              SizedBox(height: 10),
            ],
          ),
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

  Widget buildCompanyInfo() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (companyName != null)
            Text(
              'Company: $companyName',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (companyAddress != null)
            Text(
              'Address: $companyAddress',
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
          if (companyContacts != null)
            Text(
              'Contacts: $companyContacts',
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
          if (companyEmail != null)
            Text(
              'Email: $companyEmail',
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}

// PurchaseConfirmationAlert class remains unchanged