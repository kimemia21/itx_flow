import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Serializers/OrderModel.dart';

class OrderDetails extends StatefulWidget {
  final UserOrders order;


  const OrderDetails({
    Key? key,
    required this.order
  }) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late TextEditingController _descriptionController;
  late String _orderStatus;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.order.description);
    _orderStatus = widget.order.orderStatus;
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
        centerTitle: true,
        title:  Text('Order Details',style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),),
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

  Widget statusButton(BuildContext context, String status) {
  Color buttonColor;

  switch (status) {
    case 'pending':
      buttonColor = Colors.orange; // Color for pending
      break;
    case 'canceled':
      buttonColor = Colors.red; // Color for canceled
      break;
    case 'complete':
      buttonColor = Colors.green; // Color for complete
      break;
    default:
      buttonColor = Colors.grey; // Default color if status is unknown
  }

  return ElevatedButton(
    onPressed:(){},
    child: Text(
      status,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: Colors.white),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: buttonColor,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

  Widget _buildOrderHeader() {
    final dateFormat = DateFormat('MMMM d, yyyy');
  final timeFormat = DateFormat('hh:mm a');

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${widget.order.orderId}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                statusButton(context, widget.order.orderStatus.toLowerCase())
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '${dateFormat.format(widget.order.orderDate)} at ${timeFormat.format(widget.order.orderDate)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
                  _buildDetailItem('Order Type', widget.order.orderType),
          _buildDetailItem('Bid Price', '\$${widget.order.bidPrice.toStringAsFixed(2)}'),
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
            _buildDetailItem('Contract ID', widget.order.contractId.toString()),
            _buildDetailItem('Order Type', widget.order.orderType),
            _buildStatusDropdown(),
            _buildDetailItem('Bid Price', '\$${widget.order.bidPrice.toStringAsFixed(2)}'),
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
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold, color: Colors.black45),
            ),
          ),
          Expanded(
            child: Text(
              value.toUpperCase(),
              style:  GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold, color: Colors.black45),
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
                  widget.order.description,
                  style: const TextStyle(fontSize: 16),
                ),
        ],
      ),
    );
  }
}
