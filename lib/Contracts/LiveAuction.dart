import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Add this dependency in your pubspec.yaml file



class LiveAuctionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Auction'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            Row(
              children: [
                _buildTab('Mines', isSelected: true),
                _buildTab('Agriculture'),
                _buildTab('Energy'),
                _buildTab('Crafts'),
              ],
            ),
            SizedBox(height: 20),
            
            // Item Details
            Text(
              'Rice - 5,000 lbs',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '\$0.50',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Text('Last 30 Days'),
                    Text(
                      '+12%',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Graph
            Container(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<SalesData, String>>[
                  LineSeries<SalesData, String>(
                    dataSource: getChartData(),
                    xValueMapper: (SalesData sales, _) => sales.year,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            
            // Bidding Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Bidding ends in: 00:07:59'),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Place Bid'),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Bid History
            Text('Bid History', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildBidHistoryItem('You', '2 minutes ago', '\$0.50'),
                  _buildBidHistoryItem('User 123', '1 minute ago', '\$0.45'),
                  _buildBidHistoryItem('User 234', '3 minutes ago', '\$0.40'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildBidHistoryItem(String user, String time, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(user),
          Text(time),
          Text(amount),
        ],
      ),
    );
  }

  List<SalesData> getChartData() {
    final List<SalesData> chartData = [
      SalesData('1D', 35),
      SalesData('1W', 28),
      SalesData('1M', 34),
      SalesData('3M', 32),
      SalesData('1Y', 40),
    ];
    return chartData;
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
