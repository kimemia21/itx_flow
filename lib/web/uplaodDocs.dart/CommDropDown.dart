import 'package:flutter/material.dart';
import 'package:itx/Commodities.dart/ComRequest.dart';
import 'package:itx/web/requests/AuthRequest.dart';

class CommodityDropdown extends StatefulWidget {
  final Function(String?) onCommoditySelected;

  const CommodityDropdown({Key? key, required this.onCommoditySelected})
      : super(key: key);

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

  Future<void> _fetchCommodities() async {
    try {
      List<Map<String, dynamic>> fetchedCommodities = await WebAuthrequest.fetchCommodities(context);
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
      return Center(
        child: CircularProgressIndicator(
          
        ),
      );
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
        widget.onCommoditySelected(value);
        print(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCommodityTypeDropdown();
  }
}
