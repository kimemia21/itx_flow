import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:itx/Serializers/CommCert.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:itx/requests/Requests.dart';
import 'package:itx/uploadCerts/Authorization.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/globals.dart';

class Regulators extends StatelessWidget {
  final List<CommoditiesCert>? commCerts;
  final bool isWareHouse;

  Regulators({Key? key, this.commCerts, required this.isWareHouse})
      : super(key: key);

  Widget _buildNoCommoditiesMessage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                screen: Commodities(isWareHouse: false),
              );
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
              style: TextStyle(fontSize: 16, color: Colors.white),
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
        title:
            Text('Regulators', style: GoogleFonts.poppins(color: Colors.white)),
      ),
      body: commCerts != null
          ? CertificateFormScreen(
              certificates: commCerts!, isWareHouse: isWareHouse)
          : _buildNoCommoditiesMessage(context),
    );
  }
}

class CertificateFormScreen extends StatefulWidget {
  final List<CommoditiesCert> certificates;
  final bool isWareHouse;

  CertificateFormScreen(
      {required this.certificates, required this.isWareHouse});

  @override
  _CertificateFormScreenState createState() => _CertificateFormScreenState();
}

class _CertificateFormScreenState extends State<CertificateFormScreen> {
  final List<GlobalKey<FormState>> _formKeys = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Map<int, String?> _expiryDates = {};
  Map<int, String?> _selectedCertificateFiles = {};
  Map<int, String?> _selectedProofOfPaymentFiles = {};

  @override
  void initState() {
    super.initState();
    _formKeys.addAll(List.generate(
        widget.certificates.length, (index) => GlobalKey<FormState>()));
  }

