// import 'package:flutter/material.dart';
// import 'package:itx/Serializers/OrderModel.dart';
// import 'package:itx/requests/HomepageRequest.dart';
// import 'package:provider/provider.dart';

// class UserOrdersScreen extends StatefulWidget {
//   @override
//   _UserOrdersScreenState createState() => _UserOrdersScreenState();
// }

// class _UserOrdersScreenState extends State<UserOrdersScreen> {
//   late List<UserOrders> _ordersFuture;

//   static get http => null;

//   @override
//   void initState() {
//     super.initState();
//     loadorders(); // Fetch orders on init
//   }

//   // Function to fetch orders from API

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("User Orders"),
//       ),
//       body: FutureBuilder<List<UserOrders>>(
//         future: CommodityService.getOrders(context: context),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             print("got err ${snapshot.error.toString()}");
//             return Center(child: Text("Error fetching orders"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text("No orders available"));
//           } else {
//             final orders = snapshot.data!;
//             return ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 final order = orders[index];
//                 return OrderCard(order: order);
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   void loadorders() async {
//     await CommodityService.getOrders(context: context).then(
//       (value) {
//         print(value);
//         //    _ordersFuture = value;
//       },
//     );
//   }
// }

// class OrderCard extends StatelessWidget {
//   final UserOrders order;

//   const OrderCard({Key? key, required this.order}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Image.network(
//                   order.imageUrl,
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.cover,
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         order.name,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text("Price: \$${order.price.toStringAsFixed(2)}"),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text("Description: ${order.description}"),
//             Text("Order Type: ${order.orderType}"),
//             Text("Order Status: ${order.orderStatus}"),
//             Text("Bid Price: \$${order.bidPrice.toStringAsFixed(2)}"),
//             Text("Order Date: ${order.orderDate.toLocal().toString()}"),
//             SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                     "Delivery Date: ${order.deliveryDate.toLocal().toString()}"),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Action on button press
//                   },
//                   child: Text("Details"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
