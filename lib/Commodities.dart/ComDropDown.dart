import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Commodities.dart/ComRequest.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart'; // Make sure to import the dropdown package

class CommodityDropdown extends StatefulWidget {
  final bool isForAppBar;
  final Function(int?,String?) onCommoditySelected;



  const CommodityDropdown({
    Key? key,
    required this.onCommoditySelected,
    required this.isForAppBar,
  }) : super(key: key);

  @override
  _CommodityDropdownState createState() => _CommodityDropdownState();
}

class _CommodityDropdownState extends State<CommodityDropdown> {
  String? _selectedCommodity;
  List<model> _commodities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCommodities();
  }

  Future<void> _fetchCommodities() async {
    try {
      print("Fetching commodities...");
      _commodities = await CommodityRequest.fetchCommodities(context);
      setState(() {
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

    return DropdownButtonHideUnderline(
      child: DropdownButton2<model>(
        isExpanded: true,
        hint: Text(
          'Select commodity',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: _commodities
            .map((model item) => DropdownMenuItem<model>(
                  value: item,
                  child: Text(
                    item.commodityName,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          try {
            context.read<appBloc>().changeCommodityName(value!.commodityName);

            context.read<appBloc>().changeItemGradeId(value!.commodityId);
            context.read<appBloc>().changeCommoditySummary(
                CommodityService.ContractsSummary(context: context,commodityId: value.commodityId));

            widget.onCommoditySelected(value.commodityId, value.commodityName);
            print(value.commodityName);
          } catch (e) {
            print("Got this error in commDropDown $e");
          }
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCommodityTypeDropdown();
  }
}



// DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         labelText: 'Commodity Type',
//         border: OutlineInputBorder(),
//         filled: true,
//         fillColor: Colors.grey.shade100,
//       ),
//       value: _selectedCommodity,
//       items: _commodities
//           .map((commodity) => DropdownMenuItem<String>(
//                 value: commodity['id'].toString(),
//                 child: Text(commodity['name']),
//               ))
//           .toList(),
//       onChanged: (value) {
//         try {
//           setState(() {
//             _selectedCommodity = value;
//           });
//           context.read<appBloc>().changeItemGradeId(int.parse(value!));

//           widget.onCommoditySelected(value);
//           print(value);
//         } catch (e) {
//           print("Got this error in commDropDown $e");
//         }
//       },
//     );