import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Serializers/WareHouseUsers.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

class WarehouseSearchDropdown extends StatefulWidget {
  final Function(int) onWarehouseSelected;

  const WarehouseSearchDropdown({Key? key, required this.onWarehouseSelected})
      : super(key: key);

  @override
  _WarehouseSearchDropdownState createState() =>
      _WarehouseSearchDropdownState();
}

class _WarehouseSearchDropdownState extends State<WarehouseSearchDropdown> {
  List<WarehouseNames> _allWarehouses = [];

  @override
  void initState() {
    super.initState();
    _loadWarehouses();
  }

  Future<void> _loadWarehouses() async {
    _allWarehouses = await CommodityService.getWareHouse(context: context);
    setState(() {});
  }

  Future<List<WarehouseNames>> _getFilteredWarehouses(String query) async {
    await Future.delayed(
        const Duration(milliseconds: 100)); // Simulating network delay
    return _allWarehouses.where((warehouse) {
      return warehouse.username.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<WarehouseNames>.searchRequest(
      futureRequest: _getFilteredWarehouses,
      hintText: 'Search Housing Warehouse',
      decoration: CustomDropdownDecoration(
        closedFillColor: Colors.grey[200],
        expandedFillColor: Colors.white,
        closedShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
        expandedShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        closedBorder: Border.all(color: Colors.grey, width: 1),
        closedBorderRadius: BorderRadius.circular(8),
        closedErrorBorder: Border.all(color: Colors.red, width: 1),
        closedErrorBorderRadius: BorderRadius.circular(8),
        expandedBorder: Border.all(color: Colors.blueAccent, width: 1),
        expandedBorderRadius: BorderRadius.circular(8),
        hintStyle: GoogleFonts.poppins(
          color: Colors.grey[600],
          fontSize: 16,
        ),
        headerStyle: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        noResultFoundStyle: GoogleFonts.poppins(
          color: Colors.redAccent,
          fontSize: 14,
        ),
        errorStyle: GoogleFonts.poppins(
          color: Colors.red,
          fontSize: 12,
        ),
        listItemStyle: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 14,
        ),
        overlayScrollbarDecoration: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Colors.blueAccent),
        ),
        searchFieldDecoration: SearchFieldDecoration(
          hintStyle: GoogleFonts.poppins(color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      items: _allWarehouses,
      onChanged: (value) {
        if (value != null) {
          log('Selected warehouse: ${value.username}');
          setState(() {
            widget.onWarehouseSelected(value.id);
          });
          print(value.id);
        }
      },
      listItemBuilder: (context, item, isSelected, onItemSelect) {
        return ListTile(
          title: Text(item.username,
              style: GoogleFonts.poppins(color: Colors.black)),
          selected: isSelected,
          onTap: onItemSelect,
        );
      },
      headerBuilder: (context, selectedItem, isExpanded) {
        return Text(
          selectedItem?.username ?? 'Select a warehouse',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w500),
        );
      },
    );
  }
}
