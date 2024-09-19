import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Commodities.dart/ComDropDown.dart';
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/myOrders.dart/MyOrders.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:provider/provider.dart';import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateContract extends StatefulWidget {
  @override
  _CreateContractState createState() => _CreateContractState();
}

class _CreateContractState extends State<CreateContract> with SingleTickerProviderStateMixin {
  String? selectedCommodity;
  String? selectedQuality;
  DateTime? selectedDate;
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  List commodities = [];
  List<String> qualities = ['Quality 1', 'Quality 2', 'Quality 3'];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    commodities = context.watch<appBloc>().userCommodities;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        title: Text('Create Contract', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Futures'),
                Tab(text: 'Forwards'),
                Tab(text: 'Options'),
                Tab(text: 'Swaps'),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green,
              isScrollable: true,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // add flags to know where and the fields to include 
            CommodityDropdown(),
                buildDropdownButton(
                  title: 'Choose a commodity Quality/Grade',
                  value: selectedQuality,
                  items: qualities,
                  onChanged: (value) => setState(() => selectedQuality = value),
                ),
                buildDatePicker(
                  title: 'Choose a delivery Date/Schedule',
                  selectedDate: selectedDate,
                  onDateSelected: (date) => setState(() => selectedDate = date),
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
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement save functionality
                      },
                      icon: Icon(Icons.save),
                      label: Text("Save Contract"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement review functionality
                      },
                      icon: Icon(Icons.rate_review),
                      label: Text("Review"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownButton({
    required String title,
    required String? value,
    required List items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          style: GoogleFonts.poppins(),
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
        Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor: Colors.green,
                    // accentColor: Colors.green,
                    colorScheme: ColorScheme.light(primary: Colors.green),
                    buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null && picked != selectedDate) onDateSelected(picked);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null ? DateFormat.yMMMd().format(selectedDate!) : 'Select date',
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
                Icon(Icons.calendar_today, color: Colors.green),
              ],
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
        Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.poppins(),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: icon != null ? Icon(icon, color: Colors.green) : null,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}