import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/requests/Requests.dart';

class PurchaseConfirmationAlert extends StatefulWidget {
  final String productName;
  final double amount;
  final int quantity;
  final ContractsModel contract;
  final DateTime deliveryDate;
  final String contactEmail;
  final String contactPhone;

  const PurchaseConfirmationAlert({
    Key? key,
    required this.productName,
    required this.amount,
    required this.contract,
    required this.quantity,
    required this.deliveryDate,
    required this.contactEmail,
    required this.contactPhone,
  }) : super(key: key);

  @override
  State<PurchaseConfirmationAlert> createState() =>
      _PurchaseConfirmationAlertState();
}

class _PurchaseConfirmationAlertState extends State<PurchaseConfirmationAlert> {
  double amt = 0;
  TextEditingController amtinput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Confirm Your Purchase',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade800,
            ),
          ),
          SizedBox(height: 15),
          Text(
            widget.productName,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          // Text(
          //   'Quantity: ${widget.quantity}',
          //   style: GoogleFonts.poppins(
          //     fontSize: 16,
          //     color: Colors.grey[700],
          //   ),
          // ),
          if (widget.amount == -1)
            TextField(
              controller: amtinput,
              onChanged: (value) {
                amt = double.parse(value);
                setState(() {});
              },
            ),
          Text(
            widget.amount > 0
                ? 'Total: \$${NumberFormat.currency(symbol: '', decimalDigits: 2).format(widget.amount)}'

                : 'Total: \$${amt.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Delivery Date: ${DateFormat('MMM dd, yyyy').format(widget.deliveryDate)}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 15),
          Divider(),
          // SizedBox(height: 15),
          // Text(
          //   'Contact Information',
          //   style: GoogleFonts.poppins(
          //     fontSize: 18,
          //     fontWeight: FontWeight.w500,
          //     color: Colors.blue[800],
          //   ),
          // ),
          // SizedBox(height: 10),
          // Text(
          //   'Email: ${widget.contactEmail}',
          //   style: GoogleFonts.poppins(
          //     fontSize: 14,
          //     color: Colors.grey[700],
          //   ),
          // ),
          // Text(
          //   'Phone: ${widget.contactPhone}',
          //   style: GoogleFonts.poppins(
          //     fontSize: 14,
          //     color: Colors.grey[700],
          //   ),
          // ),
          // SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.red[400],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (widget.amount > 0) {
                    amt = widget.amount;
                  }
                  if (amt < 1) {
                    return;
                  }

                  AuthRequest.createBid(
                          context,
                          {"order_price": amt, "order_type": "BUY"},
                          widget.contract.contractId)
                      .then(
                    (value) {
                   //   Navigator.pop(context);
                    },
                  );
                  CherryToast.success(
                    title: Text("Purchase Confirmed"),
                    description: Text(
                      'You should pay within 10 days to receive an invoice via email .',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    animationType: AnimationType.fromRight,
                    animationDuration: Duration(milliseconds: 1000),
                    autoDismiss: true,
                  ).show(context);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  "Confirm Purchase",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
