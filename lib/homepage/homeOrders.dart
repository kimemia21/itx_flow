import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/OrderModel.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';

class HomePageOrders extends StatefulWidget {
  const HomePageOrders({Key? key}) : super(key: key);

  @override
  State<HomePageOrders> createState() => _HomePageOrdersState();
}

class _HomePageOrdersState extends State<HomePageOrders> {
  Future<List<UserOrders>>? _futureOrders;

  @override
  void initState() {
    super.initState();
    _futureOrders = loadOrders();
  }

  Future<List<UserOrders>> loadOrders() async {
    return await CommodityService.getOrders(context: context);
  }

  Widget contractCard({
    required String name,
    required double bidPrice,
    required DateTime deliveryDate,
    required String status,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bid Price: \$$bidPrice',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              Text(
                'Delivery Date: ${deliveryDate.toLocal()}',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Status: $status',
                style: GoogleFonts.poppins(fontSize: 14),
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
      body: FutureBuilder<List<UserOrders>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load orders',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.red),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No orders available',
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            );
          } else if (snapshot.hasData) {
            final myorders = snapshot.data!;
            // Limit the number of displayed orders to 3
            final limitedOrders = myorders.take(3).toList();

            return Column(
              children: [
                Text("My Orders"),
                Expanded(
                  child: ListView.builder(
                    itemCount: limitedOrders.length,

                    itemBuilder: (context, index) {
                      final order = limitedOrders[index];
                      return contractCard(
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
                              quantity: "4000",
                              companyId: order.userCompanyId.toString(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text(
                'Unknown error occurred',
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            );
          }
        },
      ),
    );
  }
}
