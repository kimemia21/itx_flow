import 'package:flutter/material.dart';
import 'package:itx/Serializers/Commodity_types.dart';
import 'package:itx/Serializers/ContractType.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/web/requests/HomeRequest/HomeReq.dart';
import 'package:provider/provider.dart';

class NewContractPage extends StatefulWidget {
  @override
  _NewContractPageState createState() => _NewContractPageState();
}

class _NewContractPageState extends State<NewContractPage> {
  String? _contractType ;
  String _deliveryTime = '1 week';
  String _selectedCommodity = 'WTI Crude Oil';
  String _selectedCurrency = 'USD';
  TextEditingController _quantityController = TextEditingController();
  List<ContractType> _contractTypes =
      []; // List to store fetched contract types




 ContractType? _selectedContractType; 
  Future<List<ContractType>> _fetchContracts(BuildContext context) async {
    try {
      List<ContractType> contracts = await HomepageRequest.GetContracts(context: context);
      return contracts;
    } catch (e) {
      print("Error fetching contract types: $e");
      return []; // Return an empty list if an error occurs
    }
  }

 
  Widget _buildRadioListTile({
    required ContractType contractType,
    required ContractType? selectedContractType,
    required ValueChanged<ContractType?> onChanged,
  }) {
    return RadioListTile<ContractType>(
      title: Text(contractType.contractType), 
      value: contractType,
      groupValue: selectedContractType,
      onChanged: onChanged,
      activeColor: Colors.green,
    );
  }


  @override
  Widget build(BuildContext context) {
    print(context.watch<appBloc>().token);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('New Contract'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contract Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
            FutureBuilder<List<ContractType>>(
        future: _fetchContracts(context), // Fetch contracts when FutureBuilder runs
        builder: (BuildContext context, AsyncSnapshot<List<ContractType>> snapshot) {
          // Handle the loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator
          }

          // Handle error
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching contract types: ${snapshot.error}'));
          }

          // Handle empty list scenario
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No contract types available.'));
          }

          // Contracts successfully loaded
          List<ContractType> contractTypes = snapshot.data!;
          ContractType? selectedContractType;

          return StatefulBuilder(
            builder: (context, setState) {
              return ListView(
                children: contractTypes.map((contractType) {
                  return _buildRadioListTile(
                    contractType: contractType,
                    selectedContractType: selectedContractType,
                    onChanged: (ContractType? newValue) {
                      setState(() {
                        selectedContractType = newValue; // Update the selected value
                      });
                    },
                  );
                }).toList(),
              );
            },
          );
        },
      ),

            
              SizedBox(height: 24),
              Text('Commodity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildCommodityCard(),
              SizedBox(height: 24),
              Text('Delivery Time',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              // _buildRadioListTile('1 week', '1 week'),
              // _buildRadioListTile('2 weeks', '2 weeks'),
              // _buildRadioListTile('3 weeks', '3 weeks'),
              // _buildRadioListTile('4 weeks', '4 weeks'),
              SizedBox(height: 24),
              Text('Quantity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter quantity',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 24),
              Text('Currency',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCurrency,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: ['USD', 'EUR', 'GBP', 'JPY'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCurrency = newValue!;
                  });
                },
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Create Contract'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    // Handle contract creation
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build radio list tile for each contract type

 

  Widget _buildCommodityCard() {
    return Card(
      child: ListTile(
        leading: Image.network(
            'https://responsive.fxempire.com/v7/_fxempire_/2024/03/Barrels-of-Oil-2-1.jpg?width=1201',
            width: 40,
            height: 40),
        title: Text('WTI Crude Oil'),
        subtitle: Text('40.70 USD per barrel'),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: () {
          // Handle commodity selection
        },
      ),
    );
  }
}
