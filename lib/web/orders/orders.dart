import 'dart:ui';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/OrderModel.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:timeago/timeago.dart' as timeago;

class WebOrdersScreen extends StatefulWidget {
  const WebOrdersScreen({Key? key}) : super(key: key);

  @override
  State<WebOrdersScreen> createState() => _WebOrdersScreenState();
}

class _WebOrdersScreenState extends State<WebOrdersScreen>
    with SingleTickerProviderStateMixin {
  Future<List<UserOrders>>? _futureOrders;
  bool _isGridView = false; // State to track layout

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _futureOrders = loadOrders();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  Future<List<UserOrders>> loadOrders() async {
    return await CommodityService.getOrders(context: context);
  }


  Widget deliveryInfoTable({
    required List<UserOrders> orders,
    required Function(UserOrders) onTap,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 1,
      child: DataTable2(
        columnSpacing: 10,
        horizontalMargin: 10,
        minWidth: 600,
        columns: [
          // DataColumn2(label: Text('Name'), size: ColumnSize.L),
          DataColumn2(label: Text('Company'), size: ColumnSize.M),
          DataColumn2(label: Text('Grade'), size: ColumnSize.S),
          DataColumn2(label: Text('Price'), size: ColumnSize.S),
          DataColumn2(label: Text('Type'), size: ColumnSize.S),
          DataColumn2(label: Text('Delivery'), size: ColumnSize.M),
          DataColumn2(label: Text('Status'), size: ColumnSize.S),
        ],
        rows: orders.map((order) {
          return DataRow(
            cells: [
              // DataCell(Text(
              //   order.name,
              //   style: GoogleFonts.poppins(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w600,
              //     color: Colors.black87,
              //   ),
              // )),
              DataCell(Text(
                order.contract_user ?? "company name",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              )),
              DataCell(Text(
                order.grade_name ?? "grade name",
                style: GoogleFonts.poppins(fontSize: 14),
              )),
              DataCell(Text(
                '\$${order.bidPrice.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade600,
                ),
              )),
              DataCell(Text(
                order.orderType,
                style: GoogleFonts.poppins(fontSize: 14),
              )),
              DataCell(Text(
                _formatDate(order.deliveryDate),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              )),
              DataCell(_buildStatusChip(order.orderStatus)),
            ],
            // onTap: () => onTap(order),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'active':
        chipColor = Colors.green;
        break;
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'completed':
        chipColor = Colors.blue;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return timeago.format(date, allowFromNow: true);
  }

  Widget buildOrderList(List<UserOrders> orders) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_isGridView) {
          // Calculate the number of columns based on screen width
          int crossAxisCount = constraints.maxWidth ~/
              300; // Assume each card is roughly 300 wide
          crossAxisCount =
              crossAxisCount.clamp(1, 4); // Limit to between 1 and 4 columns

          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return deliveryInfoTable(orders: orders, onTap: (order){});
            },
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return  deliveryInfoTable(orders: orders, onTap: (order) {});
          
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
            final paidOrders =
                myorders.where((order) => order.orderStatus != "").toList();

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
