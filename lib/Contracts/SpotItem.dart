import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/myOrders.dart/MyOrders.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/global/globals.dart';

class Spotitem extends StatefulWidget {
  const Spotitem({super.key});

  @override
  State<Spotitem> createState() => _SpotitemState();
}

class _SpotitemState extends State<Spotitem>
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Globals.leading(
            context: context,
            screen: Contracts(
              filtered: false,
              showAppbarAndSearch: false,
            )),
        title: Text('Create Contact'),
        centerTitle: true,
        // bottom: TabBar(
        //   controller: _tabController,
        //   tabs: [
        //     Tab(text: 'Futures'),
        //     Tab(text: 'Forwards'),
        //     Tab(text: 'Options'),
        //     Tab(text: 'Swaps'),
        //   ],
        //   isScrollable: true,
        // ),
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
                GestureDetector(
                  onTap: () => Globals.switchScreens(
                      context: context, screen: UserOrdersScreen()),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadiusDirectional.circular(10)),
                    child: Text(
                      "Save Contract",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    selectedCommodity != null
                        ? Globals.switchScreens(
                            context: context,
                            screen: Specificorder(
                              item: selectedCommodity!,
                              price: 12,
                              quantity: "23",
                              companyId: "1",
                            ))
                        : ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Please Select a Commodity'),
                            ),
                          );
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: BorderRadiusDirectional.circular(10)),
                    child: Text(
                      "Review",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.white),
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
