import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:itx/Contracts/ContLiveBid.dart';
import 'package:itx/Serializers/Reasons.dart';
import 'package:itx/chatbox/ChatBox.dart';
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
  final bool isWarehouse;

  Specificorder({required this.contract, required this.isWarehouse});

  @override
  _SpecificorderState createState() => _SpecificorderState();
}

class _SpecificorderState extends State<Specificorder> {
  Commodity? company;
  List<FlSpot> priceHistorySpots = [];
  bool isLoading = true;
  String? errorMessage;
  String? selectedReason;
  TextEditingController _otherReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (!widget.isWarehouse && widget.contract.commodityId != null) {
      fetchCompanyAndPriceHistory();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchCompanyAndPriceHistory() async {
    if (widget.isWarehouse) return;

    setState(() {
      isLoading = true;
    });

    try {
      final CommodityResponse response =
          await CommodityService.fetchCommodityInfo(
              context, int.parse(widget.contract.userCompanyId.toString()));

      if (response != null) {
        setState(() {
          company = response.data.isNotEmpty ? response.data.first : null;

          if (response.priceHistory != null &&
              response.priceHistory.isNotEmpty) {
            priceHistorySpots = response.priceHistory
                .map((history) => FlSpot(
                      history.priceDate.millisecondsSinceEpoch.toDouble(),
                      history.price,
                    ))
                .toList();
          } else {
            priceHistorySpots = [];
          }
          isLoading = false;
        });
      } else {
        setState(() {
          company = null;
          priceHistorySpots = [];
          errorMessage = "No data available";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error loading data: $e";
        isLoading = false;
      });
    }
  }

  Widget buildWarehouseInfo() {
    final _status = widget.contract.warehouse_status;
    final warehouseStatus = _status == 0
        ? "recieved with issues"
        : _status == 1
            ? "Good"
            : 'not recieved';

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Status Card
      _buildStatusBanner(),
      SizedBox(height: 20),
      Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.person),
                        Text(
                          widget.contract.contract_user!,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: ChatScreen(model: widget.contract));
                      // showWarehouseStatusAlert(context);
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              _getStatusColor(warehouseStatus).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(warehouseStatus),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.message,
                          size: 30,
                        )).animate().fadeIn(duration: 600.ms).scale(),
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms).slideY(),
              if (widget.contract.warehouse_status_message != null) ...[
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.message_outlined,
                        color: Colors.green.shade700,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.contract.warehouse_status_message!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 800.ms).slideX(),
              ],

              SizedBox(height: 20),

              // Details Grid
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.5,
                children: [
                  _buildDetailCard(
                    'Contract Type',
                    widget.contract.contractType,
                    Icons.description_outlined,
                    Colors.blue,
                  ),
                  _buildDetailCard(
                    'Packing',
                    widget.contract.contract_packing ?? 'N/A',
                    Icons.inventory_2_outlined,
                    Colors.orange,
                  ),
                  _buildDetailCard(
                    'Producer',
                    widget.contract.contract_user ?? 'N/A',
                    Icons.person_outline,
                    Colors.purple,
                  ),
                  _buildDetailCard(
                    'Contract ID',
                    '#${widget.contract.contractId}',
                    Icons.warehouse_outlined,
                    Colors.green,
                  ),
                ],
              ).animate().fadeIn(duration: 800.ms),

              SizedBox(height: 20),

              // Additional Info
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Information',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 15),
                    _buildInfoRow(
                      'Delivery Date',
                      DateFormat('MMM dd, yyyy')
                          .format(widget.contract.deliveryDate),
                      Icons.calendar_today_outlined,
                    ),
                    SizedBox(height: 12),
                    _buildInfoRow(
                      'Price',
                      '\$${widget.contract.price.toStringAsFixed(2)}',
                      Icons.attach_money,
                    ),
                    SizedBox(height: 12),
                    _buildInfoRow(
                      'Grade',
                      widget.contract.grade_name,
                      Icons.grade_outlined,
                    ),
               
                  ],
                ),
              ).animate().fadeIn(duration: 1000.ms).slideY(),
            ],
          ))
    ]);
  }

  Widget _buildDetailCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey.shade600,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "0":
        return Colors.red.shade600;
      case 'null':
        return Colors.orange.shade600;
      case '1':
        return Colors.green.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  Widget _buildStatusBanner() {
    final status = widget.contract.warehouse_status;
    final warehouseStatus = status == 0
        ? "recieved with issues"
        : status == 1
            ? "Good"
            : 'not recieved';

    late String message;
    late Color backgroundColor;
    late Color textColor;
    late IconData icon;
    late String subMessage;

    if (status == 1) {
      print("contact status is $status");
      message = "Successfully Received";
      backgroundColor = Colors.green.shade50;
      textColor = Colors.green.shade700;
      icon = Icons.check_circle_rounded;
      subMessage = "This contract has been received and verified";
    } else if (status == 0) {
      message = "Reception Failed";
      backgroundColor = Colors.red.shade50;
      textColor = Colors.red.shade700;
      icon = Icons.error_rounded;
      subMessage = widget.contract.warehouse_status_message ??
          "There was an issue with receiving your commodity";
    } else {
      message = "Awaiting Reception";
      backgroundColor = Colors.orange.shade50;
      textColor = Colors.orange.shade700;
      icon = Icons.hourglass_empty_rounded;
      subMessage = "This contract has not yet been received by the warehouse";
    }

    return GestureDetector

  (
    onTap: (){
        showWarehouseStatusAlert(context);
    },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: textColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: textColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: textColor,
                size: 30,
              ),
            ).animate().fadeIn(duration: 600.ms).scale(),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideX(),
                  SizedBox(height: 5),
                  Text(
                    subMessage,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: textColor.withOpacity(0.8),
                    ),
                  ).animate().fadeIn(duration: 1000.ms).slideX(),
                  SizedBox(height: 5),
                    Text(
                    "Goods Status  :  $warehouseStatus",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideX(),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Click to  Change Goods Status", style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: textColor.withOpacity(0.8))).
          animate().fadeIn(duration: 600.ms).scale(),
                    ],
                  ).animate().fadeIn(duration: 500.ms).slideY(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

// Helper method to get status-specific animations
  Widget _getStatusAnimation(Widget child, String status) {
    if (status == "1") {
      return child
          .animate()
          .fadeIn(duration: 500.ms)
          .scale(curve: Curves.elasticOut);
    } else if (status == "0") {
      return child.animate().fadeIn(duration: 500.ms).shake(duration: 500.ms);
    } else {
      return child.animate().fadeIn(duration: 500.ms).slideX();
    }
  }

// Update the color helper method

  @override
  Widget build(BuildContext context) {
    int bloc = Provider.of<appBloc>(context, listen: false).user_type;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.contract.name,
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
                    !widget.isWarehouse
                        ? buildHeader()
                        : SizedBox(
                            height: 1,
                          ),
                    SizedBox(height: 10),
                    if (!widget.isWarehouse) ...[
                      buildGraph(),
                      SizedBox(height: 20),
                      buildCompanyInfoSection(),
                    ],
                    if (widget.isWarehouse) buildWarehouseInfo(),
                    SizedBox(height: 20),
                    Visibility(
                      visible: !widget.isWarehouse,
                      child: buildTradeOptions(),
                    ),
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
        Text(
          "${widget.contract.name}",
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
        Text(
          widget.contract.grade_name,
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
        Text(
          widget.contract.description,
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
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(curve: Curves.easeOutBack),

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
                    color: isPositive
                        ? Colors.green.shade600
                        : Colors.red.shade600, // Accent based on value
                  ),
                ),
                if (isPositive)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        SizedBox(
          height: 5,
        ),
        Text(
          "${widget.contract.name}, Grade ${widget.contract.grade_name} Price History.",
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
    int userType = Provider.of<appBloc>(context, listen: false).user_type;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ).animate().fadeIn(duration: 500.ms).slideX(),
        SizedBox(height: 10),
        Visibility(
          visible:
              widget.contract.canBid == 0 || userType != 4 || userType != 6,
          child: GestureDetector(
              onTap: () {
                // print(userType);

                if (userType == 3) {
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
              child: TradeOption(
                  'Buy Now', 'Market execution', Icons.arrow_upward)),
        ),
        SizedBox(height: 10),
        Visibility(
          //  visible: randomNumber==0,
          visible: widget.contract.canBid == 1 && !widget.isWarehouse,

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
              child: TradeOption(
                  'Place bid', 'Market execution', Icons.arrow_upward)),
        ),
      ],
    );
  }

  Widget TradeOption(String action, String description, IconData icon) {
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

  void showWarehouseStatusAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warehouse_rounded, color: Colors.blue),
              SizedBox(width: 10),
              Text('Change Delivery Status'),
            ],
          ),
          content: Text('Are you confortable  with the goods status'),
          actions: [
            Visibility(
              visible: widget.contract.warehouse_status != 1,
              child: TextButton.icon(
                icon: Icon(Icons.close, color: Colors.red),
                label: Text('No', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  // Handle not received
                  Navigator.of(context).pop();
                  _showReasonBottomSheet();
                },
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.check, color: Colors.green),
              label: Text('Yes', style: TextStyle(color: Colors.green)),
              onPressed: () async {
                final Map<String, dynamic> body = {
                  "contract_id:": widget.contract.contractId,
                  "status": "1",
                  "reason": "Recieved",
                };

                await CommodityService.PostReasons(
                    context, body, widget.contract.contractId);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showReasonBottomSheet() {
    return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Title
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Why wasn\'t the contract received?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Reasons list
                FutureBuilder<List<Reasons>>(
                    future: CommodityService.wareHouseReasons(context: context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No reasons available'));
                      }
                      final reasons = snapshot.data!;

                      return Expanded(
                        child: ListView.builder(
                          itemCount: reasons.length,
                          itemBuilder: (context, index) {
                            final reason = reasons[index];
                            final isSelected = selectedReason == reason.title;

                            return Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      selectedReason = reason.title;
                                      if (selectedReason != 'Other') {
                                        _otherReasonController.clear();
                                      }
                                    });
                                    //id of the contract,
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    color: isSelected
                                        ? Colors.green.shade300.withOpacity(0.1)
                                        : null,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            reason.icon,
                                            color: Colors.green.shade300,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                reason.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                reason.subtitle,
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isSelected)
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.green.shade300,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Show TextField when "Other" is selected
                                if (isSelected && reason.title == 'Other')
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: TextField(
                                      controller: _otherReasonController,
                                      decoration: InputDecoration(
                                        hintText: 'Please describe the reason',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                      ),
                                      maxLines: 3,
                                      onChanged: (_) => setState(
                                          () {}), // Trigger rebuild to update button state
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      );
                    }),
                // Submit button
                Container(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade300,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: selectedReason == null ||
                            (selectedReason == 'Other' &&
                                _otherReasonController.text.trim().isEmpty)
                        ? null
                        : () async {
                            final finalReason = selectedReason == 'Other'
                                ? _otherReasonController.text.trim()
                                : selectedReason;
                            print('Selected reason: $finalReason');

                            final Map<String, dynamic> body = {
                              "contract_id:": widget.contract.contractId,
                              "status": "0",
                              "reason": selectedReason,
                            };

                            await CommodityService.PostReasons(
                                context, body, widget.contract.contractId);

                            // selectedReason = null;
                            // _otherReasonController.clear();
                          },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon() {
    if (!widget.isWarehouse) {
      return Icons.favorite;
    } else if (widget.isWarehouse) {
      return Icons.check;
    } else if (!!widget.isWarehouse) {
      return Icons.favorite_border;
    } else {
      return Icons.cancel;
    }
  }

  Color _getIconColor() {
    if (!widget.isWarehouse) {
      return Colors.red;
    } else if (!!widget.isWarehouse) {
      return Colors.grey;
    } else if (widget.isWarehouse) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}
