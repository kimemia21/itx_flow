import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Widget contractInfo({
  required String name,
  required String contractId,
  required String orderId,
  required String orderType,
  required String orderStatus,
  required double bidPrice,
  required DateTime orderDate,
  required String description,
}) {
    return Card(
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
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      // fontWeight: FontWeigh,
                      color: Colors.black,
                    ),
                  ),
                ),
                _buildStatusChip(orderStatus),
              ],
            ),
            SizedBox(height: 12),
            Text(
              DateFormat('MMM d, y').format(orderDate),
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
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


//   return Card(
//     elevation: 3,
//     margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     child: Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Colors.white, Colors.grey.shade50],
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     name,
//                     style: GoogleFonts.poppins(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue.shade800,
//                     ),
//                   ),
//                 ),
//                 _buildStatusChip(orderStatus),
//               ],
//             ),
//             SizedBox(height: 12),
//             _buildInfoRow('Order Type', orderType),
//             _buildInfoRow('Bid Price', '\$${bidPrice.toStringAsFixed(2)}'),
//             _buildInfoRow('Order Date', DateFormat('MMM d, y').format(orderDate)),
//             SizedBox(height: 12),
//             Text(
//               'Description',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey.shade700,
//               ),
//             ),
//             Text(
//               description,
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//             SizedBox(height: 16),
//             _buildActionButton(orderStatus),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget _buildStatusChip(String status) {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//     decoration: BoxDecoration(
//       color: getStatusColor(status),
//       borderRadius: BorderRadius.circular(20),
//     ),
//     child: Text(
//       status,
//       style: GoogleFonts.poppins(
//         fontSize: 12,
//         fontWeight: FontWeight.w600,
//         color: Colors.white,
//       ),
//     ),
//   );
// }

// Widget _buildInfoRow(String label, String value) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 8),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.poppins(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey.shade700,
//           ),
//         ),
//         Text(
//           value,
//           style: GoogleFonts.poppins(
//             fontSize: 14,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildActionButton(String status) {
//   return ElevatedButton(
//     onPressed: () {
//       // Add action here
//     },
//     child: Text(
//       status == 'SIGNED' ? 'View Details' : 'Take Action',
//       style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//     ),
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.blue.shade600,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//     ),
//   );
// }

// Color getStatusColor(String status) {
//   switch (status.toUpperCase()) {
//     case 'SIGNED':
//       return Colors.green.shade600;
//     case 'PENDING':
//       return Colors.orange.shade600;
//     case 'CANCELLED':
//       return Colors.red.shade600;
//     default:
//       return Colors.blue.shade600;
//   }
// }