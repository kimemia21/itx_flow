import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Itemlive extends StatefulWidget {
  final   List<Map<String, dynamic>> itemData;
  const Itemlive({required this.itemData});

  @override
  State<Itemlive> createState() => _ItemliveState();
}

class _ItemliveState extends State<Itemlive> {
  List<Map<String, dynamic>> bidsHistory = [];
  // List<Map<String, dynamic>> itemData = [
  //   {
  //     'name': 'Rice',
  //     'price': 0.50,
  //     'unit': 'lbs',
  //     'endTime': DateTime.now().add(Duration(minutes: 45))
  //   },
  // ];
  int currentItemIndex = 0;
  double highestBid = 0.0;

  // Chart data
  List<ChartData> chartData = [];

  // Remaining time
  late DateTime auctionEndTime;
  Duration remainingTime = Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    if (widget.itemData.isNotEmpty) {
      highestBid = widget.itemData[currentItemIndex]['price'] as double;
      auctionEndTime = widget.itemData[currentItemIndex]['endTime'] as DateTime;
      _initializeBidHistory();
      _startTimer();
    } else {
      print("Error: No items available.");
    }
  }

  void _initializeBidHistory() {
    final now = DateTime.now();
    final initialPrice = widget.itemData[currentItemIndex]['price'] as double;
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
    timer?.cancel();
    super.dispose();
  }

  void _showPlaceBidDialog(String itemName, double currentPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double bidAmount = highestBid;
        String? errorText;

        return StatefulBuilder(builder: (context, setState) {
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
                          errorText =
                              'Bid must be higher than \$${highestBid.toStringAsFixed(2)}';
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
                        if (bidAmount > highestBid) {
                          final now = DateTime.now();
                          setState(() {
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
    final currentItem = widget.itemData[currentItemIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '${widget.itemData[0]["name"]} Auction',
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
              '${currentItem['name']} - 5,000 ${currentItem['unit']}',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () =>
                      _showPlaceBidDialog(currentItem['name'], highestBid),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    alignment: Alignment.center,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      "Place Bid",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Remaining Time',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${remainingTime.inHours}:${(remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Highest Bid',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$${highestBid.toStringAsFixed(2)}',
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
              child: ListView.builder(
                itemCount: bidsHistory.length,
                reverse: true, // Show latest bid at the top
                itemBuilder: (context, index) {
                  final bid = bidsHistory[index];
                  return ListTile(
                    title: Text(
                      '${bid['user']}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      '${bid['time'].toString()}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Text(
                      '\$${bid['amount'].toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
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
