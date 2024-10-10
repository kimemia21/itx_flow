import 'package:flutter/material.dart';
import 'package:itx/Commodities.dart/GradesReq.dart';
import 'package:itx/Serializers/Grade.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:provider/provider.dart';

class GradeDropdown extends StatefulWidget {
  final Function(String?) onGradeSelectedId;

  const GradeDropdown({Key? key, required this.onGradeSelectedId})
      : super(key: key);

  @override
  _GradeDropdownState createState() => _GradeDropdownState();
}

class _GradeDropdownState extends State<GradeDropdown> {
  String? _selectedCommodity;

  Future<List<Grade>> _fetchGrades(int commodityID) async {
    return GradeRequest.fetchGrade(context, commodityID);
  }

  @override
  Widget build(BuildContext context) {
    final commodityID = Provider.of<appBloc>(context).commId;

    return FutureBuilder<List<Grade>>(
      future: _fetchGrades(
          commodityID), // Fetch packing data with updated commodityID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Grades options available'));
        } else {
          return _buildCommodityTypeDropdown(snapshot.data!);
        }
      },
    );
  }

  Widget _buildCommodityTypeDropdown(List<Grade> grades) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Grade Type',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      value: _selectedCommodity,
      items: grades
          .map((e) => DropdownMenuItem<String>(
                value: e.id.toString(),
                child: Text(e.gradeName),
              ))
          .toList(),
      onChanged: (value) {
        widget.onGradeSelectedId(value);
        setState(() {
          _selectedCommodity = value;
        });
      },
    );
  }
}
