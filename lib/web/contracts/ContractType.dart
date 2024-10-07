import 'package:flutter/material.dart';
import 'package:itx/Commodities.dart/ContRequest.dart';
import 'package:itx/Serializers/ContractType.dart';

class ContractTypeDropdown extends StatefulWidget {
  final Function(String?) onContractSelected;

  const ContractTypeDropdown({Key? key, required this.onContractSelected}) : super(key: key);

  @override
  _ContractTypeDropdownState createState() => _ContractTypeDropdownState();
}

class _ContractTypeDropdownState extends State<ContractTypeDropdown> {
  String? _selectedContract;
  List<Map<String, dynamic>> _contracts = [];
  bool _isLoading = true;
   

  @override
  void initState() {
    super.initState();
    _fetchContracts();
  }

  Future<void> _fetchContracts() async {
    try {
      List<Map<String, dynamic>> fetchedContracts = await ContractTypeRequest.fetchContract(context);
      setState(() {
        _contracts = fetchedContracts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching contracts: $e');
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
      value: _selectedContract,
      items: _contracts
          .map((contract) => DropdownMenuItem<String>(
                value: contract['id'].toString(),
                child: Text(contract['contract_type']),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedContract = value;
        });
        widget.onContractSelected(value); 
        // Notify parent widget
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContractTypeDropdown();
  }
}
