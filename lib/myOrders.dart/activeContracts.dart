import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Serializers/OrderModel.dart';
import 'package:itx/myOrders.dart/OrderDetails.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

Widget contractInfo({required context, required UserOrders order}) {
  return GestureDetector(
    onTap: () {
      PersistentNavBarNavigator.pushNewScreen(
          withNavBar: true,
          context,
          screen: OrderDetails(
            order: order,
          ));
    },
    child: Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade50],
          ),
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
                        fontSize: 20,
                        // fontWeight: FontWeigh,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  _buildStatusChip(order.orderStatus),
                ],
              ),
              SizedBox(height: 12),
              Text(
                DateFormat('MMM d, y').format(order.orderDate),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildStatusChip(String status) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: getStatusColor(status),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  );
}

Color getStatusColor(String status) {
  switch (status.toUpperCase()) {
    case 'SIGNED':
      return Colors.green.shade600;
    case 'PENDING':
      return Colors.orange.shade600;
    case 'CANCELLED':
      return Colors.red.shade600;
    case 'DELIVERED':
      return Colors.blue.shade600;
    default:
      return Colors.grey.shade600; // Default for unknown statuses
  }
}

