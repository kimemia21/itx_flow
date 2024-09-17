import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/authentication/Authorization.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:provider/provider.dart';

class Regulators extends StatefulWidget {
  @override
  State<Regulators> createState() => _RegulatorsState();
}

class _RegulatorsState extends State<Regulators> {
  final _formKey = GlobalKey<FormState>();
  int currentIndex = 0;
  Map<String, Map<String, dynamic>> formData = {};
  Map<String, List<String>> commodityAuthorities = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appBlocInstance = context.read<appBloc>();
      final commodities = appBlocInstance?.userCommodities;

      if (commodities != null) {
        for (var commodity in commodities) {
          _initializeFormData(commodity.toString());
          commodityAuthorities[commodity.toString()] = [
            '$commodity Authority A',
            '$commodity Authority B',
            '$commodity Authority C'
          ];
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
      print(data);
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
        final data = getFormData();
        if (data != null) {
          print(data);
          CommodityService.PostContracts(context);
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
      Globals.switchScreens(context: context, screen: Authorization());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        leading: IconButton.filled(
            onPressed: () =>
                Globals.switchScreens(context: context, screen: Commodities()),
            icon: Icon(Icons.arrow_back)),
        title: Text(
          'Regulators',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green.shade800,
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<String>>(
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
                            child: Text(
                              'Skip',
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade400,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _nextForm,
                            child: Text(
                              currentIndex == commodities.length - 1
                                  ? 'Submit'
                                  : 'Next',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade800,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
      ),
    );
  }

  Widget _buildCommodityForm(String commodity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(
          'Authority',
          DropdownButtonFormField<String>(
            value: formData[commodity]!['selectedAuthorityId'],
            items: commodityAuthorities[commodity]?.map((String authority) {
              return DropdownMenuItem<String>(
                value: authority,
                child: Text(authority),
              );
            }).toList() ?? [],
            onChanged: (String? newValue) {
              setState(() {
                formData[commodity]!['selectedAuthorityId'] = newValue;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        _buildFormField(
          'Expiry Date',
          TextFormField(
            controller: formData[commodity]!['expiryDateController'],
            decoration: InputDecoration(
              hintText: 'Select date',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Please select a date' : null,
            onTap: () async {
              FocusScope.of(context).requestFocus(new FocusNode());
              await _selectDate(
                  context, formData[commodity]!['expiryDateController']);
            },
          ),
        ),
        SizedBox(height: 8),
        _buildFormField(
          'Proof of Payment',
          TextFormField(
            controller: formData[commodity]!['proofOfPaymentController'],
            decoration: InputDecoration(
              hintText: 'Enter or upload proof of payment',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter or upload proof of payment'
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
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          field,
        ],
      ),
    );
  }
}