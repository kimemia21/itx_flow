import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';

class AddOrderPage extends StatefulWidget {
  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  String? _selectedCommodity;
  String? _selectedQuality;
  DateTime? _selectedDate;
  final List<String> _commodities = ['Wheat', 'Rice', 'Corn'];
  final Map<String, List<String>> _qualities = {
    'Wheat': ['High', 'Medium', 'Low'],
    'Rice': ['Premium', 'Standard', 'Economy'],
    'Corn': ['A', 'B', 'C']
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Commodity',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black54),
              ),
              SizedBox(height: 10,),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  
                  border: OutlineInputBorder(
  
                   
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                value: _selectedCommodity,
                items:
                 _commodities.map((commodity) {
                  return DropdownMenuItem(
                    value: commodity,
                    child: Text(commodity),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCommodity = value;
                    _selectedQuality = null; // Reset quality when commodity changes
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                'Add Quality',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _selectedQuality,
                items: _selectedCommodity == null
                    ? []
                    : _qualities[_selectedCommodity]!.map((quality) {
                        return DropdownMenuItem(
                          value: quality,
                          child: Text(quality),
                        );
                      }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedQuality = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                'Indicate Price',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter price',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Text(
                'Delivery Date',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              TextField(
                controller: _deliveryDateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Select date',
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _addOrder,
                  child: Text('Add Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _deliveryDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _addOrder() {
    // Implement your add order logic here
    print('Order added');
    print('Commodity: $_selectedCommodity');
    print('Quality: $_selectedQuality');
    print('Price: ${_priceController.text}');
    print('Delivery Date: ${_deliveryDateController.text}');
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: AddOrderPage(),
//   ));
// }
