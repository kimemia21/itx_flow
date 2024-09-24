import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Serializers/PriceHistory.dart';
import 'package:itx/fromWakulima/widgets/contant.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ContractLiveBid extends StatefulWidget {
  final int contractId;
  final String commodityname;
  const ContractLiveBid({Key? key, required this.contractId, required this.commodityname}) : super(key: key);

  @override
  _ContractLiveBidState createState() => _ContractLiveBidState();
}

class _ContractLiveBidState extends State<ContractLiveBid> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<PricehistoryModel>> _bidsFuture;
  double _highestBid = 0.0;
  List<ChartData> chartData = [];
  late DateTime auctionEndTime;
  Duration remainingTime = Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _bidsFuture = CommodityService.ContractsBids(context: context, id: widget.contractId);
    _updateData();
    _startTimer();
  }

  Future<void> _updateData() async {
    final data = await CommodityService.ContractsBids(context: context, id: widget.contractId);
    if (data.isNotEmpty) {
      data.sort((a, b) => b.bid_price.compareTo(a.bid_price));
      setState(() {
        _highestBid = data.first.bid_price;
        chartData = data.map((bid) => ChartData(DateTime.parse(bid.bid_date), bid.bid_price)).toList();
        chartData.sort((a, b) => a.date.compareTo(b.date));
      });
    }
  }

  void _startTimer() {
    auctionEndTime = DateTime.now().add(Duration(hours: 24));
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        remainingTime = auctionEndTime.difference(DateTime.now());
        if (remainingTime.isNegative) {
          timer?.cancel();
          remainingTime = Duration.zero;
        }
      });
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _bidsFuture = CommodityService.ContractsBids(context: context, id: widget.contractId);
    });
    await _updateData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void _showPlaceBidDialog(String itemName, double currentPrice, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double bidAmount = _highestBid;
        String? errorText;

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Place Bid for $itemName'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Current Highest Bid: \$${_highestBid.toStringAsFixed(2)}'),
                SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Your Bid',
                    errorText: errorText,
                  ),
                  onChanged: (value) {
                    double? newBid = double.tryParse(value);
                    if (newBid != null) {
                      if (newBid <= _highestBid) {
                        setState(() {
                          errorText = 'Bid must be higher than \$${_highestBid.toStringAsFixed(2)}';
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
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Place Bid'),
                onPressed: errorText == null
                    ? () {
                        if (bidAmount > _highestBid) {
                          final Map<String, dynamic> body = {
                            "order_price": bidAmount,
                            "order_type": "BUY"
                          };
                          CommodityService.PostBid(context, body, id);
                          Navigator.of(context).pop();
                          _refreshData();
                        }
                      }
                    : null,
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Live Auction',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                '${widget.commodityname} - 5,000',
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
                    '\$${   NumberFormat('#,##0.00').format(  _highestBid)}',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      Text('Last 30 Days'),
                      Text(
                        '\$${_highestBid.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: 150,
                child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(),
                  series: <LineSeries<ChartData, DateTime>>[
                    LineSeries<ChartData, DateTime>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.date,
                      yValueMapper: (ChartData data, _) => data.price,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _showPlaceBidDialog(widget.commodityname, _highestBid, widget.contractId),
                    child: Container(
                      padding: EdgeInsets.all(2),
                      alignment: Alignment.center,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: AppWidth(context, 0.3),
                      child: Text(
                        "Place bid",
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Remaining Time',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${remainingTime.inHours}:${(remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Highest Bid',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '\$${NumberFormat('#,##0.00').format(  _highestBid)}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<PricehistoryModel>>(
                  future: _bidsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: Colors.green.shade600));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}', style: GoogleFonts.poppins(color: Colors.red)));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No bids available', style: GoogleFonts.poppins(color: Colors.grey.shade600)));
                    } else {
                      final data = snapshot.data!;
                      data.sort((a, b) => b.bid_price.compareTo(a.bid_price));
                      final highestBid = data.first;
                      return Column(
                        children: [
                          _buildHighestBidCard(highestBid),
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) => _buildBidCard(context, data[index], isHighest: index == 0),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final DateTime date;
  final double price;

  ChartData(this.date, this.price);
}

Widget _buildHighestBidCard(PricehistoryModel bid) {
  return Card(
    elevation: 2,
    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    color: Colors.green.shade50,
    child: Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Highest Bid',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '\$${ NumberFormat('#,##0.00').format(bid.bid_price)}',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade900,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.star, color: Colors.amber),
              SizedBox(height: 4),
              Text(
                DateFormat('MMM d, y').format(DateTime.parse(bid.bid_date)),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildBidCard(BuildContext context, PricehistoryModel bid, {required bool isHighest}) {
  int userId = context.watch<appBloc>().user_id;
  return Container(
    height: 70,
    child: Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
          color: isHighest
              ? Colors.green.shade100
              : bid.user_id == userId
                  ? Colors.green.shade300
                  : Colors.grey.shade100,
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor:
                isHighest ? Colors.green.shade100 : Colors.grey.shade100,
            child: Icon(Icons.gavel,
                color:
                    isHighest ? Colors.green.shade700 : Colors.grey.shade700),
          ),
          title: Text(
            '\$${ NumberFormat('#,##0.00').format( bid.bid_price)}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isHighest ? Colors.green.shade700 : Colors.black87,
            ),
          ),
          subtitle: Text(
            DateFormat('MMM d, y - h:mm a')
                .format(DateTime.parse(bid.bid_date)),
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          trailing: isHighest
              ? Chip(
                  label: Text('Highest',
                      style: GoogleFonts.poppins(color: Colors.white)),
                  backgroundColor: Colors.green,
                )
              : null,
        ),
      ),
    ),
  );
}