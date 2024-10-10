import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Contracts/TimeRemaining.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/Serializers/PriceHistory.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// Assume other necessary imports are present

class WebContractLiveBid extends StatefulWidget {
  final ContractsModel contract;

  const WebContractLiveBid({Key? key, required this.contract}) : super(key: key);

  @override
  _WebContractLiveBidState createState() => _WebContractLiveBidState();
}

class _WebContractLiveBidState extends State<WebContractLiveBid> {
  late Future<List<PricehistoryModel>> _bidsFuture;
  double _highestBid = 0.0;
  List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    _bidsFuture = CommodityService.ContractsBids(
        context: context, id: widget.contract.contractId);
    _updateData(context);
  }

  // Assume _updateData, _refreshData, and _showBidDialog methods are present

   Future<void> _updateData(BuildContext context) async {
    final appBloc bloc = context.read<appBloc>();
    try {
      bloc.changeIsLoading(true);
      final data = await CommodityService.ContractsBids(
        context: context,
        id: widget.contract.contractId,
      );

      if (data != null && data.isNotEmpty) {
        // The first item in the list already contains the highest bid
        setState(() {
          _highestBid = data.first.bid_price;
          print("this is the highest bid $_highestBid");

          chartData = data
              .map((bid) =>
                  ChartData(DateTime.parse(bid.bid_date), bid.bid_price))
              .toList();

          // Sort the chart data by date in ascending order
          chartData.sort((a, b) => a.date.compareTo(b.date));
        });
        bloc.changeIsLoading(false);
      } else {
        bloc.changeIsLoading(false);
        // Handle case when data is empty
        setState(() {
          _highestBid = 0; // or any default value
          chartData = [];
        });
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching bid data: $e');
    } finally {
      bloc.changeIsLoading(false);
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _bidsFuture = CommodityService.ContractsBids(
          context: context, id: widget.contract.contractId);
    });
    await _updateData(context);
  }

void _showBidDialog({PricehistoryModel? existingBid}) {
  bool isEditing = existingBid != null;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      double bidAmount = isEditing ? existingBid.bid_price : _highestBid;
      String? errorText;
      final TextEditingController _bidController = TextEditingController(
        text: isEditing ? bidAmount.toString() : '',
      );

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              textAlign: TextAlign.center,
              isEditing
                  ? 'Edit Bid for ${widget.contract.name}'
                  : 'Place Bid for ${widget.contract.name}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            content: Container(
              constraints: BoxConstraints(
                maxWidth: 400, // Set a max width for better web experience
              ),
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
                        final double _highestCap = _highestBid + 500;
                        if (!isEditing && newBid <= _highestBid) {
                          setState(() {
                            errorText =
                                'Bid must be higher than \$${NumberFormat('#,##0.00').format(_highestBid)}';
                          });
                        } else if (!isEditing && newBid > _highestCap) {
                          setState(() {
                            errorText =
                                'Bid must be \$500 higher than the highest bid.';
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
                    isEditing
                        ? 'Edit your bid amount'
                        : 'Enter an amount higher than the current bid',
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
              if (isEditing)
                TextButton(
                  child: Provider.of<appBloc>(context, listen: false).isLoading
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white, size: 20)
                      : Text(
                          'Delete Bid',
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                  onPressed: () async {
                    await CommodityService.DeleteBid(context, existingBid.bid_id);
                    await _updateData(context);
                    await _refreshData();
                    Navigator.of(context).pop();
                  },
                ),
              ElevatedButton(
                child: Provider.of<appBloc>(context, listen: false).isLoading
                    ? LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white, size: 20)
                    : Text(
                        isEditing ? 'Update Bid' : 'Place Bid',
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
                    ? () async {
                        if (isEditing || bidAmount > _highestBid) {
                          final Map<String, dynamic> body = {
                            "order_price": bidAmount,
                            "order_type": "BUY"
                          };
                          if (isEditing) {
                            await CommodityService.UpdateBid(
                                context, bidAmount, existingBid.bid_id);
                          } else {
                            await CommodityService.PostBid(
                                context, body, widget.contract.contractId);
                          }
                          await _updateData(context);
                          await _refreshData();
                          Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "Live Auction",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    _buildPriceChart(),
                    _buildContractInfo(),
                    SizedBox(height: 16),
                    _buildMainContent(),
                    SizedBox(height: 24),
                    _buildBidHistory(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContractInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildMainContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildLeftColumn()),
              SizedBox(width: 20),
              Expanded(child: _buildRightColumn()),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLeftColumn(),
              SizedBox(height: 20),
              _buildRightColumn(),
            ],
          );
        }
      },
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPriceSection(),
        SizedBox(height: 16),
        _buildBidButton(),
        SizedBox(height: 16),
        _buildTimeRemaining(),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      onPressed: _showBidDialog,
      child: Provider.of<appBloc>(context, listen: false).isLoading
          ? LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white, size: 20)
          : Text(
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
    bool isUserBid = bid.user_id == userId;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      color: isUserBid ? Colors.blue[50] : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isHighest ? Colors.yellow : Colors.grey[300],
          child: Icon(
            isUserBid ? Icons.person : Icons.gavel,
            color: Colors.black,
          ),
        ),
        title: Text(
          '\$${NumberFormat('#,##0.00').format(bid.bid_price)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isHighest ? Colors.green : Colors.black,
          ),
        ),
        subtitle: Text(
          DateFormat('MMM d, y - h:mm a').format(DateTime.parse(bid.bid_date)),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isHighest)
              Chip(
                label: Text('Highest', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
              ),
            if (isUserBid)
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showBidDialog(existingBid: bid),
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