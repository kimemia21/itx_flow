import 'package:flutter/material.dart';
import 'package:itx/Commodities.dart/GradesReq.dart';
import 'package:itx/Serializers/Grade.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:provider/provider.dart';

class GradeDropdown extends StatefulWidget {
  final Function(String?, String?) onGradeSelectedId;

  const GradeDropdown({Key? key, required this.onGradeSelectedId})
      : super(key: key);

  @override
  _GradeDropdownState createState() => _GradeDropdownState();
}

class _GradeDropdownState extends State<GradeDropdown> {
  String? _selectedGradeId;
  String? _selectedGradeName;

  Future<List<Grade>> _fetchGrades(int commodityID) async {
    return GradeRequest.fetchGrade(context, commodityID);
  }

  @override
  Widget build(BuildContext context) {
    final commodityID = Provider.of<appBloc>(context).commId;

    return FutureBuilder<List<Grade>>(
      future: _fetchGrades(commodityID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Grades options available'));
        } else {
          return _buildGradeDropdown(snapshot.data!);
        }
      },
    );
  }

  Widget _buildGradeDropdown(List<Grade> grades) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Grade Type',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      value: _selectedGradeId,
      hint: Text('Select Grade'),
      items: grades
          .map((grade) => DropdownMenuItem<String>(
                value: grade.id.toString(),
                child: Text(grade.gradeName),
              ))
          .toList(),
      onChanged: (String? selectedGradeId) {
        if (selectedGradeId != null) {
          // Find the corresponding grade name
          final selectedGrade = grades.firstWhere(
            (grade) => grade.id.toString() == selectedGradeId
          );

          setState(() {
            _selectedGradeId = selectedGradeId;
            _selectedGradeName = selectedGrade.gradeName;
          });

          // Call the callback with both ID and name
          widget.onGradeSelectedId(selectedGradeId, selectedGrade.gradeName);
        }
      },
    );
  }
}