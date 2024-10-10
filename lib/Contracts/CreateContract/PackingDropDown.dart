import 'package:flutter/material.dart';
import 'package:itx/Commodities.dart/ComRequest.dart';
import 'package:itx/Serializers/Packing.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:provider/provider.dart';

class PackingDropdown extends StatefulWidget {
  final Function(String?, String?) onPackingSelected;

  const PackingDropdown({Key? key, required this.onPackingSelected})
      : super(key: key);

  @override
  _PackingDropdownState createState() => _PackingDropdownState();
}

class _PackingDropdownState extends State<PackingDropdown> {
  String? _selectedCommodity;
  late Future<List<Packing>> _packingsFuture;

  @override
  void initState() {
    super.initState();
    _packingsFuture = _fetchPacking();
  }

  Future<List<Packing>> _fetchPacking() async {
    final commodityID = Provider.of<appBloc>(context, listen: false).commId;
    return CommodityService.CommodityPacking(
      context: context,
      Id: commodityID,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Packing>>(
      future: _packingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No packing options available'));
        } else {
          return _buildCommodityTypeDropdown(snapshot.data!);
        }
      },
    );
  }

  Widget _buildCommodityTypeDropdown(List<Packing> packings) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Packing Type',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      value: _selectedCommodity,
      items: packings
          .map((e) => DropdownMenuItem<String>(
                value: e.packaging_id.toString(),
                child: Text(e.packaging_name),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCommodity = value;
        });

        if (value != null) {
          Packing selectedPacking = packings.firstWhere(
            (e) => e.packaging_id.toString() == value,
            orElse: () => throw Exception('Packing not found for ID: $value'),
          );

          widget.onPackingSelected(
            selectedPacking.packaging_id.toString(),
            selectedPacking.packaging_name,
          );

          context.read<appBloc>().changeItemGradeId(int.parse(value));
        }
      },
    );
  }
}