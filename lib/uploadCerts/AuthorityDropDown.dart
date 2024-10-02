import 'package:flutter/material.dart';
import 'package:itx/Commodities.dart/ComRequest.dart';

class Authoritydropdown extends StatefulWidget {
  final Function(String?) onAuthoritydropdownSelected;

  const Authoritydropdown({Key? key, required this.onAuthoritydropdownSelected})
      : super(key: key);

  @override
  _AuthoritydropdownState createState() => _AuthoritydropdownState();
}

class _AuthoritydropdownState extends State<Authoritydropdown> {
  String? _selectedAuthority;
  List<Map<String, dynamic>> authority = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAuthority();
  }

  Future<void> _fetchAuthority() async {
    try {
      // List<Map<String, dynamic>> fetchedCommodities =
      //     await AuthoritydropdownRequest.fetchAuthority(context);
      // setState(() {
      //   authority = fetchedCommodities;
      //   _isLoading = false;
      // });
    } catch (e) {
      print('Error fetching commodities: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildAuthoritydropdownTypeDropdown() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          
        ),
      );
    }

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Authoritydropdown Type',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      value: _selectedAuthority,
      items: authority
          .map((commodity) => DropdownMenuItem<String>(
                value: commodity['id'].toString(),
                child: Text(commodity['name']),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedAuthority = value;
        });
        widget.onAuthoritydropdownSelected(value);
        print(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAuthoritydropdownTypeDropdown();
  }
}
