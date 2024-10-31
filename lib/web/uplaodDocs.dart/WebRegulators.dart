import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/web/authentication/ComOfInterest.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:itx/Serializers/CommCert.dart';
import 'package:itx/requests/Requests.dart';
import 'package:itx/uploadCerts/Authorization.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:itx/global/globals.dart';
import 'dart:typed_data';
import 'package:easy_stepper/easy_stepper.dart';

class Webregulators extends StatelessWidget {
  final List<CommoditiesCert> commCerts;
  final bool isWareHouse;

  Webregulators({Key? key, required this.commCerts, required this.isWareHouse})
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
                  screen: WebCommoditiesOfInterest(isWareHouse: isWareHouse));
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
        title: Text('Webregulators',
            style: GoogleFonts.poppins(color: Colors.white)),
      ),
      body: commCerts.isNotEmpty
          ? CertificateFormScreen(
              certificates: commCerts, isWareHouse: isWareHouse)
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
  Map<int, dynamic> _selectedCertificateFiles = {};
  Map<int, dynamic> _selectedProofOfPaymentFiles = {};

  late DropzoneViewController _certificateController;
  late DropzoneViewController _proofOfPaymentController;

  @override
  void initState() {
    super.initState();
    _formKeys.addAll(List.generate(
        widget.certificates.length, (index) => GlobalKey<FormState>()));
  }

  Widget _buildStepper() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: EasyStepper(
        activeStep: _currentPage,
        // lineLength: 50,
        stepShape: StepShape.circle,
        stepBorderRadius: 12,
        borderThickness: 2,
        padding: EdgeInsets.all(12),
        stepRadius: 28,
        finishedStepBorderColor: Colors.green,
        finishedStepTextColor: Colors.green,
        finishedStepBackgroundColor: Colors.green,
        activeStepIconColor: Colors.green,
        showLoadingAnimation: false,
        steps: List.generate(
          widget.certificates.length,
          (index) => EasyStep(
            customStep: Container(
              child: index <= _currentPage
                  ? Icon(
                      index == _currentPage
                          ? Icons.edit_document
                          : Icons.check_circle,
                      color:index == _currentPage? Colors.green:Colors.green,
                    )
                  : Text(
                      '${index + 1}',
                      style: TextStyle(color: Colors.black),
                    ),
            ),
            title: widget.certificates[index].certificateName ??
                'Certificate ${index + 1}',
            topTitle: true,
          ),
        ),
        onStepReached: (index) {
          if (!context.read<appBloc>().isLoading) {
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
      ),
    );
  }

  Future<void> _handleFileDrop(dynamic event, int certificateId,
      String fileType, DropzoneViewController controller) async {
    final name = await controller.getFilename(event);
    final mime = await controller.getFileMIME(event);
    final size = await controller.getFileSize(event);
    final url = await controller.createFileUrl(event);
    final bytes = await controller.getFileData(event);

    print('File dropped: $name, type: $fileType'); // Debug print

    setState(() {
      if (fileType == 'certificate') {
        _selectedCertificateFiles[certificateId] = {
          'name': name,
          'mime': mime,
          'size': size,
          'url': url,
          'bytes': bytes,
        };
        print('Certificate file added for ID $certificateId'); // Debug print
      } else if (fileType == 'proofOfPayment') {
        _selectedProofOfPaymentFiles[certificateId] = {
          'name': name,
          'mime': mime,
          'size': size,
          'url': url,
          'bytes': bytes,
        };
        print(
            'Proof of Payment file added for ID $certificateId'); // Debug print
      }
    });
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

      final Bloc = context.read<appBloc>();

      try {
        Bloc.changeIsLoading(true);

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${AuthRequest.main_url}/user/upload'),
        );

        request.fields.addAll({
          'user': Bloc.user_id.toString(),
          'expiry': _expiryDates[certificate.certificateId] ?? '',
          'commodity_id': certificate.commodityId.toString(),
          'certificate_id': certificate.certificateId.toString(),
          'authority_id': certificate.authorityId.toString(),
        });

        if (_selectedCertificateFiles[certificate.certificateId] != null) {
          final file = _selectedCertificateFiles[certificate.certificateId];
          request.files.add(http.MultipartFile.fromBytes(
            'certificate',
            file['bytes'],
            filename: file['name'],
          ));
        }

        if (_selectedProofOfPaymentFiles[certificate.certificateId] != null) {
          final file = _selectedProofOfPaymentFiles[certificate.certificateId];
          request.files.add(http.MultipartFile.fromBytes(
            'payment_proof',
            file['bytes'],
            filename: file['name'],
          ));
        }

        http.StreamedResponse response =
            await request.send().timeout(Duration(seconds: 10));

        if (response.statusCode == 200) {
          Bloc.changeIsLoading(false);
          String responseString = await response.stream.bytesToString();
          print(
              'Upload successful for certificate ${certificate.certificateId}: $responseString');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Certificate uploaded successfully')),
          );

          if (_currentPage < widget.certificates.length - 1) {
            _pageController.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          } else {
            context.read<appBloc>().changeIsAuthorized(1);
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: AuthorizationStatus(
                 isWeb: true,
                isWareHouse: widget.isWareHouse),
            );
          }
        } else {
          Bloc.changeIsLoading(false);
          String responseString = await response.stream.bytesToString();
          print(
              'Upload failed for certificate ${certificate.certificateId}: ${response.statusCode} - ${response.reasonPhrase}');
          print('Server response: $responseString');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload certificate')),
          );
        }
      } catch (e) {
        Bloc.changeIsLoading(false);
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('An error occurred while uploading certificate')),
        );
      }
    }
  }

  Widget _buildFilePreview(dynamic file) {
    if (file == null) return SizedBox.shrink();

    String fileType = file['mime'].split('/')[0];
    Uint8List bytes = file['bytes'];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageWidth = screenWidth * 0.3; 
    final imageHeight = screenHeight * 0.2;

    if (fileType == 'image') {
      return Image.memory(
        bytes,
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.contain,
      );
    } else {
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.insert_drive_file),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                file['name'],
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDropZone(int certificateId, String fileType, String label) {
    return Stack(
      children: [
        DropzoneView(
            operation: DragOperation.copy,
            cursor: CursorType.grab,
            onCreated: (DropzoneViewController ctrl) =>
                fileType == 'certificate'
                    ? _certificateController = ctrl
                    : _proofOfPaymentController = ctrl,
            onLoaded: () => print('Zone loaded'),
            onError: (String? ev) => print('Error: $ev'),
            onDrop: (dynamic ev) {
              DropzoneViewController controller = fileType == 'certificate'
                  ? _certificateController
                  : _proofOfPaymentController;

              _handleFileDrop(ev, certificateId, fileType, controller);
            }),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload, size: 50, color: Colors.grey),
              Text('Drop $label here or '),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final events = await (fileType == 'certificate'
                          ? _certificateController
                          : _proofOfPaymentController)
                      .pickFiles();

                  DropzoneViewController controller = fileType == 'certificate'
                      ? _certificateController
                      : _proofOfPaymentController;

                  if (events.isEmpty) return;

                  await _handleFileDrop(
                      events.first, certificateId, fileType, controller);
                },
                child: Text("Select $label"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCertificateSection(CommoditiesCert certificate, int index) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Form(
        key: _formKeys[index],
        child: Card(
          elevation: 30,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Certificate Header
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certificate.certificateName ?? 'Unnamed Certificate',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        certificate.authorityName ?? 'Unknown Authority',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                // Drop Zones Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _buildDropZone(
                            certificate.certificateId!,
                            'certificate',
                            'Certificate',
                          ),
                        ),
                      ),
                    ),
                    if (certificate.proofOfPaymentRequired == 1) ...[
                      SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: _buildDropZone(
                              certificate.certificateId!,
                              'proofOfPayment',
                              'Proof of Payment',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // File Preview Section
                if (_selectedCertificateFiles[certificate.certificateId] !=
                    null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: _buildFilePreview(
                        _selectedCertificateFiles[certificate.certificateId],
                      ),
                    ),
                  ),
                if (_selectedCertificateFiles[certificate.certificateId] ==
                    null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            size: 20, color: Colors.red.shade400),
                        SizedBox(width: 8),
                        Text(
                          'Certificate file is required',
                          style: GoogleFonts.poppins(
                            color: Colors.red.shade400,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Proof of Payment Preview
                if (certificate.proofOfPaymentRequired == 1) ...[
                  SizedBox(height: 16),
                  if (_selectedProofOfPaymentFiles[certificate.certificateId] !=
                      null)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: _buildFilePreview(
                        _selectedProofOfPaymentFiles[certificate.certificateId],
                      ),
                    ),
                  if (_selectedProofOfPaymentFiles[certificate.certificateId] ==
                      null)
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            size: 20, color: Colors.red.shade400),
                        SizedBox(width: 8),
                        Text(
                          'Proof of payment file is required',
                          style: GoogleFonts.poppins(
                            color: Colors.red.shade400,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],

                SizedBox(height: 32),

                // Expiry Date Field
                TextFormField(
                  readOnly: true,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    labelStyle: GoogleFonts.poppins(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                    suffixIcon: Icon(Icons.calendar_today,
                        color: Colors.green.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.green.shade400),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.red.shade400),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  onTap: () =>
                      _pickExpiryDate(context, certificate.certificateId!),
                  validator: (value) {
                    if (_expiryDates[certificate.certificateId] == null) {
                      return 'Please select an expiry date';
                    }
                    return null;
                  },
                  controller: TextEditingController(
                      text: _expiryDates[certificate.certificateId]),
                ),

                // Time to Live Section
                if (certificate.certificateTtl != null) ...[
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.access_time,
                              color: Colors.blue.shade700, size: 24),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Time to Live',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${certificate.certificateTtl} ${certificate.certificateTtlUnits ?? ''}',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            _buildStepper(), // Add

            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: PageView.builder(
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
                        child: _buildCertificateSection(
                            widget.certificates[index], index),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
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
                             isWeb: true,
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
            ),
          ),
        ));
  }
}
