import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/OrderModel.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/myOrders.dart/activeContracts.dart';
import 'package:itx/requests/HomepageRequest.dart';

class UserOrdersScreen extends StatefulWidget {
  const UserOrdersScreen({Key? key}) : super(key: key);

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  Future<List<UserOrders>>? _futureOrders;

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
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
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
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.blue),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "My Dashboard",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<UserOrders>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load orders',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.w500),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No orders found',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          } else if (snapshot.hasData) {
            final myorders = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _futureOrders = loadOrders();
                });
                // return _futureOrders!;
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Text(
                        "Active Contracts",
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                      ),
                    ),
                    ...myorders.map((order) {
                      return contractInfo(
                        name: order.name,
                        contractId: order.contractId.toString(),
                        orderId: order.orderId.toString(),
                        orderType: order.orderType,
                        orderStatus: order.orderStatus,
                        bidPrice: order.bidPrice,
                        orderDate: order.orderDate,
                        description: order.description,
                      );
                    }).toList(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Text(
                        "Upcoming Deliveries",
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                      ),
                    ),
                    ...myorders
                        .where((order) => order.orderStatus == "PAID")
                        .map((order) {
                      return deliveryInfo(
                        name: order.name,
                        bidPrice: order.bidPrice,
                        deliveryDate: order.deliveryDate,
                        status: order.orderStatus,
                        onTap: () {
                          Globals.switchScreens(
                            context: context,
                            screen: Specificorder(
                              item: order.name,
                              price: order.price,
                              quantity: order.description,
                              companyId: order.userCompanyId.toString(),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                'Unknown error occurred',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }
        },
      ),
    );
  }
}
