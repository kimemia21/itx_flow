import 'package:flutter/material.dart';
import 'package:itx/Commodities.dart/ComRequest.dart';

class CommodityDropdown extends StatefulWidget {
  @override
  _CommodityDropdownState createState() => _CommodityDropdownState();
}

class _CommodityDropdownState extends State<CommodityDropdown> {
  String? _selectedCommodity;
  List<Map<String, dynamic>> _commodities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCommodities();
  }

  // Fetch commodities and set state
  Future<void> _fetchCommodities() async {
    try {
      List<Map<String, dynamic>> fetchedCommodities = await CommodityRequest.fetchCommodities(context);
      setState(() {
        _commodities = fetchedCommodities;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching commodities: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  Widget _buildCommodityTypeDropdown() {
    if (_isLoading) {
      return CircularProgressIndicator(); // Show loading indicator while fetching
    }

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Commodity Type',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      value: _selectedCommodity,
      items: _commodities
          .map((commodity) => DropdownMenuItem<String>(
                value: commodity['id'].toString(),
                child: Text(commodity['name']),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCommodity = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCommodityTypeDropdown();
  }
}
