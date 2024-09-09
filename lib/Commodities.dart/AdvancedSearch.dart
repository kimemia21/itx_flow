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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Set the container width based on screen width
    double containerWidth = screenWidth * 0.9; // 90% of the screen width for smaller devices
    if (screenWidth > 800) {
      containerWidth = screenWidth * 0.6; // 60% of the screen width for larger devices
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Advanced Search',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Colors.blue.shade600,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Container(
            width: containerWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
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
                      child: Text(
                        'Apply Filters',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.1, // 10% of screen width
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
        Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
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
        Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ...options.map((option) => RadioListTile<String>(
              title: Text(
                option,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              value: option,
              groupValue: selectedOption,
              onChanged: onChanged,
              activeColor: Colors.blue.shade600,
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
        Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
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
              fillColor: Colors.grey.shade200,
              suffixIcon: Icon(Icons.calendar_today, color: Colors.blue.shade600),
            ),
            child: Text(
              selectedDate != null
                  ? DateFormat.yMd().format(selectedDate!)
                  : 'Select date',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