  Future<void> _pickFile(int certificateId, String fileType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String? filePath = result.files.single.path;
      setState(() {
        if (fileType == 'certificate') {
          _selectedCertificateFiles[certificateId] = filePath;
        } else if (fileType == 'proofOfPayment') {
          _selectedProofOfPaymentFiles[certificateId] = filePath;
        }
      });
    }
  }

  Future<void> _pickExpiryDate(BuildContext context, int certificateId) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _expiryDates[certificateId] = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _submitForm(CommoditiesCert certificate) async {
    final formKey = _formKeys[_currentPage];
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final appBloc bloc = context.read<appBloc>();

      try {
        bloc.changeIsLoading(true);

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${AuthRequest.main_url}/user/upload'),
        );

        request.fields.addAll({
          'user':
              Provider.of<appBloc>(context, listen: false).user_id.toString(),
          'expiry': _expiryDates[certificate.certificateId] ?? '',
          'commodity_id': certificate.commodityId.toString(),
          'certificate_id': certificate.certificateId.toString(),
          'authority_id': certificate.authorityId.toString(),
        });

        if (_selectedCertificateFiles[certificate.certificateId] != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'certificate',
            _selectedCertificateFiles[certificate.certificateId]!,
          ));
        }

        if (_selectedProofOfPaymentFiles[certificate.certificateId] != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'payment_proof',
            _selectedProofOfPaymentFiles[certificate.certificateId]!,
          ));
        }

        http.StreamedResponse response =
            await request.send().timeout(Duration(seconds: 10));

        if (response.statusCode == 200) {
          bloc.changeIsLoading(false);
          String responseString = await response.stream.bytesToString();
          print(
              'Upload successful for certificate ${certificate.certificateId}: $responseString');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Certificate uploaded successfully')),
          );

          // Move to the next certificate or finish if it's the last one
          if (_currentPage < widget.certificates.length - 1) {
            _pageController.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          } else {
            context.read<appBloc>().changeIsAuthorized(1);
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: AuthorizationStatus(isWareHouse: widget.isWareHouse),
            );
          }
        } else {
          bloc.changeIsLoading(false);
          String responseString = await response.stream.bytesToString();
          print(
              'Upload failed for certificate ${certificate.certificateId}: ${response.statusCode} - ${response.reasonPhrase}');
          print('Server response: $responseString');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload certificate')),
          );
        }
      } catch (e) {
        bloc.changeIsLoading(false);
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('An error occurred while uploading certificate')),
        );
      }
    }
  }

  Widget _buildCertificateSection(CommoditiesCert certificate, int index) {
    return Form(
      key: _formKeys[index],
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                certificate.certificateName ?? 'Unnamed Certificate',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(certificate.authorityName ?? 'Unknown Authority',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () =>
                    _pickFile(certificate.certificateId!, 'certificate'),
                icon: Icon(Icons.upload_file),
                label: Text(
                    'Upload ${certificate.certificateName ?? 'Certificate'}'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              if (_selectedCertificateFiles[certificate.certificateId] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                      "Selected file: ${_selectedCertificateFiles[certificate.certificateId]}",
                      style: TextStyle(color: Colors.green)),
                ),
              if (_selectedCertificateFiles[certificate.certificateId] == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Certificate file is required',
                      style: TextStyle(color: Colors.red)),
                ),
              if (certificate.proofOfPaymentRequired == 1) ...[
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () =>
                      _pickFile(certificate.certificateId!, 'proofOfPayment'),
                  icon: Icon(Icons.attach_money),
                  label: Text('Upload Proof of Payment' +
                      (certificate.certificateFee != null
                          ? ' (Fee: ${certificate.certificateFee})'
                          : '')),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                if (_selectedProofOfPaymentFiles[certificate.certificateId] !=
                    null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                        "Selected file: ${_selectedProofOfPaymentFiles[certificate.certificateId]}",
                        style: TextStyle(color: Colors.green)),
                  ),
                if (_selectedProofOfPaymentFiles[certificate.certificateId] ==
                    null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Proof of payment file is required',
                        style: TextStyle(color: Colors.red)),
                  ),
              ],
              SizedBox(height: 24),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                onTap: () =>
                    _pickExpiryDate(context, certificate.certificateId!),
                validator: (value) {
                  if (_expiryDates[certificate.certificateId] == null) {
                    return 'Please pick an expiry date';
                  }
                  return null;
                },
                controller: TextEditingController(
                    text: _expiryDates[certificate.certificateId]),
              ),
              if (certificate.certificateTtl != null) ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                          'Time to Live: ${certificate.certificateTtl} ${certificate.certificateTtlUnits ?? ''}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemCount: widget.certificates.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            child: _buildCertificateSection(widget.certificates[index], index),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back/Cancel Button
                TextButton(
                  onPressed: () {
                    final status =
                        Provider.of<appBloc>(context, listen: false).isLoading;
                    if (status) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Please wait, upload in progress')),
                      );
                    } else if (_currentPage > 0) {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue.shade700,
                    backgroundColor: Colors.blue.shade50,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.blue.shade200),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _currentPage > 0 ? Icons.arrow_back : Icons.cancel,
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _currentPage > 0 ? 'Back' : 'Cancel',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    final status =
                        Provider.of<appBloc>(context, listen: false).isLoading;
                    if (status) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Please wait, upload in progress')),
                      );
                    } else {
                      _submitForm(widget.certificates[_currentPage]);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green.shade600,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: context.watch<appBloc>().isLoading
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white,
                          size: 20,
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, size: 18),
                            SizedBox(width: 4),
                            Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                ),

                // Skip/Finish Button
                TextButton(
                  onPressed: () {
                    final status =
                        Provider.of<appBloc>(context, listen: false).isLoading;
                    if (status) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Please wait, upload in progress')),
                      );
                    } else if (_currentPage < widget.certificates.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthorizationStatus(
                              isWareHouse: widget.isWareHouse),
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.orange.shade700,
                    backgroundColor: Colors.orange.shade50,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.orange.shade200),
                    ),
                  ),
                  child: context.watch<appBloc>().isLoading
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.orange.shade700,
                          size: 20,
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _currentPage < widget.certificates.length - 1
                                  ? Icons.skip_next
                                  : Icons.done_all,
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              _currentPage < widget.certificates.length - 1
                                  ? 'Skip'
                                  : 'Finish',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                ),
              ],
            )),
      ),
    );
  }
}
