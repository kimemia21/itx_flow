import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Commodities.dart/ComDropDown.dart';
import 'package:itx/Commodities.dart/ContrDropdown.dart';

class AdvancedSearchModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onSearch;

  AdvancedSearchModal({Key? key, required this.onSearch}) : super(key: key);

  @override
  _AdvancedSearchModalState createState() => _AdvancedSearchModalState();
}

class _AdvancedSearchModalState extends State<AdvancedSearchModal> {
  final _formKey = GlobalKey<FormState>();
  String? commodityId;
  String? contractId;
  RangeValues _priceRange = RangeValues(0, 1000);
  DateTime? _deliveryDateStart;
  DateTime? _deliveryDateEnd;
  String? _price_from;
  String? _price_to;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
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
              CommodityDropdown(
                isForAppBar: false,
                onCommoditySelected: (commodityid) {
                setState(() {
                  commodityId = commodityid;
                });
              }),
              SizedBox(height: 20),
              ContractTypeDropdown(
                onContractSelected: (contractid) {
                  setState(() {
                    contractId = contractid;
                  });
                },
              ),
              SizedBox(height: 20),
              _buildPriceRangeSlider(),
              SizedBox(height: 20),
              _buildDateRangePicker(),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitSearch,
                  child: Text(
                    'Search',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadowColor: Colors.green.shade300,
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
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
              _price_from = values.start.toStringAsFixed(2);
              _price_to = values.end.toStringAsFixed(2);

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
        Text(
          'Delivery Date Range',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.green),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.green),
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

  String _formatDate(DateTime? date) {
    return date != null
        ? '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
        : '';
  }

  void _submitSearch() {
    if (_formKey.currentState!.validate()) {
      widget.onSearch({
        'contractId': contractId,
        'price_from': _price_from ?? "",
        'price_to': _price_to ?? "",
        'commodityId': commodityId,
        'priceRange': _priceRange.toString(),
        'deliveryDateStart': _formatDate(_deliveryDateStart),
        'deliveryDateEnd': _formatDate(_deliveryDateEnd),
      });
      Navigator.pop(context);
    }
  }
}
