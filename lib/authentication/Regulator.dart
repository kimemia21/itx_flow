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

  List<String> selectedCommodities = [];
  Map<String, Map<String, dynamic>> formData = {};

  Map<int, String> authorities = {
    1: 'Authority A',
    2: 'Authority B',
  };

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

  void _addCommodityForm(String commodity) {
    if (!selectedCommodities.contains(commodity)) {
      setState(() {
        selectedCommodities.add(commodity);
        formData[commodity] = {
          "selectedAuthorityId": null,
          "certificateController": TextEditingController(),
          "expiryDateController": TextEditingController(),
          "proofOfPaymentController": TextEditingController(),
        };
      });
    }
  }

Map<String, dynamic>? getFormData() {
  if (_formKey.currentState?.validate() ?? false) {
    // Flatten the formData map into a single map
    Map<String, dynamic> flattenedData = {};

    formData.forEach((commodity, data) {
      flattenedData["${commodity}_authority_id"] = data["selectedAuthorityId"];
      flattenedData["${commodity}_certificate"] = data["certificateController"].text;
      flattenedData["${commodity}_expiry_date"] = data["expiryDateController"].text;
      flattenedData["${commodity}_proof_of_payment"] = data["proofOfPaymentController"].text;
    });

    return flattenedData;
  }
  return null;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regulators',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.green.shade100,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Commodity',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
          DropdownButtonFormField<int>(
  isExpanded: true,
  items: context.watch<appBloc>().userCommodities.asMap().entries.map<DropdownMenuItem<int>>(
    (entry) {
      int index = entry.key;
      String commodityName = entry.value; // Expecting a String here
      return DropdownMenuItem<int>(
        value: index,
        child: Text(commodityName), // Using the String directly
        onTap: () {
          _addCommodityForm(commodityName); // Passing the name directly as a String
        },
      );
    },
  ).toList(),
  onChanged: (int? newIndex) {
    if (newIndex != null) {
      final selectedCommodityName = context.read<appBloc>().userCommodities[newIndex]; // Expecting a String here
      _addCommodityForm(selectedCommodityName); // Passing the name directly as a String
    }
  },
  hint: Text('Select Commodity'),
  validator: (value) => value == null ? 'Please select a commodity' : null,
),

              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedCommodities.length,
                  itemBuilder: (context, index) {
                    final commodity = selectedCommodities[index];
                    final controllers = formData[commodity];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Commodity: $commodity',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Authority',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        DropdownButtonFormField<int>(
                          value: controllers!['selectedAuthorityId'],
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
                              controllers['selectedAuthorityId'] = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) => value == null
                              ? 'Please select an authority'
                              : null,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Certificate URL',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: controllers['certificateController'],
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
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () =>
                              _pickFile(controllers['certificateController']),
                          icon: Icon(Icons.upload_file),
                          label: Text('Upload Certificate'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Expiry Date',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: controllers['expiryDateController'],
                          decoration: InputDecoration(
                            hintText: 'Select date',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () => _selectDate(
                              context, controllers['expiryDateController']),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please select an expiry date'
                              : null,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Proof of Payment URL',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: controllers['proofOfPaymentController'],
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
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () => _pickFile(
                              controllers['proofOfPaymentController']),
                          icon: Icon(Icons.upload_file),
                          label: Text('Upload Proof of Payment'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        Divider(
                            height: 40,
                            thickness: 2,
                            color: Colors.grey.shade300),
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final data = getFormData();
                  if (data != null) {
                    Globals.switchScreens(context: context, screen:Authorization() );
                    print(data);
                    // Process the form data
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
