import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/global/globals.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LiveAuctionScreen extends StatefulWidget {
  @override
  _LiveAuctionScreenState createState() => _LiveAuctionScreenState();
}

class _LiveAuctionScreenState extends State<LiveAuctionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _selectedDateTime;
  List<Map<String, dynamic>> bidsHistory = [];
  Map<String, List<Map<String, dynamic>>> itemData = {
    'Minerals': [
      {'name': 'Gold', 'price': 1800.0, 'unit': 'oz', 'endTime': DateTime.now().add(Duration(hours: 1))},
      {'name': 'Silver', 'price': 25.0, 'unit': 'oz', 'endTime': DateTime.now().add(Duration(hours: 2))},
    ],
    'Agriculture': [
      {'name': 'Rice', 'price': 0.50, 'unit': 'lbs', 'endTime': DateTime.now().add(Duration(minutes: 45))},
      {'name': 'Wheat', 'price': 700.0, 'unit': 'bushel', 'endTime': DateTime.now().add(Duration(minutes: 30))},
    ],
    'Energy': [
      {'name': 'Crude Oil', 'price': 70.0, 'unit': 'barrel', 'endTime': DateTime.now().add(Duration(hours: 1, minutes: 30))},
      {'name': 'Natural Gas', 'price': 2.5, 'unit': 'MMBtu', 'endTime': DateTime.now().add(Duration(hours: 1, minutes: 15))},
    ],
    'Crafts': [
      {'name': 'Handmade Pottery', 'price': 50.0, 'unit': 'piece', 'endTime': DateTime.now().add(Duration(hours: 2))},
      {'name': 'Woven Baskets', 'price': 30.0, 'unit': 'piece', 'endTime': DateTime.now().add(Duration(minutes: 55))},
    ],
  };
  String currentCategory = 'agriculture';
  int currentItemIndex = 0;
  double highestBid = 0.0;

  // Add a new variable to store the chart data
  List<ChartData> chartData = [];

  // Add a variable to store the remaining time
  late DateTime auctionEndTime;
  Duration remainingTime = Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
    highestBid = itemData[currentCategory]![currentItemIndex]['price'] as double;
    auctionEndTime = itemData[currentCategory]![currentItemIndex]['endTime'] as DateTime;
    _initializeBidHistory();
    _startTimer();
  }

  void _initializeBidHistory() {
    final now = DateTime.now();
    final initialPrice = itemData[currentCategory]![currentItemIndex]['price'] as double;
    bidsHistory.clear();
    chartData.clear();
    for (int i = 30; i >= 0; i--) {
      final bidTime = now.subtract(Duration(days: i));
      final bidAmount = initialPrice * (0.9 + 0.2 * i / 30);
      bidsHistory.add({
        'user': 'System',
        'time': bidTime,
        'amount': bidAmount,
      });
      chartData.add(ChartData(bidTime, bidAmount));
    }
    highestBid = bidsHistory.last['amount'];
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

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            currentCategory = 'Minerals';
            break;
          case 1:
            currentCategory = 'agriculture';
            break;
          case 2:
            currentCategory = 'energy';
            break;
          case 3:
            currentCategory = 'crafts';
            break;
        }
        currentItemIndex = 0;
        auctionEndTime = itemData[currentCategory]![currentItemIndex]['endTime'] as DateTime;
        _initializeBidHistory();
      });
    }
  }

  void _showPlaceBidDialog(String itemName, double currentPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double bidAmount = highestBid;
        String? errorText;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Place Bid for $itemName'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Current Highest Bid: \$${highestBid.toStringAsFixed(2)}'),
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
                        if (newBid <= highestBid) {
                          setState(() {
                            errorText = 'Bid must be higher than \$${highestBid.toStringAsFixed(2)}';
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
                  onPressed: errorText == null ? () {
                    if (bidAmount > highestBid) {
                      final now = DateTime.now();
                      this.setState(() {
                        highestBid = bidAmount;
                        bidsHistory.add({
                          'user': 'You',
                          'time': now,
                          'amount': bidAmount,
                        });
                        chartData.add(ChartData(now, bidAmount));
                      });
                      Navigator.of(context).pop();
                    }
                  } : null,
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = itemData[currentCategory]![currentItemIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Live Auction'),
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
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Minerals'),
                Tab(text: 'Agriculture'),
                Tab(text: 'Energy'),
                Tab(text: 'Crafts'),
              ],
            ),
            SizedBox(height: 20),

            Text(
              '${currentItem['name']} - 5,000 ${currentItem['unit']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '\$${highestBid.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Text('Last 30 Days'),
                    Text(
                      '+${((highestBid / bidsHistory.first['amount'] - 1) * 100).toStringAsFixed(2)}%',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            Container(
              height: 200,
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
                  onTap: () => _showPlaceBidDialog(currentItem['name'], highestBid),
                  child: Container(
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.center,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: Globals.AppWidth(context: context, width: 0.3),
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
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${remainingTime.inHours}:${(remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                // Highest Bid Display
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Highest Bid',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$${highestBid.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: bidsHistory.length,
                reverse: true, // Show latest bid at the top
                itemBuilder: (context, index) {
                  final bid = bidsHistory[index];
                  return ListTile(
                    title: Text('${bid['user']}'),
                    subtitle: Text('${bid['time'].toString()}'),
                    trailing: Text('\$${bid['amount'].toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
          ],
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
