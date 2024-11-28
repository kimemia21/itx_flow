import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/OrderModel.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';

class UserOrdersScreen extends StatefulWidget {
  const UserOrdersScreen({super.key});

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  late Future<List<UserOrders>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _futureOrders = _loadOrders();
  }

  Future<List<UserOrders>> _loadOrders() async {
    return CommodityService.getOrders(context: context);
  }

  Widget _buildOrderCard(UserOrders order) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Implement order details navigation
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(order),
              const SizedBox(height: 8),
              _buildOrderDetails(order),
              const SizedBox(height: 8),
              _buildOrderFooter(order),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHeader(UserOrders order) {
    return Text(
      order.name,
      style: GoogleFonts.poppins(
        fontSize: 18, 
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOrderDetails(UserOrders order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bid Price: \$${order.bidPrice}',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        Text(
          'Delivery Date: ${order.deliveryDate.toLocal()}',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildOrderFooter(UserOrders order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Status: ${order.orderStatus}',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        Text(
          'Details',
          style: GoogleFonts.poppins(
            fontSize: 14, 
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersList(List<UserOrders> orders) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) => _buildOrderCard(orders[index]),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.green,
                  size: 40,),
         
          Text(
            'Loading your orders...',
            style: GoogleFonts.poppins(
              color: Colors.green.shade700,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade300,
            size: 100,
          ),
          const SizedBox(height: 20),
          Text(
            'Oops! Something went wrong',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => setState(() {
              _futureOrders = _loadOrders();
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12,
              ),
              child: Text(
                'Try Again',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/empty_orders.png',
            width: 250,
          ),
          const SizedBox(height: 20),
          Text(
            'No orders yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Start exploring and place your first order!',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersContent(List<UserOrders> orders) {
    final paidOrders = orders.where((order) => order.orderStatus.isNotEmpty).toList();

    return RefreshIndicator(
      color: Colors.green.shade700,
      onRefresh: () async => setState(() {
        _futureOrders = _loadOrders();
      }),
      child: CustomScrollView(
        slivers: [
          _buildSectionHeader("My Contracts", "Here's an overview of your current orders"),
          _buildOrdersSliverList(orders),
          _buildSectionHeader("Upcoming Deliveries"),
          _buildOrdersSliverList(paidOrders),
        ],
      ),
    );
  }

  SliverPadding _buildSectionHeader(String title, [String? subtitle]) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.green.shade800,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  SliverList _buildOrdersSliverList(List<UserOrders> orders) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: _buildOrderCard(orders[index]),
        ),
        childCount: orders.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(Icons.person_outline, color: Colors.green.shade800),
        ),
      ),
      title: Text(
        "My Orders",
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.green.shade800,
        ),
      ),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.refresh, color: Colors.green.shade700),
              onPressed: () => setState(() {
                _futureOrders = _loadOrders();
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<UserOrders>>(
      future: _futureOrders,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildLoadingState();
          case ConnectionState.done:
            if (snapshot.hasError) return _buildErrorState();
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            }
            return _buildOrdersContent(snapshot.data!);
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}