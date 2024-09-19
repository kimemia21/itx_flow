import 'package:flutter/material.dart';
import 'package:itx/Commodities.dart/ContRequest.dart';

class ContractTypeDropdown extends StatefulWidget {
  @override
  _ContractTypeDropdownState createState() => _ContractTypeDropdownState();
}

class _ContractTypeDropdownState extends State<ContractTypeDropdown> {
  String? _selectedcontract;
  List<Map<String, dynamic>> _contracts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
   _fetchContracts();
  }

  // Fetch commodities and set state
  Future<void> _fetchContracts() async {
    try {
      List<Map<String, dynamic>> fetchedCommodities = await ContractTypeRequest.fetchContract(context);
      setState(() {
        _contracts = fetchedCommodities;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching commodities: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  Widget _buildContractTypeDropdown() {
    if (_isLoading) {
      return CircularProgressIndicator(); // Show loading indicator while fetching
    }

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Contract Type',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      value: _selectedcontract,
      items: _contracts
          .map((commodity) => DropdownMenuItem<String>(
                value: commodity['id'].toString(),
                child: Text(commodity['contract_type']),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedcontract = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContractTypeDropdown();
  }
}
