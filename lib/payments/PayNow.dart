import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itx/Serializers/ContractSerializer.dart';

class PaymentInfoForm extends StatefulWidget {
  final ContractsModel contract;
  final String contactEmail;
  final String contactPhone;

  const PaymentInfoForm({
    Key? key,
    required this.contract,
    required this.contactEmail,
    required this.contactPhone,
  }) : super(key: key);

  @override
  _PaymentInfoFormState createState() => _PaymentInfoFormState();
}

class _PaymentInfoFormState extends State<PaymentInfoForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.contactPhone);
    _emailController = TextEditingController(text: widget.contactEmail);
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
            padding: EdgeInsets.symmetric(
                horizontal: 12, vertical: 12), 
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
        SizedBox(width: 40,),
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
          onPressed: () {
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
              Navigator.of(context).pop();
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
