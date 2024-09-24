import 'package:flutter/material.dart';
import 'package:itx/Commodities.dart/ComRequest.dart';
import 'package:itx/Commodities.dart/GradesReq.dart';

class GradeDropdown extends StatefulWidget {
  final Function(String?) onGradeSelected;

  const GradeDropdown({Key? key, required this.onGradeSelected})
      : super(key: key);

  @override
  _GradeDropdownState createState() => _GradeDropdownState();
}

class _GradeDropdownState extends State<GradeDropdown> {
  String? _selectedGrade;
  List<Map<String, dynamic>> _grades = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGrades();
  }

  Future<void> _fetchGrades() async {
    try {
      List<Map<String, dynamic>> fetchedGrades =
          await GradeRequest.fetchGrade(context);
      setState(() {
        _grades = fetchedGrades;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching grades: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildGradeTypeDropdown() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          
        ),
      );
    }

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Grade Type',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      value: _selectedGrade,
      items: _grades
          .map((grade) => DropdownMenuItem<String>(
                value: grade['grade_id'].toString(),
                child: Text(grade['grade']),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedGrade = value;
        });
        widget.onGradeSelected(value);
        print(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildGradeTypeDropdown();
  }
}
