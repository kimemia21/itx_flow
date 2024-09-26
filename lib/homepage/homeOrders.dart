import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/OrderModel.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/myOrders.dart/MyOrders.dart';
import 'package:itx/myOrders.dart/OrderDetails.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePageOrders extends StatefulWidget {
  final Function(int) onOrderCountChanged;

  const HomePageOrders({Key? key, required this.onOrderCountChanged})
      : super(key: key);

  @override
  State<HomePageOrders> createState() => _HomePageOrdersState();
}

class _HomePageOrdersState extends State<HomePageOrders>
    with SingleTickerProviderStateMixin {
  Future<List<UserOrders>>? _futureOrders;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _futureOrders = loadOrders();
    _futureOrders?.then((orders) {
      widget.onOrderCountChanged(orders.length);
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<List<UserOrders>> loadOrders() async {
    return await CommodityService.getOrders(context: context);
  }

  Widget contractCard({
    required UserOrders order,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              order.name,
                              style: GoogleFonts.poppins(
                                fontSize: 16, // Adjusted for homepage
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .black87, // Slightly darker color for readability
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildStatusChip(order.orderStatus),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.attach_money,
                              size: 18, color: Colors.green.shade600),
                          const SizedBox(width: 4),
                          Text(
                            'Bid Price: \$${order.bidPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize:
                                  14, // Slightly smaller for secondary text
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 18, color: Colors.black54),
                          const SizedBox(width: 4),
                          Text(
                            'Delivery: ${_formatDate(order.deliveryDate)}',
                            style: GoogleFonts.poppins(
                              fontSize: 14, // Adjusted for homepage
                              color: Colors
                                  .black54, // Neutral color for less important text
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orange.shade300;
        break;
      case 'completed':
        chipColor = Colors.green;
        break;
      case 'cancelled':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.blue;
    }

    return Chip(
      label: Text(
        status,
        style: GoogleFonts.poppins(
          fontSize: 12, // Chip text size
          color: Colors.white,
        ),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Visibility(
        visible: _futureOrders != null,
        child: FutureBuilder<List<UserOrders>>(
          future: _futureOrders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load orders',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 48, color: Colors.black54),
                    const SizedBox(height: 10),
                    Text(
                      'No Orders available',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final myorders = snapshot.data!;
              final limitedOrders = myorders.take(3).toList();

              return Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Orders',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade800,
                          ),
                        ),
                        TextButton(
                            onPressed: () =>
                                PersistentNavBarNavigator.pushNewScreen(
                                    withNavBar: true,
                                    context,
                                    screen: UserOrdersScreen()),
                            child: Text(
                              'See all',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: AnimationLimiter(
                      child: ListView.builder(
                        itemCount: limitedOrders.length,
                        itemBuilder: (context, index) {
                          final order = limitedOrders[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: contractCard(
                                  order: order,
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: OrderDetails(order: order),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text(
                  'Unknown error occurred',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
