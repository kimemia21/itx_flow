import 'package:flutter/material.dart';

class Order {
  final String id;
  final String customerName;
  final String status;
  final DateTime orderDate;

  Order({required this.id, required this.customerName, required this.status, required this.orderDate});
}

class WarehouseOrdersPage extends StatefulWidget {
  @override
  _WarehouseOrdersPageState createState() => _WarehouseOrdersPageState();
}

class _WarehouseOrdersPageState extends State<WarehouseOrdersPage> {
  List<Order> orders = [
    Order(id: '001', customerName: 'John Doe', status: 'Pending', orderDate: DateTime.now().subtract(Duration(days: 1))),
    Order(id: '002', customerName: 'Jane Smith', status: 'Processing', orderDate: DateTime.now().subtract(Duration(days: 2))),
    Order(id: '003', customerName: 'Bob Johnson', status: 'Shipped', orderDate: DateTime.now().subtract(Duration(days: 3))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Warehouse Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Order #${orders[index].id}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer: ${orders[index].customerName}'),
                  Text('Status: ${orders[index].status}'),
                  Text('Date: ${orders[index].orderDate.toString().split(' ')[0]}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Implement order details view
                print('Tapped on order ${orders[index].id}');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add new order functionality
          print('Add new order');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}