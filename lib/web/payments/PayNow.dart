import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/requests/Requests.dart';

class WebPaymentInfoForm extends StatefulWidget {
  final ContractsModel contract;
  final String contactEmail;
  final String contactPhone;

  const WebPaymentInfoForm({
    Key? key,
    required this.contract,
    required this.contactEmail,
    required this.contactPhone,
  }) : super(key: key);

  @override
  _WebPaymentInfoFormState createState() => _WebPaymentInfoFormState();
}

class _WebPaymentInfoFormState extends State<WebPaymentInfoForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  late TextEditingController _cardNumberController = TextEditingController();
  late TextEditingController _expirationDateController =
      TextEditingController();
  late TextEditingController _cvvController = TextEditingController();
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _addressController = TextEditingController();
  late TextEditingController _cityController = TextEditingController();
  late TextEditingController _countryController = TextEditingController();
  late TextEditingController _zipCodeController = TextEditingController();
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.contactPhone);
    _emailController = TextEditingController(text: widget.contactEmail);
    _phoneController = TextEditingController(text: widget.contactPhone);
    _emailController = TextEditingController(text: widget.contactEmail);
    _cardNumberController =
        TextEditingController(text: '1234 5678 9012 3456'); // Dummy card number
    _expirationDateController =
        TextEditingController(text: '12/34'); // Dummy expiration date
    _cvvController = TextEditingController(text: '123'); // Dummy CVV
    _nameController = TextEditingController(text: 'John Doe'); // Dummy name
    _addressController =
        TextEditingController(text: '123 Main St'); // Dummy address
    _cityController = TextEditingController(text: 'New York'); // Dummy city
    _countryController = TextEditingController(text: 'USA'); // Dummy country
    _zipCodeController = TextEditingController(text: '10001'); // Dummy ZIP code
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _cardNumberController.dispose();
    _expirationDateController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _zipCodeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          'Payment for ${widget.contract.name}'), // Using ContractsModel's name property
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Contract Details:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    'ID: ${widget.contract.id}'), // ContractsModel's id property
                Text(
                    'Amount: \$${widget.contract.price}'), // ContractsModel's price property
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your card number';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expirationDateController,
                        decoration: const InputDecoration(
                          labelText: 'Expiration Date',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        keyboardType: TextInputType.datetime,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter expiration date';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter CVV';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Billing Address',
                    prefixIcon: Icon(Icons.home),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your billing address';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your city';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _countryController,
                        decoration: const InputDecoration(
                          labelText: 'Country',
                          prefixIcon: Icon(Icons.flag),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your country';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _zipCodeController,
                  decoration: const InputDecoration(
                    labelText: 'ZIP Code',
                    prefixIcon: Icon(Icons.mail),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your ZIP code';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Button background color
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
            elevation: 5, // Shadow elevation for a subtle shadow effect
            shadowColor: Colors.black.withOpacity(0.3), // Shadow color
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'cancel',
            style: TextStyle(
              fontSize: 16, // Font size for better readability
              fontWeight: FontWeight.bold, // Bold text
              color: Colors.white, // Text color
            ),
          ),
        ),
        SizedBox(
          width: 40,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700], // Button background color
            padding: EdgeInsets.symmetric(
                horizontal: 12, vertical: 12), // Padding inside the button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
            elevation: 5, // Shadow elevation for a subtle shadow effect
            shadowColor: Colors.black.withOpacity(0.3), // Shadow color
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // Process the payment information here
              print('Payment information submitted:');
              print('Contract ID: ${widget.contract.id}');
              print('Contract Amount: \$${widget.contract.price}');
              print('Email: ${_emailController.text}');
              print('Phone: ${_phoneController.text}');
              print('Card Number: ${_cardNumberController.text}');
              print('Expiration Date: ${_expirationDateController.text}');
              print('CVV: ${_cvvController.text}');
              print('Name: ${_nameController.text}');
              print('Address: ${_addressController.text}');
              print('City: ${_cityController.text}');
              print('Country: ${_countryController.text}');
              print('ZIP Code: ${_zipCodeController.text}');
              await AuthRequest.createOrder(
                isWeb: false,
                context,
                {"order_price": widget.contract.price, "order_type": "BUY"},
                widget.contract.contractId,
              );
              showPaymentSuccessAlert(context, widget.contract.price.toString());

              // Navigator.of(context).pop();
            }
          },
          child: const Text(
            'Submit Payment',
            style: TextStyle(
              fontSize: 16, // Font size for better readability
              fontWeight: FontWeight.bold, // Bold text
              color: Colors.white, // Text color
            ),
          ),
        ),
      ],
    );
  }
}

void showPaymentSuccessAlert(BuildContext context, String amount) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        contentPadding: EdgeInsets.all(20), // Padding for the dialog content
        backgroundColor: Colors.white, // Dialog background color
        content: Column(
          mainAxisSize: MainAxisSize.min, // Minimize the height of the dialog
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 80, // Large checkmark icon
            ),
            SizedBox(height: 16), // Spacing between icon and text
            Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 22, // Larger font size for emphasis
                fontWeight: FontWeight.bold, // Bold font for emphasis
                color: Colors.black, // Text color
              ),
            ),
            SizedBox(height: 8), // Spacing between title and subtitle
            Text(
              'Thank you for your $amount   payment. Your transaction has been processed.',
              textAlign: TextAlign.center, // Center-align the text
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700], // Subtle color for the subtitle
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                padding: EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Button shape
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 16, // Button text size
                  fontWeight: FontWeight.bold, // Bold text for the button
                  color: Colors.white, // Button text color
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
