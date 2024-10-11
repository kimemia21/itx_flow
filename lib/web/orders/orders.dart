import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/OrderModel.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';

class WebOrdersScreen extends StatefulWidget {
  const WebOrdersScreen({Key? key}) : super(key: key);

  @override
  State<WebOrdersScreen> createState() => _WebOrdersScreenState();
}

class _WebOrdersScreenState extends State<WebOrdersScreen> {
  Future<List<UserOrders>>? _futureOrders;
  bool _isGridView = false; // State to track layout

  @override
  void initState() {
    super.initState();
    _futureOrders = loadOrders();
  }

  Future<List<UserOrders>> loadOrders() async {
    return await CommodityService.getOrders(context: context);
  }

  Widget deliveryInfo({
    required String name,
    required double bidPrice,
    required DateTime deliveryDate,
    required String status,
    required VoidCallback onTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isGrid = constraints.maxWidth > 400; // Adjust for Grid layout

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: isGrid
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Bid Price: \$$bidPrice',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              Text(
                                'Delivery Date: ${deliveryDate.toLocal()}',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status: $status',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              // Text(
                              //   'Details',
                              //   style: GoogleFonts.poppins(
                              //       fontSize: 14, color: Colors.blue),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Bid Price: \$$bidPrice',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        Text(
                          'Delivery Date: ${deliveryDate.toLocal()}',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status: $status',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            Text(
                              'Details',
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.blue),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

 Widget buildOrderList(List<UserOrders> orders) {
    final screenWidth = MediaQuery.of(context).size.width;

    return _isGridView
        ? GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth < 600
                  ? 2 // 2 cards per row for small screens
                  : screenWidth < 900
                      ? 3 // 3 cards per row for medium screens
                      : 4, // 4 cards per row for large screens
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.7, // Adjust this to reduce card height
            ),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return deliveryInfo(
                name: order.name,
                bidPrice: order.bidPrice,
                deliveryDate: order.deliveryDate,
                status: order.orderStatus,
                onTap: () {
                  // Action on tap
                },
              );
            },
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return deliveryInfo(
                name: order.name,
                bidPrice: order.bidPrice,
                deliveryDate: order.deliveryDate,
                status: order.orderStatus,
                onTap: () {
                  // Action on tap
                },
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.green,
        title: Text(
          "My Dashboard",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = true; // Switch to GridView
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              setState(() {
                _isGridView = false; // Switch to ListView
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<UserOrders>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      size: 48, color: Colors.black54),
                  const SizedBox(height: 10),
                  Text(
                    'Error occurred. Please try again.',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _futureOrders = loadOrders();
                      });
                    },
                    icon: Icon(Icons.refresh),
                    label: Text("Retry"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No orders found',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _futureOrders = loadOrders();
                      });
                    },
                    icon: Icon(Icons.refresh),
                    label: Text("Refresh"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final myorders = snapshot.data!;
            final paidOrders = myorders
                .where((order) => order.orderStatus != "")
                .toList();

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _futureOrders = loadOrders();
                });
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Text(
                        "My Contracts",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    buildOrderList(myorders), // List/Grid View based on state
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Text(
                        "Upcoming Deliveries",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    buildOrderList(paidOrders),
                  ],
                ),
              ),
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
