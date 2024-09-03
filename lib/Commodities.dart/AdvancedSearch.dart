import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AdvancedSearchPage extends StatefulWidget {
  @override
  _AdvancedSearchPageState createState() => _AdvancedSearchPageState();
}

class _AdvancedSearchPageState extends State<AdvancedSearchPage> {
  String? selectedQuality = 'All';
  String? selectedQuantity = 'All';
  DateTime? selectedDate;
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.close),
        //   onPressed: () {
        //     // Close action
        //   },
        // ),
        title: Text('Advanced Search'),
      ),
      body: Container(
        width: width,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField(
              controller: priceController,
              title: 'Enter Price',
              icon: Icons.attach_money,
            ),
            SizedBox(height: 16),
            buildRadioGroup(
              title: 'Quality',
              options: ['All', 'Premium', 'Standard'],
              selectedOption: selectedQuality,
              onChanged: (value) {
                setState(() {
                  selectedQuality = value;
                });
              },
            ),
            SizedBox(height: 16),
            buildRadioGroup(
              title: 'Quantity',
              options: ['All', 'Large', 'Medium'],
              selectedOption: selectedQuantity,
              onChanged: (value) {
                setState(() {
                  selectedQuantity = value;
                });
              },
            ),
            SizedBox(height: 16),
            buildDatePicker(
              title: 'Delivery Time',
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Apply filters action
                },
                child: Text('Apply filters'),
                style: ElevatedButton.styleFrom(
                  // primary: Colors.green,
                  // onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String title,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            prefixIcon: icon != null ? Icon(icon) : null,
          ),
        ),
      ],
    );
  }

  Widget buildRadioGroup({
    required String title,
    required List<String> options,
    required String? selectedOption,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ...options.map((option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: selectedOption,
              onChanged: onChanged,
            )),
      ],
    );
  }

  Widget buildDatePicker({
    required String title,
    required DateTime? selectedDate,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (picked != null && picked != selectedDate) {
              onDateSelected(picked);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              suffixIcon: Icon(Icons.calendar_today),
            ),
            child: Text(
              selectedDate != null
                  ? DateFormat.yMd().format(selectedDate!)
                  : 'Select date',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
