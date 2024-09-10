import 'package:flutter/material.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:provider/provider.dart';

class NewContractPage extends StatefulWidget {
  @override
  _NewContractPageState createState() => _NewContractPageState();
}

class _NewContractPageState extends State<NewContractPage> {
  String _contractType = 'Futures';
  String _deliveryTime = '1 week';
  String _selectedCommodity = 'WTI Crude Oil';
  String _selectedCurrency = 'USD';
  TextEditingController _quantityController = TextEditingController();

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
              _buildRadioListTile('Futures', 'Futures'),
              _buildRadioListTile('Forwards', 'Forwards'),
              _buildRadioListTile('Options', 'Options'),
              SizedBox(height: 24),
              Text('Commodity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildCommodityCard(),
              SizedBox(height: 24),
              Text('Delivery Time',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildRadioListTile('1 week', '1 week'),
              _buildRadioListTile('2 weeks', '2 weeks'),
              _buildRadioListTile('3 weeks', '3 weeks'),
              _buildRadioListTile('4 weeks', '4 weeks'),
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

  Widget _buildRadioListTile(String title, String value) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: title.contains('week') ? _deliveryTime : _contractType,
      onChanged: (newValue) {
        setState(() {
          if (title.contains('week')) {
            _deliveryTime = newValue!;
          } else {
            _contractType = newValue!;
          }
        });
      },
      activeColor: Colors.green,
    );
  }

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
