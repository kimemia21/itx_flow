import 'dart:ui';

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
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(20),
                  onHover: (isHovering) {
                    setState(() {
                      _isHovered = isHovering;
                    });
                  },
                  splashColor: Colors.green.withOpacity(0.1),
                  highlightColor: Colors.greenAccent.withOpacity(0.05),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                order.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _buildStatusChip(order.orderStatus),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          order.contract_user ?? "company name",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow("Grade", order.grade_name ?? "grade name"),
                        const SizedBox(height: 8),
                        _buildInfoRow("Price", '\$${order.bidPrice.toStringAsFixed(2)}', isHighlighted: true),
                        const SizedBox(height: 8),
                        _buildInfoRow("Order Type", order.orderType),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 20, color: Colors.black45),
                            const SizedBox(width: 8),
                            Text(
                              'Delivery: ${_formatDate(order.deliveryDate)}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
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
          ),
        ),
      );
    },
  );
}

Widget _buildInfoRow(String label, String value, {bool isHighlighted = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade600,
        ),
      ),
      Text(
        value,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isHighlighted ? Colors.green.shade600 : Colors.black87,
        ),
      ),
    ],
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
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: chipColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: chipColor.withOpacity(0.5)),
    ),
    child: Text(
      status,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
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
