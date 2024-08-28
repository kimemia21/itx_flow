import 'package:flutter/material.dart';

class NewContractScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left sidebar
          Container(
            width: 200,
            color: Colors.grey[200],
            child: ListView(
              children: [
                ListTile(title: Text('Market', style: TextStyle(fontWeight: FontWeight.bold))),
                ListTile(leading: Icon(Icons.home), title: Text('Home')),
                ListTile(leading: Icon(Icons.description), title: Text('Orders')),
                ListTile(leading: Icon(Icons.bar_chart), title: Text('Positions')),
                ListTile(leading: Icon(Icons.history), title: Text('Market')),
                ListTile(leading: Icon(Icons.more_horiz), title: Text('More')),
                Spacer(),
                ListTile(leading: Icon(Icons.person), title: Text('Profile')),
                ListTile(leading: Icon(Icons.help), title: Text('Help')),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New Contract', style: Theme.of(context).textTheme.displayMedium),
                  SizedBox(height: 16),
                  Text('Contract Type'),
                  Row(
                    children: [
                      Radio(value: true, groupValue: true, onChanged: (v) {}),
                      Text('Futures'),
                      Radio(value: false, groupValue: true, onChanged: (v) {}),
                      Text('Forwards'),
                      Radio(value: false, groupValue: true, onChanged: (v) {}),
                      Text('Options'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Commodity'),
                  ListTile(
                    leading: Image.asset('assets/oil_icon.png', width: 40, height: 40),
                    title: Text('WTI Crude Oil'),
                    subtitle: Text('NYMEX Futures'),
                  ),
                  SizedBox(height: 16),
                  Text('Delivery Time'),
                  Row(
                    children: [
                      Radio(value: true, groupValue: true, onChanged: (v) {}),
                      Text('1 Week'),
                      Radio(value: false, groupValue: true, onChanged: (v) {}),
                      Text('2 Weeks'),
                      Radio(value: false, groupValue: true, onChanged: (v) {}),
                      Text('3 Weeks'),
                      Radio(value: false, groupValue: true, onChanged: (v) {}),
                      Text('4 Weeks'),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: 'Currency',
                      border: OutlineInputBorder(),
                    ),
                    items: [],
                    onChanged: (v) {},
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text('Create Contract'),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}