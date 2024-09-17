import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/CreateContract.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/OrderModel.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';

class UserOrdersScreen extends StatefulWidget {
  const UserOrdersScreen({Key? key}) : super(key: key);

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  Widget ContractInfo({
    required String title,
    required String subtitle,
    required String status,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        trailing: Chip(
          label: Text(
            status,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
          ),
          backgroundColor: status == "Signed" ? Colors.green : Colors.orange,
        ),
      ),
    );
  }

  Widget DeliveryInfo({
    required String title,
    required VoidCallback Function,
    required String status,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: Function,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                status,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<UserOrders> myorders = [];

  @override
  initState() {
    super.initState();
    loadorders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
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
      body: RefreshIndicator(
        onRefresh: loadorders,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  "Active Contracts",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              ...myorders.map(
                (e) {
                  return ContractInfo(
                    title: e.name,
                    subtitle: " ",
                    status: e.orderStatus,
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  "Upcoming Deliveries",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              ...myorders
                  .where(
                    (element) => element.orderStatus == "PAID",
                  )
                  .toList()
                  .map(
                (e) {
                  return DeliveryInfo(
                    title: e.name,
                    status: e.bidPrice.toString(),
                    Function: () => Globals.switchScreens(
                      context: context,
                      screen: Specificorder(
                        item: "Soybean",
                        price: 23.0,
                        quantity: "100 bushels",
                        companyId: "1",
                      ),
                    ),
                  );
                },
              ),
              // DeliveryInfo(
              //   title: "Soybean, 100 bushels",
              //   status: "\$2,000",
              //   Function: () => Globals.switchScreens(
              //     context: context,
              //     screen: Specificorder(
              //       item: "Soybean",
              //       price: 23.0,
              //       quantity: "100 bushels",
              //       companyId: "1",
              //     ),
              //   ),
              // ),
              // DeliveryInfo(
              //   title: "Corn, 200 bushels",
              //   status: "\$3,000",
              //   Function: () => Globals.switchScreens(
              //     context: context,
              //     screen: Specificorder(
              //       item: "Corn",
              //       price: 1.00,
              //       quantity: "100 bushels",
              //       companyId: "1",
              //     ),
              //   ),
              // ),
              // DeliveryInfo(
              //   title: "Wheat, 150 bushels",
              //   status: "\$2,300",
              //   Function: () => Globals.switchScreens(
              //     context: context,
              //     screen: Specificorder(
              //       item: "Wheat",
              //       price: 12.00,
              //       quantity: "12",
              //       companyId: "1",
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadorders() async {
    CommodityService.getOrders(context: context).then(
      (value) {
        print("Got my orders $value");
        setState(() {
          myorders = value;
        });
      },
    );
  }
}
