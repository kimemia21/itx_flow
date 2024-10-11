import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/OrderModel.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/myOrders.dart/MyOrders.dart';
import 'package:itx/myOrders.dart/OrderDetails.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/web/orders/orders.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class WebHomePageOrders extends StatefulWidget {
  final Function(int) onOrderCountChanged;

  const WebHomePageOrders({Key? key, required this.onOrderCountChanged})
      : super(key: key);

  @override
  State<WebHomePageOrders> createState() => _WebHomePageOrdersState();
}

class _WebHomePageOrdersState extends State<WebHomePageOrders>
    with SingleTickerProviderStateMixin {
  Future<List<UserOrders>>? _futureOrders;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
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

  void _loadOrders() {
    setState(() {
      _futureOrders = loadOrders();
    });
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
          elevation: _isHovered ? 6 : 3, // Increase elevation on hover for depth
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Softer corners for a modern feel
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15),
            onHover: (isHovering) {
              setState(() {
                _isHovered = isHovering;
              });
            },
            splashColor: Colors.green.withOpacity(0.1), // Soft splash effect
            highlightColor: Colors.greenAccent.withOpacity(0.05), // Highlight on click
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Order Name with Status Chip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          order.name,
                          style: GoogleFonts.poppins(
                            fontSize: 18, // Larger font for modern look
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusChip(order.orderStatus),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Company Name
                  Text(
                    "Company Name",
                    style: GoogleFonts.poppins(
                      fontSize: 16, // Adjusted for smaller size and clean look
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Bid Price
                  Row(
                    children: [
                      Icon(Icons.attach_money,
                          size: 20, color: Colors.greenAccent.shade700),
                      const SizedBox(width: 6),
                      Text(
                        '\$${order.bidPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Delivery Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 18, color: Colors.black45),
                      const SizedBox(width: 6),
                      Text(
                        'Delivery Date: ${_formatDate(order.deliveryDate)}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Optional Location Row (Can be uncommented if needed)
                  // Row(
                  //   children: [
                  //     Icon(Icons.location_on_outlined,
                  //         size: 18, color: Colors.blueAccent.shade400),
                  //     const SizedBox(width: 6),
                  //     Text(
                  //       'Location: ${order.location}',
                  //       style: GoogleFonts.poppins(
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.w400,
                  //         color: Colors.blueAccent.shade400,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
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
    if (status == 'Completed') {
      chipColor = Colors.greenAccent.shade700;
    } else if (status == 'Pending') {
      chipColor = Colors.orangeAccent.shade700;
    } else {
      chipColor = Colors.redAccent.shade700;
    }

    return Container(
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1), // Light background color
        border: Border.all(color: chipColor),
        borderRadius: BorderRadius.circular(50), // Rounded for a modern look
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: chipColor,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                1, // Set a height constraint
            child: FutureBuilder<List<UserOrders>>(
              future: _futureOrders,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Globals.buildErrorState(
                      function: _loadOrders, items: "Orders");
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Globals.buildNoDataState(
                      function: _loadOrders, item: "Orders");
                } else if (snapshot.hasData) {
                  final myorders = snapshot.data!;

                  return AnimationLimiter(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: myorders.length,
                      itemBuilder: (context, index) {
                        final order = myorders[index];
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
                  );
                } else {
                  return Globals.buildErrorState(
                      function: _loadOrders, items: "Orders");
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            onPressed: () => PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: WebOrdersScreen(),
            ),
            child: Text(
              'See all',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
