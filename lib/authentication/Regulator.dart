import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:itx/authentication/Authorization.dart';
import 'package:itx/fromWakulima/globals.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:provider/provider.dart';

class Regulators extends StatefulWidget {
  @override
  State<Regulators> createState() => _RegulatorsState();
}

class _RegulatorsState extends State<Regulators> {
  final _formKey = GlobalKey<FormState>();
  int currentIndex = 0;
  Map<String, Map<String, dynamic>> formData = {};

  Map<int, String> authorities = {
    1: 'Authority A',
    2: 'Authority B',
  };

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final appBlocInstance = context.read<appBloc>();
    final commodities = appBlocInstance?.userCommodities;

    if (commodities != null) {
      for (var commodity in commodities) {
        _initializeFormData(commodity.toString());
      }
    } else {
      print("No commodities found.");
    }
  });
}

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickFile(TextEditingController controller) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        controller.text = result.files.first.name;
      });
    }
  }

  void _initializeFormData(String commodity) {
    if (!formData.containsKey(commodity)) {
      formData[commodity] = {
        "selectedAuthorityId": null,
        "certificateController": TextEditingController(),
        "expiryDateController": TextEditingController(),
        "proofOfPaymentController": TextEditingController(),
      };
    }
  }

  Map<String, dynamic>? getFormData() {
    if (_formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> data = {};
      formData.forEach((commodity, commodityData) {
        data["${commodity}_authority_id"] =
            commodityData["selectedAuthorityId"];
        data["${commodity}_certificate"] =
            commodityData["certificateController"].text;
        data["${commodity}_expiry_date"] =
            commodityData["expiryDateController"].text;
        data["${commodity}_proof_of_payment"] =
            commodityData["proofOfPaymentController"].text;
      });
      return data;
    }
    return null;
  }
   Future<List<String>> _initializeData() async {
    final appBlocInstance = context.read<appBloc>();
    final commodities = appBlocInstance.userCommodities;

    if (commodities != null && commodities.isNotEmpty) {
      for (var commodity in commodities) {
        _initializeFormData(commodity.toString());
      }
      return commodities.map((c) => c.toString()).toList();
    } else {
      return [];
    }
  }

  void _nextForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (currentIndex < context.read<appBloc>().userCommodities.length - 1) {
        setState(() {
          currentIndex++;
        });
      } else {
        // All forms are filled, proceed to next screen
        final data = getFormData();
        if (data != null) {
          print(data);
          Globals.switchScreens(context: context, screen: Authorization());
        }
      }
    }
  }

  void _skipForm() {
    if (currentIndex < context.read<appBloc>().userCommodities.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // Reached the last form, proceed to next screen
      Globals.switchScreens(context: context, screen: Authorization());
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regulators',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.green.shade100,
      ),
      body: FutureBuilder<List<String>>(
        future: _initializeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No commodities available"));
          }

          final commodities = snapshot.data!;
          final currentCommodity = commodities[currentIndex];

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Commodity: $currentCommodity',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    _buildCommodityForm(currentCommodity),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _skipForm,
                          child: Text('Skip'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _nextForm,
                          child: Text(currentIndex == commodities.length - 1
                              ? 'Submit'
                              : 'Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _buildCommodityForm(String commodity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(
          'Authority',
          DropdownButtonFormField<int>(
            value: formData[commodity]!['selectedAuthorityId'],
            items: authorities.entries
                .map<DropdownMenuItem<int>>(
                  (entry) => DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  ),
                )
                .toList(),
            onChanged: (int? newValue) {
              setState(() {
                formData[commodity]!['selectedAuthorityId'] = newValue;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) =>
                value == null ? 'Please select an authority' : null,
          ),
        ),
        _buildFormField(
          'Certificate URL',
          TextFormField(
            controller: formData[commodity]!['certificateController'],
            decoration: InputDecoration(
              hintText: 'Enter or upload certificate URL',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter or upload a certificate URL'
                : null,
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () =>
              _pickFile(formData[commodity]!['certificateController']),
          icon: Icon(Icons.upload_file),
          label: Text('Upload Certificate'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        _buildFormField(
          'Expiry Date',
          TextFormField(
            controller: formData[commodity]!['expiryDateController'],
            decoration: InputDecoration(
              hintText: 'Select date',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () => _selectDate(
                context, formData[commodity]!['expiryDateController']),
            validator: (value) => value == null || value.isEmpty
                ? 'Please select an expiry date'
                : null,
          ),
        ),
        _buildFormField(
          'Proof of Payment URL',
          TextFormField(
            controller: formData[commodity]!['proofOfPaymentController'],
            decoration: InputDecoration(
              hintText: 'Enter or upload proof of payment URL',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter or upload a proof of payment URL'
                : null,
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () =>
              _pickFile(formData[commodity]!['proofOfPaymentController']),
          icon: Icon(Icons.upload_file),
          label: Text('Upload Proof of Payment'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFormField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        field,
        SizedBox(height: 16),
      ],
    );
  }
}
