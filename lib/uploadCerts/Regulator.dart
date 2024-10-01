import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:itx/requests/Requests.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/authentication/Authorization.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';

class Regulators extends StatefulWidget {
  @override
  State<Regulators> createState() => _RegulatorsState();
}

class _RegulatorsState extends State<Regulators> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};
  List<String> commodityAuthorities = [];
  bool _isLoading = false;
  String _message = '';
  String? selectedCommodity;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    final appBlocInstance = context.read<appBloc>();
    final commodities = appBlocInstance.userCommodities;

    if (commodities != null && commodities.isNotEmpty) {
      setState(() {
        selectedCommodity = commodities.first.toString();
        _initializeFormData();
        commodityAuthorities = [
          '$selectedCommodity Authority A',
          '$selectedCommodity Authority B',
          '$selectedCommodity Authority C'
        ];
      });
    } else {
      print("No commodities found.");
    }
  }

  void _initializeFormData() {
    formData = {
      "selectedAuthorityId": null,
      "certificateController": TextEditingController(),
      "certificateFileName": TextEditingController(),
      "expiryDateController": TextEditingController(),
      "proofOfPaymentController": TextEditingController(),
      "proofOfPaymentFileName": TextEditingController()
    };
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
        controller.text = result.files.first.path!;
      });
    }
  }

  Future<void> uploadData() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    if (_formKey.currentState?.validate() ?? false) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('${AuthRequest.main_url}/user/upload'));

      request.fields.addAll({
        // 'x-auth-token':Provider.of<appBloc>(context,listen: false).token,
        'api': '7',
        'user': Provider.of<appBloc>(context, listen: false).user_id.toString(),
        'certificate_type': selectedCommodity!,
        'expiry': formData['expiryDateController'].text,
      });

      if (formData['certificateFileName'].text.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
            'certificate', formData['certificateFileName'].text));
      }

      if (formData['proofOfPaymentFileName'].text.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
            'payment_proof', formData['proofOfPaymentFileName'].text));
      }

      try {
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          print("Upload successful");
          Globals.switchScreens(context: context, screen: Authorization());
        } else {
          Globals.warningsAlerts(
            title: "Upload failed",
            content: 'Upload failed: ${response.reasonPhrase}',
            context: context,
          );
        }
      } catch (e) {
        Globals.warningsAlerts(
          title: "Upload failed",
          content: 'Upload failed: $e',
          context: context,
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Color _getButtonColor({required String fileName}) {
    if (fileName.isEmpty) {
      return Colors.red.shade400;
    } else if (fileName.toLowerCase().endsWith('.pdf')) {
      return Colors.blue.shade400;
    } else {
      return Colors.green.shade400;
    }
  }

  Widget buttons(
      {required void Function() onPressed,
      required String title,
      required Color color}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 5,
        shadowColor: Colors.black26,
        side: BorderSide(
          color: color,
          width: 2,
        ),
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_message.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text(_message)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        leading: IconButton(
          onPressed: () =>
              Globals.switchScreens(context: context, screen: Commodities()),
          icon: Icon(color: Colors.white, Icons.arrow_back),
        ),
        title: Text(
          'Regulators',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.green.shade800,
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: selectedCommodity == null
            ? _buildNoCommoditiesMessage()
            : _buildForm(),
      ),
    );
  }

  Widget _buildNoCommoditiesMessage() {
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
              Globals.switchScreens(context: context, screen: Commodities());
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.green.shade800,
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

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Commodity: $selectedCommodity',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildCommodityForm(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buttons(
                    onPressed: () => Globals.switchScreens(
                        context: context, screen: Commodities()),
                    title: "Back",
                    color: Colors.grey.shade300,
                  ),
                  buttons(
                    onPressed: uploadData,
                    title: 'Submit',
                    color: Colors.green.shade800,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommodityForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormField(
          'Authority',
          DropdownButtonFormField<String>(
            value: formData['selectedAuthorityId'],
            items: commodityAuthorities.map((String authority) {
              return DropdownMenuItem<String>(
                value: authority,
                child: Text(authority),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                formData['selectedAuthorityId'] = newValue;
              });
            },
            decoration: InputDecoration(
              hintText: "Select $selectedCommodity Authority",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
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
            controller: formData['certificateController'],
            decoration: InputDecoration(
              hintText: 'Enter or upload certificate URL',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
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
        _buildFileUploadRow(
          'Upload $selectedCommodity authority Certificate',
          formData['certificateFileName'],
        ),
        _buildFormField(
          'Expiry Date',
          TextFormField(
            controller: formData['expiryDateController'],
            decoration: InputDecoration(
              hintText: 'Select $selectedCommodity Certificate Expiry Date',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
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
              await _selectDate(context, formData['expiryDateController']);
            },
          ),
        ),
        _buildFormField(
          'Proof of Payment',
          TextFormField(
            controller: formData['proofOfPaymentController'],
            decoration: InputDecoration(
              hintText: 'Enter or upload proof of payment',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
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
        _buildFileUploadRow(
          'Upload $selectedCommodity proof Of Payment',
          formData['proofOfPaymentFileName'],
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
            child: field,
          ),
        ],
      ),
    );
  }

  Widget _buildFileUploadRow(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: ElevatedButton.icon(
            onPressed: () => _pickFile(controller),
            icon: Icon(Icons.upload_file),
            label: Text(
              label,
              overflow: TextOverflow.ellipsis,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getButtonColor(fileName: controller.text),
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
            visible: controller.text.isNotEmpty,
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
                      controller.text,
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
    );
  }
}
