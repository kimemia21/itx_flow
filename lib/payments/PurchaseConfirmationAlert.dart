import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/requests/Requests.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

Widget purchaseConfirmationAlert({
  required BuildContext context,
  required ContractsModel contract,
  required String contactEmail,
  required String contactPhone,
}) {
  double amt = contract.price;
  final amountController = TextEditingController(text: amt > 0 ? amt.toString() : '');

  // Get the screen width and height
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  // Set responsive font sizes and padding based on screen width
  double titleFontSize = screenWidth < 600 ? 20 : 24; // Adjust title font size for small screens
  double bodyFontSize = screenWidth < 600 ? 14 : 16; // Adjust body font size for small screens
  double buttonFontSize = screenWidth < 600 ? 12 : 16; // Adjust button font size for small screens
  EdgeInsets padding = EdgeInsets.all(screenWidth < 600 ? 16 : 24); // Adjust padding for small screens

  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    content: Container(
      width: screenWidth * 0.8,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Confirm Your Purchase',
            style: GoogleFonts.poppins(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  contract.name,
                  style: GoogleFonts.poppins(
                    fontSize: bodyFontSize + 4, // Increase size for contract name
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Delivery Date: ${DateFormat('MMM dd, yyyy').format(contract.deliveryDate)}',
                  style: GoogleFonts.poppins(
                    fontSize: bodyFontSize,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          if (contract.price == -1)
            TextField(
              controller: amountController,
              onChanged: (value) {
                amt = double.tryParse(value) ?? 0;
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: "Enter Amount",
                prefixIcon: Icon(Icons.attach_money, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
          SizedBox(height: 20),
          Text(
            amt > 0
                ? 'Total: \$${NumberFormat.currency(symbol: '', decimalDigits: 2).format(amt)}'
                : 'Enter a valid amount',
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize + 6, // Increase size for total amount text
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                    fontSize: buttonFontSize,
                    color: Colors.red[400],
                  ),
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () async {
                  if (amt < 1) return;
                  await AuthRequest.createOrder(
                    isWeb: false,
                    context,
                    
                    {"order_price": amt, "order_type": "BUY"},
                    contract.contractId,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  elevation: 3,
                ),
                child: context.watch<appBloc>().isLoading
                    ? LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white, size: 25)
                    : Text(
                        "Confirm Purchase",
                        style: GoogleFonts.poppins(
                          fontSize: buttonFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
