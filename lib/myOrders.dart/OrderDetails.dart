import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Orderdetails extends StatefulWidget {
  final String contractId;
  final String orderId;
  final String orderType;
  final String orderStatus;
  final double bidPrice;
  final DateTime orderDate;
  final String description;

  const Orderdetails({
    Key? key,
    required this.contractId,
    required this.orderId,
    required this.orderType,
    required this.orderStatus,
    required this.bidPrice,
    required this.orderDate,
    required this.description,
  }) : super(key: key);

  @override
  State<Orderdetails> createState() => _OrderdetailsState();
}

class _OrderdetailsState extends State<Orderdetails> {
  late TextEditingController _descriptionController;
  late String _orderStatus;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.description);
    _orderStatus = widget.orderStatus;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.green,
        elevation: 0,
     
      ),
      body: Container(
        color: Colors.grey[100], // Simple background color
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(),
              const SizedBox(height: 20),
              _buildDetailCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${widget.orderId}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Placed on ${DateFormat('MMMM d, yyyy').format(widget.orderDate)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Contract ID', widget.contractId),
            _buildDetailItem('Order Type', widget.orderType),
            _buildStatusDropdown(),
            _buildDetailItem('Bid Price', '\$${widget.bidPrice.toStringAsFixed(2)}'),
            _buildDescriptionField(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 120,
            child: Text(
              'Order Status',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ),
          Expanded(
            child: _isEditing
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.indigo, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: _orderStatus,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: ['Pending', 'Processing', 'Completed', 'Cancelled']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _orderStatus = newValue;
                          });
                        }
                      },
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      dropdownColor: Colors.white,
                    ),
                  )
                : Text(
                    _orderStatus,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 8),
          _isEditing
              ? TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.indigo, width: 2),
                    ),
                    hintText: 'Enter description',
                  ),
                )
              : Text(
                  widget.description,
                  style: const TextStyle(fontSize: 16),
                ),
        ],
      ),
    );
  }
}
