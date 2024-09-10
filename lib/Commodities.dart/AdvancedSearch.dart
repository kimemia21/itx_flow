import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdvancedSearchModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onSearch;

   AdvancedSearchModal({Key? key, required this.onSearch}) : super(key: key);

  @override
  _AdvancedSearchModalState createState() => _AdvancedSearchModalState();
}

class _AdvancedSearchModalState extends State<AdvancedSearchModal> {
  final _formKey = GlobalKey<FormState>();
  String _contractType = 'All';
  RangeValues _priceRange = RangeValues(0, 1000);
  DateTime? _deliveryDateStart;
  DateTime? _deliveryDateEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Advanced Search',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 20),
            _buildContractTypeDropdown(),
            SizedBox(height: 20),
            _buildPriceRangeSlider(),
            SizedBox(height: 20),
            _buildDateRangePicker(),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _submitSearch,
                child: Text('Search', style: GoogleFonts.poppins(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractTypeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Contract Type',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      value: _contractType,
      items: ['All', 'Futures', 'Spot', 'Forward']
          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
          .toList(),
      onChanged: (value) {
        setState(() {
          _contractType = value!;
        });
      },
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price Range', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 1000,
          divisions: 20,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _priceRange = values;
            });
          },
          activeColor: Colors.green.shade600,
          inactiveColor: Colors.green.shade200,
        ),
      ],
    );
  }

  Widget _buildDateRangePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Date Range', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  _deliveryDateStart = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  setState(() {});
                },
                controller: TextEditingController(
                  text: _deliveryDateStart != null
                      ? '${_deliveryDateStart!.day}/${_deliveryDateStart!.month}/${_deliveryDateStart!.year}'
                      : '',
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  _deliveryDateEnd = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  setState(() {});
                },
                controller: TextEditingController(
                  text: _deliveryDateEnd != null
                      ? '${_deliveryDateEnd!.day}/${_deliveryDateEnd!.month}/${_deliveryDateEnd!.year}'
                      : '',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _submitSearch() {
    if (_formKey.currentState!.validate()) {
      widget.onSearch({
        'contractType': _contractType,
        'priceRange': _priceRange,
        'deliveryDateStart': _deliveryDateStart,
        'deliveryDateEnd': _deliveryDateEnd,
      });
      Navigator.pop(context);
    }
  }
}