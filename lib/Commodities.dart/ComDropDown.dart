import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Commodities.dart/ComRequest.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:provider/provider.dart';

class CommodityDropdown extends StatefulWidget {
  final bool isForAppBar;
  final Function(String?) onCommoditySelected;

  const CommodityDropdown(
      {Key? key, required this.onCommoditySelected, required this.isForAppBar})
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
      print("we are in");
      List<Map<String, dynamic>> fetchedCommodities =
          await CommodityRequest.fetchCommodities(context);
      setState(() {
        _commodities = fetchedCommodities;
        print(_commodities);
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
        child: CircularProgressIndicator(),
      );
    }

    return
      Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            'Select Item',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: _commodities .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (String? value) {
            setState(() {
              selectedValue = value;
            });
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 40,
            width: 140,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
        ),
      ),
    ),
  }

  @override
  Widget build(BuildContext context) {
    return _buildCommodityTypeDropdown();
  }
}



    //  DropdownButtonFormField<String>(
    //   decoration: InputDecoration(
    //     labelText: 'Commodity Type',
    //     labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
    //     border: OutlineInputBorder(),
    //     filled: true,
    //     fillColor: Colors.grey.shade100,
    //   ),
    //   value: _selectedCommodity,
    //   items: _commodities
    //       .map((commodity) => DropdownMenuItem<String>(
    //             value: commodity['id'].toString(),
    //             child: Text(commodity['name']),
    //           ))
    //       .toList(),
    //   onChanged: (value) {
    //     try {
    //       setState(() {
    //         _selectedCommodity = value;
    //       });
    //       context.read<appBloc>().changeItemGradeId(int.parse(value!));

    //       widget.onCommoditySelected(value);
    //       print(value);
    //     } catch (e) {
    //       print("Got this error in commDropDown $e");
    //     }
    //   },
    // );