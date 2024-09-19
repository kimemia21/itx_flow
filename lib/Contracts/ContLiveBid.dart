import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Serializers/PriceHistory.dart';
import 'package:itx/fromWakulima/widgets/contant.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ContractLiveBid extends StatefulWidget {
  final int contractId;
  final String commodityname;
  const ContractLiveBid(
      {super.key, required this.contractId, required this.commodityname});

  @override
  _ContractLiveBidState createState() => _ContractLiveBidState();
}

class _ContractLiveBidState extends State<ContractLiveBid>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<PricehistoryModel>> _bidsFuture;
  // DateTime? _selectedDateTime;

  double _highestBid = 0.0;

  // Add a new variable to store the chart data
  List<ChartData> chartData = [];

  // Add a variable to store the remaining time
  late DateTime auctionEndTime;
  Duration remainingTime = Duration();
  Timer? timer;
  void initState() {
    super.initState();
    _bidsFuture =
        CommodityService.ContractsBids(context: context, id: widget.contractId);
    _updateHighestBid();
  }
  



Future<void> _updateHighestBid() async {
    final data = await CommodityService.ContractsBids(context: context, id: widget.contractId);
    if (data.isNotEmpty) {
      data.sort((a, b) => b.bid_price.compareTo(a.bid_price));
      setState(() {
        _highestBid = data.first.bid_price;
      });
    }
  }


    Future<void> _refreshData() async {
    setState(() {
      _bidsFuture = CommodityService.ContractsBids(context: context, id: widget.contractId);
    });
    await _updateHighestBid();
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        remainingTime = auctionEndTime.difference(DateTime.now());
        if (remainingTime.isNegative) {
          timer?.cancel();
          remainingTime = Duration(seconds: 0);
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void _showPlaceBidDialog(String itemName, double currentPrice) {
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
                Text(
                    'Current Highest Bid: \$${_highestBid.toStringAsFixed(2)}'),
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
                          errorText =
                              'Bid must be higher than \$${_highestBid.toStringAsFixed(2)}';
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
                          final now = DateTime.now();
                          // this.setState(() {
                          //   _highestBid = bidAmount;
                          //   bidsHistory.add({
                          //     'user': 'You',
                          //     'time': now,
                          //     'amount': bidAmount,
                          //   });
                          //   chartData.add(ChartData(now, bidAmount));
                          // });
                          Navigator.of(context).pop();
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
      onRefresh:_refreshData,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Live Action',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
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
                    '\$${_highestBid}',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      Text('Last 30 Days'),
                      Text(
                        '$_highestBid ',
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
      
              // Place Bid Button, Timer, and Highest Bid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () =>
                        _showPlaceBidDialog(widget.commodityname, _highestBid),
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
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
      
                  // Remaining Time Display
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Remaining Time',
                        style:
                            TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${remainingTime.inHours}:${(remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
      
                  // Highest Bid Display
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Highest Bid',
                        style:
                            TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '\$${_highestBid.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
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
                      return Center(
                        child: CircularProgressIndicator(
                            color: Colors.green.shade600),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No bids available',
                          style: GoogleFonts.poppins(color: Colors.grey.shade600),
                        ),
                      );
                    } else {
                      final data = snapshot.data!;
                      // Sort the bids by price in descending order
                      data.sort((a, b) => b.bid_price.compareTo(a.bid_price));
                      final highestBid = data.first;
                   
      
                      return Column(
                        children: [
                          _buildHighestBidCard(highestBid),
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final bid = data[index];
                                return _buildBidCard(bid, isHighest: index == 0);
                              },
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
                '\$${bid.bid_price.toStringAsFixed(2)}',
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

Widget _buildBidCard(PricehistoryModel bid, {required bool isHighest}) {
  return Container(
    height: 70,
    child: Card(
   
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isHighest ? Colors.green.shade100 : Colors.grey.shade100,
          child: Icon(Icons.gavel,
              color: isHighest ? Colors.green.shade700 : Colors.grey.shade700),
        ),
        title: Text(
          '\$${bid.bid_price.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isHighest ? Colors.green.shade700 : Colors.black87,
          ),
        ),
        subtitle: Text(
          DateFormat('MMM d, y - h:mm a').format(DateTime.parse(bid.bid_date)),
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
  );
}
