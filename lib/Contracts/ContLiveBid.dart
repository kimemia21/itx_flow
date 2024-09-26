import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Contracts/TimeRemaining.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/Serializers/PriceHistory.dart';
import 'package:itx/fromWakulima/widgets/contant.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:timeago/timeago.dart' as timeago;

class ContractLiveBid extends StatefulWidget {
  final ContractsModel contract;

  const ContractLiveBid({super.key, required this.contract});

  @override
  _ContractLiveBidState createState() => _ContractLiveBidState();
}

class _ContractLiveBidState extends State<ContractLiveBid>
    with SingleTickerProviderStateMixin {
  late Future<List<PricehistoryModel>> _bidsFuture;
  double _highestBid = 0.0;
  List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    _bidsFuture = CommodityService.ContractsBids(
        context: context, id: widget.contract.contractId);
    _updateData();
  }

 Future _updateData() async {
  final data = await CommodityService.ContractsBids(
      context: context, id: widget.contract.commodityId);
  if (data.isNotEmpty) {
    data.sort((a, b) => b.bid_price.compareTo(a.bid_price));
    setState(() {
      _highestBid = data.first.bid_price;
      chartData = data
          .map(
              (bid) => ChartData(DateTime.parse(bid.bid_date), bid.bid_price))
          .toList();
      chartData.sort((a, b) => a.date.compareTo(b.date));
    });
  }
}

  Future<void> _refreshData() async {
    setState(() {
      _bidsFuture = CommodityService.ContractsBids(
          context: context, id: widget.contract.contractId);
    });
    await _updateData();
  }

  void _showPlaceBidDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      double bidAmount = _highestBid;
      String? errorText;
      final TextEditingController _bidController = TextEditingController();

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Place Bid for ${widget.contract.name}',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            content: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    elevation: 2,
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Current Highest Bid',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.blue[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '\$${NumberFormat('#,##0.00').format(_highestBid)}',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _bidController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Your Bid',
                      errorText: errorText,
                      prefixIcon: Icon(Icons.attach_money, color: Colors.green[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      double? newBid = double.tryParse(value);
                      if (newBid != null) {
                        if (newBid <= _highestBid) {
                          setState(() {
                            errorText = 'Bid must be higher than \$${NumberFormat('#,##0.00').format(_highestBid)}';
                          });
                        } else {
                          setState(() {
                            errorText = null;
                            bidAmount = newBid;
                          });
                        }
                      } else {
                        setState(() {
                          errorText = 'Please enter a valid number';
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Enter an amount higher than the current bid',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(color: Colors.grey[700]),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                child: Text(
                  'Place Bid',
                  style: GoogleFonts.poppins(

                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: errorText == null && _bidController.text.isNotEmpty
                    ? () {
                        if (bidAmount > _highestBid) {
                          final Map<String, dynamic> body = {
                            "order_price": bidAmount,
                            "order_type": "BUY"
                          };
                          CommodityService.PostBid(context, body, widget.contract.contractId);
                          Navigator.of(context).pop();
                          _refreshData();
                        }
                      }
                    : null,
              ),
            ],
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _refreshData();
        _updateData();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text(
            "Live Auction",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                _buildPriceChart(),
                Text(
                  widget.contract.name,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Item #${widget.contract.contractId}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPriceSection(),
                          SizedBox(height: 16),
                          _buildBidButton(),
                          SizedBox(height: 16),
                          _buildTimeRemaining(),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    // Expanded(
                    //   flex: 3,
                    //   child: _buildPriceChart(),
                    // ),
                  ],
                ),
                Text(
                  'Bid History',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                _buildBidHistory(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Highest bid:',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        Text(
          '\$${NumberFormat('#,##0.00').format(_highestBid)}',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
      ],
    );
  }

  Widget _buildBidButton() {
    return ElevatedButton(
      onPressed: _showPlaceBidDialog,
      child: Text(
        'Place Bid',
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildTimeRemaining() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time left:',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        TimeCounter(closeDate: widget.contract.closeDate),
      ],
    );
  }

  Widget _buildPriceChart() {
    return Container(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: DateTimeAxis(
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          numberFormat: NumberFormat.simpleCurrency(decimalDigits: 2),
        ),
        series: <LineSeries<ChartData, DateTime>>[
          LineSeries<ChartData, DateTime>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.date,
            yValueMapper: (ChartData data, _) => data.price,
            color: Colors.blue,
          )
        ],
      ),
    );
  }

  Widget _buildBidHistory() {
    return FutureBuilder<List<PricehistoryModel>>(
      future: _bidsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No bids available'));
        } else {
          final data = snapshot.data!;
          data.sort((a, b) => b.bid_price.compareTo(a.bid_price));
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) =>
                _buildBidCard(context, data[index], isHighest: index == 0),
          );
        }
      },
    );
  }

  Widget _buildBidCard(BuildContext context, PricehistoryModel bid,
      {required bool isHighest}) {
    int userId = context.watch<appBloc>().user_id;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isHighest ? Colors.green[100] : Colors.grey[100],
          child: Icon(
            Icons.gavel,
            color: isHighest ? Colors.green[700] : Colors.grey[700],
          ),
        ),
        title: Text(
          '\$${NumberFormat('#,##0.00').format(bid.bid_price)}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: isHighest ? Colors.green[700] : Colors.black87,
          ),
        ),
        subtitle: Text(
          DateFormat('MMM d, y - h:mm a').format(DateTime.parse(bid.bid_date)),
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: isHighest
            ? Chip(
                label: Text('Highest', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
              )
            : null,
      ),
    );
  }
}

class ChartData {
  final DateTime date;
  final double price;

  ChartData(this.date, this.price);
}
