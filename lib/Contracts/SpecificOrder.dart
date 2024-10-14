import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:itx/Contracts/ContLiveBid.dart';
import 'package:itx/global/NoAuthorized.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/payments/PayNow.dart';
import 'package:itx/payments/PurchaseConfirmationAlert.dart';
import 'package:itx/Serializers/ComTrades.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/Serializers/CommodityModel.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/uploadCerts/Regulator.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class Specificorder extends StatefulWidget {
  final ContractsModel contract;

  Specificorder({
    required this.contract,
  });

  @override
  _SpecificorderState createState() => _SpecificorderState();
}

class _SpecificorderState extends State<Specificorder> {
  Commodity? company;
  List<FlSpot> priceHistorySpots = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    if (widget.contract.commodityId != null) {
      fetchCompanyAndPriceHistory();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchCompanyAndPriceHistory() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      // Fetch commodity info
      final CommodityResponse response =
          await CommodityService.fetchCommodityInfo(
              context, int.parse(widget.contract.userCompanyId.toString()));

      // Handle the case where response or data is null or empty
      if (response != null) {
        setState(() {
          // Set company if data is not empty, otherwise null
          company = response.data.isNotEmpty ? response.data.first : null;

          // Handle empty price history and convert it to list of FlSpot
          if (response.priceHistory != null &&
              response.priceHistory.isNotEmpty) {
            priceHistorySpots = response.priceHistory
                .map((history) => FlSpot(
                      history.priceDate.millisecondsSinceEpoch.toDouble(),
                      history.price,
                    ))
                .toList();
          } else {
            priceHistorySpots =
                []; // Set empty if priceHistory is null or empty
          }

          isLoading = false; // Loading is complete
        });
      } else {
        // Handle case where response is null
        setState(() {
          company = null;
          priceHistorySpots = [];
          errorMessage = "No data available";
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle any errors and update the state accordingly
      setState(() {
        errorMessage = "Error loading data: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "${widget.contract.name}",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(),
                    SizedBox(height: 10),
                    buildGraph(),
                    SizedBox(height: 20),
                    buildCompanyInfoSection(),
                    SizedBox(height: 20),
                    buildTradeOptions(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildHeader() {
  double priceChange = calculatePriceChange();
  double percentageChange = calculatePercentageChange();
  bool isPositive = priceChange >= 0;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Contract Name
   Text("${widget.contract.name}",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600, // Bold for emphasis
              color: Colors.black54, // Strong color for focus
              shadows: [
                Shadow(
                  offset: Offset(0, 2), // Subtle shadow
                  blurRadius: 6.0,
                  color: Colors.grey.shade300, // Light shadow for depth
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).scale(curve: Curves.easeOutBack),
      
      const SizedBox(height: 8),

      // Grade Name
   Text(widget.contract.grade_name,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600, // Bold for emphasis
              color: Colors.black54, // Strong color for focus
              shadows: [
                Shadow(
                  offset: Offset(0, 2), // Subtle shadow
                  blurRadius: 6.0,
                  color: Colors.grey.shade300, // Light shadow for depth
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).scale(curve: Curves.easeOutBack),
      
      // Contract Description
      const SizedBox(height: 8),
       Text(widget.contract.description,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600, // Bold for emphasis
              color: Colors.black54, // Strong color for focus
              shadows: [
                Shadow(
                  offset: Offset(0, 2), // Subtle shadow
                  blurRadius: 6.0,
                  color: Colors.grey.shade300, // Light shadow for depth
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).scale(curve: Curves.easeOutBack),
      
      const SizedBox(height: 10),

      // Delivery Date
      Text(
        "Delivery date: ${DateFormat('MM/dd/yy').format(widget.contract.deliveryDate)}",
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ).animate().fadeIn(duration: 400.ms).slideX(curve: Curves.easeInOut),
      
      const SizedBox(height: 15),

      // Price and Percentage Change
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Price
          Text(
            '\$${widget.contract.price.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w700, // Bold for emphasis
              color: Colors.black, // Strong color for focus
              shadows: [
                Shadow(
                  offset: Offset(0, 2), // Subtle shadow
                  blurRadius: 6.0,
                  color: Colors.grey.shade300, // Light shadow for depth
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).scale(curve: Curves.easeOutBack),
          
          const SizedBox(width: 12),

          // Price Change & Percentage
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${isPositive ? '+' : ''}${priceChange.toStringAsFixed(2)} (${percentageChange.toStringAsFixed(2)}%)',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isPositive ? Colors.green.shade600 : Colors.red.shade600, // Accent based on value
                ),
              ),
              if (isPositive)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Price Increased',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.green.shade700,
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms).scale(),
              if (!isPositive)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Price Decreased',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade700,
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms).scale(),
            ],
          ).animate().fadeIn(duration: 500.ms).slideY(curve: Curves.easeIn),
        ],
      ),
      SizedBox(height: 5,),
       Text("${widget.contract.name}, Grade ${widget.contract.grade_name} Price History.",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600, // Bold for emphasis
              color: Colors.black54, // Strong color for focus
              shadows: [
                Shadow(
                  offset: Offset(0, 2), // Subtle shadow
                  blurRadius: 6.0,
                  color: Colors.grey.shade300, // Light shadow for depth
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).scale(curve: Curves.easeOutBack),
    ],
  );
}

  double calculatePriceChange() {
    if (priceHistorySpots.length < 2) return 0;
    return priceHistorySpots.last.y - priceHistorySpots.first.y;
  }

  double calculatePercentageChange() {
    if (priceHistorySpots.length < 2) return 0;
    double initialPrice = priceHistorySpots.first.y;
    double currentPrice = priceHistorySpots.last.y;
    return ((currentPrice - initialPrice) / initialPrice) * 100;
  }

  Widget buildGraph() {
    if (priceHistorySpots.isEmpty) {
      return Container(
        height: 200,
        child: Center(child: Text('No price history available')),
      );
    }

    final minX = priceHistorySpots.first.x;
    final maxX = priceHistorySpots.last.x;

    return Container(
      height: 250, // Increased height to accommodate x-axis labels
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) =>
                    bottomTitleWidgets(value, meta, minX, maxX),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 40,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey.withOpacity(0.5))),
          minX: minX,
          maxX: maxX,
          minY: priceHistorySpots
              .map((spot) => spot.y)
              .reduce((a, b) => a < b ? a : b),
          maxY: priceHistorySpots
              .map((spot) => spot.y)
              .reduce((a, b) => a > b ? a : b),
          lineBarsData: [
            LineChartBarData(
              spots: priceHistorySpots,
              isCurved: true,
              color: Colors.blue,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms);
  }

  Widget bottomTitleWidgets(
      double value, TitleMeta meta, double minX, double maxX) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    Widget text;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt());

    // Show 3 dates: start, middle, and end
    if (value == minX || value == maxX || value == (minX + maxX) / 2) {
      text = Text(DateFormat('MM/dd').format(dateTime), style: style);
    } else {
      text = const Text('');
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    return Text('\$${value.toStringAsFixed(2)}',
        style: style, textAlign: TextAlign.left);
  }

  Widget buildCompanyInfoSection() {
    if (errorMessage != null) {
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
        company!.companyName,
        company!.companyAddress,
        company!.companyContacts,
        company!.companyAddress,
      ).animate().fadeIn(duration: 500.ms).slideY();
    }
  }

  Widget buildTradeOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trade',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ).animate().fadeIn(duration: 500.ms).slideX(),
        SizedBox(height: 10),
        Visibility(
          visible: widget.contract!.canBid == 0,
          child: GestureDetector(
              onTap: () {
                final userType =
                    Provider.of<appBloc>(context, listen: false).user_type;
                print(userType);
                if (userType == "individual") {
                  print("true");
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: PaymentInfoForm(
                          contract: widget.contract,
                          contactEmail: "company.companyAddress",
                          contactPhone: "contactPhone",
                        ),
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: purchaseConfirmationAlert(
                          context: context,
                          contract: widget.contract,
                          contactEmail: "company.companyAddress",
                          contactPhone: "contactPhone",
                        ),
                      );
                    },
                  );
                }
              },
              child: buildTradeOption(
                  'Buy Now', 'Market execution', Icons.arrow_upward)),
        ),
        SizedBox(height: 10),
        Visibility(
          //  visible: randomNumber==0,
          visible: widget.contract.canBid == 1,

          child: GestureDetector(
              onTap: () async {
                try {
                  final authorStatus =
                      Provider.of<appBloc>(context, listen: false).isAuthorized;

                  if (authorStatus == "yes") {
                    PersistentNavBarNavigator.pushNewScreen(
                        withNavBar: true,
                        context,
                        screen: ContractLiveBid(contract: widget.contract));
                  } else {
                    showAuthorizationStatusAlert(context);
                  }
                } catch (e) {
                  print("error on specific order $e");
                }
              },
              child: buildTradeOption(
                  'Place bid', 'Market execution', Icons.arrow_upward)),
        ),
      ],
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
