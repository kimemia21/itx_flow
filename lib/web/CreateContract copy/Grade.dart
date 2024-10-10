import 'package:flutter/material.dart';
import 'package:itx/Commodities.dart/GradesReq.dart';
import 'package:itx/Serializers/Grade.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:provider/provider.dart';

class WebGradeDropdown extends StatefulWidget {
  final Function(String?) onGradeSelectedId;

  const WebGradeDropdown({Key? key, required this.onGradeSelectedId})
      : super(key: key);

  @override
  _WebGradeDropdownState createState() => _WebGradeDropdownState();
}

class _WebGradeDropdownState extends State<WebGradeDropdown> {
  String? _selectedCommodity;

  Future<List<Grade>> _fetchGrades(int commodityID) async {
    return GradeRequest.fetchGrade(context, commodityID);
  }

  @override
  Widget build(BuildContext context) {
    final commodityID = Provider.of<appBloc>(context).commId;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Center(
            child: Container(
              width: constraints.maxWidth > 600 ? 400 : constraints.maxWidth * 0.9,
              child: FutureBuilder<List<Grade>>(
                future: _fetchGrades(commodityID),
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
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(2, 3),
                  ),
                ],
                color: Colors.white,
              ),
            ),
          ),
        );
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
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
