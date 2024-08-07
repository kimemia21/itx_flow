import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CreateContract extends StatefulWidget {
  @override
  _CreateContractState createState() => _CreateContractState();
}

class _CreateContractState extends State<CreateContract>
    with SingleTickerProviderStateMixin {
  String? selectedCommodity;
  String? selectedQuality;
  DateTime? selectedDate;
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  List<String> commodities = ['Commodity 1', 'Commodity 2', 'Commodity 3'];
  List<String> qualities = ['Quality 1', 'Quality 2', 'Quality 3'];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Form'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Futures'),
            Tab(text: 'Forwards'),
            Tab(text: 'Options'),
            Tab(text: 'Swaps'),
          ],
          isScrollable: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDropdownButton(
              title: 'Choose a commodity',
              value: selectedCommodity,
              items: commodities,
              onChanged: (value) {
                setState(() {
                  selectedCommodity = value;
                });
              },
            ),
            buildDropdownButton(
              title: 'Choose a commodity Quality/Grade',
              value: selectedQuality,
              items: qualities,
              onChanged: (value) {
                setState(() {
                  selectedQuality = value;
                });
              },
            ),
            buildDatePicker(
              title: 'Choose a delivery Date/Schedule',
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            buildTextField(
              controller: priceController,
              title: 'Enter Price',
              icon: Icons.attach_money,
            ),
            buildTextField(
              controller: descriptionController,
              title: 'Description',
              maxLines: 4,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadiusDirectional.circular(10)),
                  child: Text(
                    "Save Review",
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadiusDirectional.circular(10)),
                  child: Text(
                    "Review",
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownButton({
    required String title,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
        SizedBox(height: 16),
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
        Text(title),
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
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String title,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            prefixIcon: icon != null ? Icon(icon) : null,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
