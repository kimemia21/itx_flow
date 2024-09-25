import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        "certificateFileName": TextEditingController(),
        "expiryDateController": TextEditingController(),
        "proofOfPaymentController": TextEditingController(),
        "proofOfPaymentFileName": TextEditingController()
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

  
  void _saveCurrentFormData() {
    final currentCommodity = context.read<appBloc>().userCommodities[currentIndex].toString();
    formData[currentCommodity]!['selectedAuthorityId'] = formData[currentCommodity]!['selectedAuthorityId'];
    // Save other form fields if necessary
  }

 void _nextForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Save the current form data
      _saveCurrentFormData();
      
      if (currentIndex < context.read<appBloc>().userCommodities.length - 1) {
        setState(() {
          currentIndex++;
        });
      } else {
        final data = getFormData();
        if (data != null) {
          
          print(data);
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

  void _backForm() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--; // Move back one step
      });
    } else {
      Globals.switchScreens(
          context: context,
          screen: Commodities()); // Go back to the previous screen
    }
  }

  Color _getButtonColor({required String fileName}) {
    // final fileName = formData[commodity]!['certificateFileName'].text;
    if (fileName.isEmpty) {
      return Colors.red.shade400;
    } else if (fileName.toLowerCase().endsWith('.pdf')) {
      return Colors.blue.shade400;
    } else {
      return Colors.green.shade400;
    }
  }

  Widget buttons({required void Function() onPressed, required String title, required Color color}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color:
              Colors.black87, // Slightly darker text color for better contrast
          fontWeight: FontWeight.w600,
          fontSize: 16, // Increase font size for readability
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Softer background color
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), // Rounded corners
        ),
        elevation: 5, // Elevation to give the button a 3D look
        shadowColor: Colors.black26, // Subtle shadow effect
        side: BorderSide(
          color: color, // Border color for a more defined look
          width: 2, // Border width
        ),
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        leading: IconButton(
            onPressed: () =>
                Globals.switchScreens(context: context, screen: Commodities()),
            icon: Icon(color: Colors.white, Icons.arrow_back)),
        title: Text(
          'Regulators',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green.shade800,
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: FutureBuilder<List<String>>(
          future: _initializeData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Please Select Commodities to be able to upload certs",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Globals.switchScreens(
                            context: context, screen: Commodities());
                        // Logic for selecting commodities goes here
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.green.shade800, // Button color
                      ),
                      child: const Text(
                        "Select Commodities",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
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
                          buttons(onPressed: _backForm, title: "Back", color: Colors.grey.shade300),
                          buttons(onPressed: _skipForm, title: "Skip", color: Colors.grey.shade300),
                         buttons(onPressed: _nextForm, title:  currentIndex == commodities.length - 1
                                  ? 'Submit'
                                  : 'Next', color:  Colors.green.shade800),


                    
                          // ElevatedButton(
                          //   onPressed: _nextForm,
                          //   child: Text(
                          //     currentIndex == commodities.length - 1
                          //         ? 'Submit'
                          //         : 'Next',
                          //     style: GoogleFonts.poppins(
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.w600),
                          //   ),
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.green.shade800,
                          //     padding: EdgeInsets.symmetric(
                          //         vertical: 15, horizontal: 20),
                          //     textStyle: GoogleFonts.poppins(
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ),
                          // ),
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
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setDropdownState) {
              return DropdownButtonFormField<String>(
                value: formData[commodity]!['selectedAuthorityId'],
                items: commodityAuthorities[commodity]?.map((String authority) {
                  return DropdownMenuItem<String>(
                    value: authority,
                    child: Text(authority),
                  );
                }).toList() ?? [],
                onChanged: (String? newValue) {
                  setDropdownState(() {
                    formData[commodity]!['selectedAuthorityId'] = newValue;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Select $commodity Authority",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value == null ? 'Please select an authority' : null,
              );
            },
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
                  borderSide: BorderSide.none
                  //  BorderSide(color: Colors.grey
                  //  ),
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
        // SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: () =>
                    _pickFile(formData[commodity]!['certificateFileName']),
                icon: Icon(Icons.upload_file),
                label: Text(
                  'Upload $commodity authority Certificate',
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(
                      fileName:
                          formData[commodity]!['certificateFileName'].text),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Visibility(
                visible:
                    formData[commodity]!['certificateFileName'].text.isNotEmpty,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.file_present,
                          size: 16, color: Colors.grey.shade700),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          formData[commodity]!['certificateFileName'].text,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        _buildFormField(
          'Expiry Date',
          TextFormField(
            controller: formData[commodity]!['expiryDateController'],
            decoration: InputDecoration(
              hintText: 'Select  $commodity Certificate Expiry Date',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none
                  //  BorderSide(color: Colors.grey
                  //  ),
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
        // SizedBox(height: 8),
        _buildFormField(
          'Proof of Payment',
          TextFormField(
            controller: formData[commodity]!['proofOfPaymentController'],
            decoration: InputDecoration(
              hintText: 'Enter or upload proof of payment',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none
                  //  BorderSide(color: Colors.grey
                  //  ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: ElevatedButton.icon(
                onPressed: () =>
                    _pickFile(formData[commodity]!['proofOfPaymentFileName']),
                icon: Icon(Icons.upload_file),
                label: Text(
                  'Upload $commodity proof Of Payment ',
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(
                      fileName:
                          formData[commodity]!['proofOfPaymentFileName'].text),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Visibility(
                visible: formData[commodity]!['proofOfPaymentFileName']
                    .text
                    .isNotEmpty,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.file_present,
                          size: 16, color: Colors.grey.shade700),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          formData[commodity]!['proofOfPaymentFileName'].text,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
          SizedBox(height: 10),
          Container(
              height: 60,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: field),
        ],
      ),
    );
  }
}
