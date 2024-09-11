import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:itx/Contracts/PurchaseConfirmationAlert.dart';
import 'package:itx/Serializers/CompanySerializer.dart';
import 'package:itx/requests/HomepageRequest.dart';

class Specificorder extends StatefulWidget {
  final String item;
  final double price;
  final String quantity;
  final String? companyName;
  final String? companyAddress;
  final String? companyContacts;
  final String? companyEmail;
  final String companyId;

  Specificorder({
    required this.item,
    required this.quantity,
    required this.price,
    this.companyName,
    this.companyAddress,
    this.companyContacts,
    this.companyEmail,
    required this.companyId,
  });

  @override
  _SpecificorderState createState() => _SpecificorderState();
}

class _SpecificorderState extends State<Specificorder> {
  CompanyModel? company;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.companyId != null) {
    
      fetchCompany();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchCompany() async {
    try {
      CompanyModel? fetchedCompany = await CommodityService.getCompany(
        context: context,
        id: widget.companyId!,
      );

      setState(() {
        if (fetchedCompany != null) {
          company = fetchedCompany;
       
        } else {
          errorMessage = "Company data not available";
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error loading company data: $e";
        isLoading = false;
      });
    
    }
  }

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
                widget.item,
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
                    '\$${widget.price.toStringAsFixed(2)}',
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
              buildCompanyInfoSection(),
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
                      productName: widget.item,
                      amount: widget.price,
                      quantity: int.parse(widget.quantity),
                      deliveryDate: DateTime.now().add(Duration(days: 7)),
                      contactEmail: company?.companyAddress ??
                          widget.companyEmail ??
                          "support@example.com",
                      contactPhone: company?.companyContacts ??
                          widget.companyContacts ??
                          "+1 (555) 123-4567",
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

  Widget buildCompanyInfoSection() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      return Text(
        errorMessage!,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.red,
        ),
      );
    } else if (company != null) {
      return buildCompanyInfo(
        company!.companyName,
        company!.companyAddress,
        company!.companyContacts,
        company!.companyAddress,
      ).animate().fadeIn(duration: 500.ms).slideY();
    } else {
      return buildCompanyInfo(
        widget.companyName,
        widget.companyAddress,
        widget.companyContacts,
        widget.companyEmail,
      ).animate().fadeIn(duration: 500.ms).slideY();
    }
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

  Widget buildCompanyInfo(
      String? name, String? address, String? contacts, String? email) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (name != null)
            Text(
              'Company: $name',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (address != null)
            Text(
              'Address: $address',
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
          if (contacts != null)
            Text(
              'Contacts: $contacts',
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
          if (email != null)
            Text(
              'Email: $email',
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}
