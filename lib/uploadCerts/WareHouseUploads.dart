import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:itx/requests/Requests.dart';
import 'package:itx/uploadCerts/Authorization.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';

class WarehouseDocuments extends StatefulWidget {
  @override
  State<WarehouseDocuments> createState() => _WarehouseDocumentsState();
}

class _WarehouseDocumentsState extends State<WarehouseDocuments> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};
  bool _isLoading = false;
  String _message = '';
  String? selectedCommodity;
  List<String> commodityAuthorities = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeFormData();
  }

  // Initialize data for commodity and authorities
  void _initializeData() {
    final appBlocInstance = context.read<appBloc>();
    final commodities = appBlocInstance.userCommodities;

    if (commodities != null && commodities.isNotEmpty) {
      setState(() {
        selectedCommodity = commodities.first.toString();
        _initializeFormData();
        commodityAuthorities = [
          '$selectedCommodity',
        ];
      });
    } else {
      print("No commodities found.");
    }
  }

  // Initialize form data
  void _initializeFormData() {
    formData = {
      "performanceBondController": TextEditingController(),
      "standByLetterController": TextEditingController(),
      "cashDepositController": TextEditingController(),
      "selectedAuthorityId": null,
      "certificateController": TextEditingController(),
      "certificateFileName": TextEditingController(),
      "expiryDateController": TextEditingController(),
      "proofOfPaymentController": TextEditingController(),
      "proofOfPaymentFileName": TextEditingController()
    };
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    final appBloc bloc = context.read<appBloc>();

    var request = http.MultipartRequest(
        'POST', Uri.parse('${AuthRequest.main_url}/user/upload'));

    request.fields.addAll({
      'api': '8',
      'user': Provider.of<appBloc>(context, listen: false).user_id.toString(),
    });

    if (formData['performanceBondController'].text.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
          'performance_bond', formData['performanceBondController'].text));
    }

    if (formData['standByLetterController'].text.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
          'standby_letter', formData['standByLetterController'].text));
    }

    if (formData['cashDepositController'].text.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
          'cash_deposit', formData['cashDepositController'].text));
    }

    try {
      bloc.changeIsLoading(true);

      http.StreamedResponse response =
          await request.send().timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        print("Upload successful");
        bloc.changeIsLoading(false);
        Globals.switchScreens(
            context: context,
            screen: AuthorizationStatus(
               isWeb: false,
              isWareHouse: true,
            ));
      } else {
        bloc.changeIsLoading(false);
        Globals.warningsAlerts(
          title: "Upload failed",
          content: 'Upload failed: ${response.reasonPhrase}',
          context: context,
        );
        print('Upload failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      bloc.changeIsLoading(false);
      Globals.warningsAlerts(
        title: "Upload failed",
        content: 'Upload failed: $e',
        context: context,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  String? _validateFile(String value) {
    if (value.isEmpty) {
      return 'Please upload a file.';
    }
    return null;
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

  Widget buttons({
    required void Function() onPressed,
    required String title,
    required Color textColor,
    required bool isSubmit,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: isSubmit
          ? Provider.of<appBloc>(context, listen: false).isLoading
              ? LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white, size: 20)
              : Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                )
          : Text(
              title,
              style: GoogleFonts.poppins(
                color: textColor,
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'Warehouse Documents',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.green.shade800,
      ),
      body: Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: _buildForm(),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Dropdown for selecting authority
              _buildFormField(
                'Commodity',
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
                    hintText: "Select $selectedCommodity ",
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
              SizedBox(height: 20),

              // Performance Bond Section
              _buildCard(
                label: 'Performance Bond for Warehouse',
                controller: formData['performanceBondController'],
              ),
              // Stand By Letter of Credit Section
              _buildCard(
                label: 'Stand By Letter of Credit',
                controller: formData['standByLetterController'],
              ),
              // Cash Deposit Section
              _buildCard(
                label: 'Cash Deposit',
                controller: formData['cashDepositController'],
              ),
              SizedBox(height: 30),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buttons(
                    isSubmit: false,
                    textColor: Colors.black,
                    onPressed: () => Navigator.pop(context),
                    title: "Back",
                    color: Colors.grey.shade300,
                  ),
                  buttons(
                    isSubmit: true,
                    textColor: Colors.white,
                    onPressed: () {
                      uploadData();
                    },
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

  Widget _buildCard({
    required String label,
    required TextEditingController controller,
  }) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      child: ListTile(
        title: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'No file selected',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _pickFile(controller);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _getButtonColor(
                    fileName:
                        controller.text.isNotEmpty ? controller.text : ''),
              ),
              child: Text(
                controller.text.isEmpty ? 'Choose File' : 'File Selected',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String label, Widget fieldWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          fieldWidget,
        ],
      ),
    );
  }
}
