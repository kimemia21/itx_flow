import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:itx/Serializers/CommCert.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:itx/requests/Requests.dart';
import 'package:itx/warehouse/WareHouseHomepage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/authentication/Authorization.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';

class Regulators extends StatelessWidget {
  final List<CommoditiesCert>? commCerts; // List of CommoditiesCert objects
  final bool isWareHouse;
  Regulators({Key? key, this.commCerts, required this.isWareHouse})
      : super(key: key);

  void navigateToCertificateForm(
      BuildContext context, CommoditiesCert certificate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CertificateFormScreen(certificate: certificate),
      ),
    );
  }

  Widget _buildNoCommoditiesMessage(context) {
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
                  context: context,
                  screen: Commodities(
                    isWareHouse: false,
                  ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text('Regulators',
              style: GoogleFonts.poppins(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: commCerts != null
              ? Column(
                  children: [
                    ListView.builder(
                      shrinkWrap:
                          true, // Prevent ListView from taking infinite height
                      physics:
                          NeverScrollableScrollPhysics(), // Disable ListView scrolling
                      itemCount: commCerts!.length,
                      itemBuilder: (context, index) {
                        CommoditiesCert cert = commCerts![index];
                        return ListTile(
                          title: Text(
                              cert.certificateName ?? 'Unnamed Certificate'),
                          subtitle:
                              Text(cert.authorityName ?? 'Unknown Authority'),
                          onTap: () => navigateToCertificateForm(context, cert),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          PersistentNavBarNavigator.pushNewScreen(context,
                              screen: isWareHouse
                                  ? Warehousehomepage()
                                  : GlobalsHomePage());
                        },
                        child: Text("Skip"))
                  ],
                )
              : _buildNoCommoditiesMessage(context),
        ));
  }
}

class CertificateFormScreen extends StatefulWidget {
  final CommoditiesCert certificate;

  CertificateFormScreen({required this.certificate});

  @override
  _CertificateFormScreenState createState() => _CertificateFormScreenState();
}

class _CertificateFormScreenState extends State<CertificateFormScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  String? _expiryDate;
  String? _selectedCertificateFile;
  String? _selectedProofOfPaymentFile;

  // Collect form data in this map
  Map<String, dynamic> _formData = {};

  // Function to pick a file
  Future<void> _pickFile(String fileType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String? filePath = result.files.single.path;
      setState(() {
        if (fileType == 'certificate') {
          _selectedCertificateFile = filePath;
        } else if (fileType == 'proofOfPayment') {
          _selectedProofOfPaymentFile = filePath;
        }
      });
    }
  }

  // Function to pick an expiry date
  Future<void> _pickExpiryDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _expiryDate =
            "${pickedDate.toLocal()}".split(' ')[0]; // Formatting the date
      });
    }
  }

  // Function to handle form submission and upload
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save form fields

      _formData = {
        'expiryDate': _expiryDate,
        'certificateFile': _selectedCertificateFile,
        'proofOfPaymentFile': _selectedProofOfPaymentFile,
        'authorityName': widget.certificate.authorityName,
        'certificateName': widget.certificate.certificateName,
        'certificateFee': widget.certificate.certificateFee,
        'certificateTtl': widget.certificate.certificateTtl,
      };

      try {
        // Create the multipart request for uploading files
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${AuthRequest.main_url}/user/upload'),
        );

        // Add form fields to the request
        request.fields.addAll({
          'user':
              Provider.of<appBloc>(context, listen: false).user_id.toString(),
          'expiry': _expiryDate!,
          'commodity_id': widget.certificate.commodityId.toString(),
          'certificate_id': widget.certificate.certificateId
              .toString(), // Removed leading space
          'authority_id': widget.certificate.authorityId.toString(),
        });

        // Add files to the request if selected
        if (_selectedCertificateFile != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'certificate',
            _selectedCertificateFile!,
          ));
        }

        if (_selectedProofOfPaymentFile != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'payment_proof',
            _selectedProofOfPaymentFile!,
          ));
        }

        // Sending the request
        http.StreamedResponse response = await request.send();

        // Handle the response
        if (response.statusCode == 200) {
          String responseString = await response.stream.bytesToString();
          print('Upload successful: $responseString');
        } else {
          String responseString = await response.stream.bytesToString();
          print(
              'Upload failed: ${response.statusCode} - ${response.reasonPhrase}');
          print('Server response: $responseString');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:
            Text(widget.certificate.certificateName ?? 'Certificate Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Wrap the form in Form widget
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Authority: ${widget.certificate.authorityName ?? 'Unknown'}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                // Certificate File Picker
                ElevatedButton(
                  onPressed: () => _pickFile('certificate'),
                  child: Text(
                      'Browse ${widget.certificate.certificateName ?? 'Certificate'}'),
                ),
                if (_selectedCertificateFile != null)
                  Text("Selected file: $_selectedCertificateFile"),

                if (widget.certificate.proofOfPaymentRequired == 1) ...[
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _pickFile('proofOfPayment'),
                    child: Text(
                      'Browse Proof of Payment' +
                          (widget.certificate.certificateFee != null
                              ? ' (Fee: ${widget.certificate.certificateFee})'
                              : ''),
                    ),
                  ),
                  if (_selectedProofOfPaymentFile != null)
                    Text("Selected file: $_selectedProofOfPaymentFile"),
                ],

                SizedBox(height: 16),

                // Expiry Date Picker with Validation
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickExpiryDate(context),
                  validator: (value) {
                    if (_expiryDate == null) {
                      return 'Please pick an expiry date';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _formData['expiryDate'] = _expiryDate;
                  },
                  controller: TextEditingController(text: _expiryDate),
                ),

                if (widget.certificate.certificateTtl != null) ...[
                  SizedBox(height: 16),
                  Text(
                      'Time to Live: ${widget.certificate.certificateTtl} ${widget.certificate.certificateTtlUnits ?? ''}'),
                ],

                SizedBox(height: 24),

                // Submit button
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
