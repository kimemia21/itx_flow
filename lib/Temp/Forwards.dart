import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Temp/pdfGen.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:itx/global/comms.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'dart:io';

class ForwardContractWidget extends StatefulWidget {
  // final String commadityType;
  // final String commodityGrade;
  // final String commodityQuantity;

  // final int commodityUnitPrice;
  // final double commodityTotalPrice;
  // final String commodityCurrency;

  const ForwardContractWidget({
    Key? key,
    // required this.commadityType,
    // required this.commodityGrade,
    // required this.commodityQuantity,
    // required this.commodityUnitPrice,
    // required this.commodityTotalPrice,
    // required this.commodityCurrency
  }) : super(key: key);

  @override
  State<ForwardContractWidget> createState() => _ForwardContractWidgetState();
}

class _ForwardContractWidgetState extends State<ForwardContractWidget> {
  // Date Controllers
  final dayController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  // Party A Controllers
  final sellerNameController = TextEditingController();
  final sellerAddressController = TextEditingController();
  final sellerContactController = TextEditingController();

  // Party B Controllers
  final buyerNameController = TextEditingController();
  final buyerAddressController = TextEditingController();
  final buyerContactController = TextEditingController();

  // Commodity Description Controllers
  final typeController = TextEditingController();
  final gradeController = TextEditingController();
  final quantityController = TextEditingController();

  // Price and Payment Controllers
  final unitPriceController = TextEditingController();
  final totalPriceController = TextEditingController();
  final currencyController = TextEditingController();
  final paymentTermsController = TextEditingController();
  final paymentMethodController = TextEditingController();

  // Delivery Terms Controllers
  final deliveryDateController = TextEditingController();
  final deliveryLocationController = TextEditingController();
  final deliveryMethodController = TextEditingController();
  final riskTitleController = TextEditingController();

  // Inspection and Quality Controllers
  final inspectionRightsController = TextEditingController();
  final qualityAssuranceController = TextEditingController();

  // Default and Remedies Controllers
  final eventsDefaultController = TextEditingController();
  final remediesController = TextEditingController();

  // Force Majeure Controllers
  final definitionController = TextEditingController();
  final noticeRequirementsController = TextEditingController();
  final consequencesController = TextEditingController();

  // Governing Law Controllers
  final governingLawController = TextEditingController();
  final disputeResolutionController = TextEditingController();

  // Miscellaneous Controllers
  final amendmentsController = TextEditingController();
  final noticesController = TextEditingController();

  // Signature Controllers
  final partyASignatureController = TextEditingController();
  final partyANameController = TextEditingController();
  final partyATitleController = TextEditingController();
  final partyBSignatureController = TextEditingController();
  final partyBNameController = TextEditingController();
  final partyBTitleController = TextEditingController();
  final _signaturePadKey = GlobalKey<SfSignaturePadState>();
  final GlobalKey _myWidgetKey = GlobalKey();
  late String dateSigned;
  ScreenshotController screenshotController = ScreenshotController();
  final GlobalKey _screenshotKey = GlobalKey();
  double widgetHeight = 0;

Future<void> saveAsPDF() async {
  try {
    // Find the nearest SingleChildScrollView
    final scrollView = context.findAncestorWidgetOfExactType<SingleChildScrollView>();
    
    if (scrollView != null && scrollView.controller != null) {
      final scrollController = scrollView.controller!;
      
      // Store initial scroll position
      final initialScrollOffset = scrollController.offset;
      
      // Scroll to top
      await scrollController.animateTo(
        0, 
        duration: Duration(milliseconds: 300), 
        curve: Curves.easeInOut
      );

      // Wait a moment to ensure the scroll completes and the view is rendered
      await Future.delayed(Duration(milliseconds: 300));

      // Capture the PDF
      File pdfFile = await PdfGenerator.saveAsPDF(_screenshotKey);
      
      // Restore original scroll position
      await scrollController.animateTo(
        initialScrollOffset, 
        duration: Duration(milliseconds: 300), 
        curve: Curves.easeInOut
      );

      print('PDF saved at: ${pdfFile.path}');
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved successfully at: ${pdfFile.path}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Fallback method if no scroll controller is found
      File pdfFile = await PdfGenerator.saveAsPDF(_screenshotKey);
      
      print('PDF saved at: ${pdfFile.path}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved successfully at: ${pdfFile.path}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    print("save error $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to save PDF: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    dateSigned = DateFormat('dd/MM/yyyy HH:mm').format(now);

    dayController.text = now.day.toString();
    monthController.text = now.month.toString();
    yearController.text = now.year.toString();
    sellerContactController.text = currentUser.user_email;
  }

  @override
  void dispose() {
    // Dispose all controllers
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    sellerNameController.dispose();
    sellerAddressController.dispose();
    sellerContactController.dispose();
    buyerNameController.dispose();
    buyerAddressController.dispose();
    buyerContactController.dispose();
    typeController.dispose();
    gradeController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    totalPriceController.dispose();
    currencyController.dispose();
    paymentTermsController.dispose();
    paymentMethodController.dispose();
    deliveryDateController.dispose();
    deliveryLocationController.dispose();
    deliveryMethodController.dispose();
    riskTitleController.dispose();
    inspectionRightsController.dispose();
    qualityAssuranceController.dispose();
    eventsDefaultController.dispose();
    remediesController.dispose();
    definitionController.dispose();
    noticeRequirementsController.dispose();
    consequencesController.dispose();
    governingLawController.dispose();
    disputeResolutionController.dispose();
    amendmentsController.dispose();
    noticesController.dispose();
    partyASignatureController.dispose();
    partyANameController.dispose();
    partyATitleController.dispose();
    partyBSignatureController.dispose();
    partyBNameController.dispose();
    partyBTitleController.dispose();
    _signaturePadKey.currentState!.clear();
    super.dispose();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.green.shade500),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget body() {
    return  RepaintBoundary(
      key: _screenshotKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Forward Contract',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.green.shade50,
                Colors.white,
              ],
            ),
          ),
          child: SingleChildScrollView(
            controller: ScrollController(),
            padding: EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                       IconButton(
                        onPressed: () async {
                          print("button pressed");
                          await saveAsPDF();
                        },
                        icon: Icon(Icons.abc)),
                    Center(
                      child: Text(
                        'EACX Forward Contract Template',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
        
                    // Date
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('Day', dayController),
                          flex: 1,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildTextField('Month', monthController),
                          flex: 1,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _buildTextField('Year', yearController),
                          flex: 1,
                        ),
                      ],
                    ),
        
                    // Party Information
                    _buildSectionTitle('Party A (Seller)'),
                    _buildTextField('Name of Seller', sellerNameController),
                    _buildTextField('Address', sellerAddressController),
                    _buildTextField('Contact Details', sellerContactController),
        
                    _buildSectionTitle('Party B (Buyer)'),
                    _buildTextField('Name of Buyer', buyerNameController),
                    _buildTextField('Address', buyerAddressController),
                    _buildTextField('Contact Details', buyerContactController),
        
                    // Commodity Description
                    _buildSectionTitle('1. Commodity Description'),
                    _buildTextField('Type', typeController),
                    _buildTextField('Grade/Quality', gradeController),
                    _buildTextField('Quantity', quantityController),
        
                    // Price and Payment
                    _buildSectionTitle('2. Price and Payment'),
                    _buildTextField('Unit Price', unitPriceController),
                    _buildTextField('Total Price', totalPriceController),
                    _buildTextField('Currency', currencyController),
                    _buildTextField('Payment Terms', paymentTermsController,
                        maxLines: 3),
                    _buildTextField('Payment Method', paymentMethodController),
        
                    // Delivery Terms
                    _buildSectionTitle('3. Delivery Terms'),
                    _buildTextField('Delivery Date', deliveryDateController),
                    _buildTextField(
                        'Delivery Location', deliveryLocationController),
                    _buildTextField(
                        'Delivery Method', deliveryMethodController),
                    _buildTextField(
                        'Risk and Title Transfer', riskTitleController),
        
                    // Inspection and Quality
                    _buildSectionTitle('4. Inspection and Quality Assurance'),
                    _buildTextField(
                        'Inspection Rights', inspectionRightsController,
                        maxLines: 3),
                    _buildTextField(
                        'Quality Assurance', qualityAssuranceController,
                        maxLines: 3),
        
                    // Default and Remedies
                    _buildSectionTitle('5. Default and Remedies'),
                    _buildText(
                        ''' A default shall occur if either party fails to perform any material obligation under this contract, including failure to deliver or accept the commodity, failure to make required payments, or breach of any other material term or condition.
                    \nRemedies for Default:\n Notice of Default: The non-defaulting party shall provide written notice to the defaulting party specifying the nature of the default and requiring remedy within [specified number of days].
                    \nCure Period: The defaulting party shall have [specified number of days] to cure the default after receiving notice.
              \nRemedies:\n If the default is not cured within the cure period, the non-defaulting party may exercise any or all of the following remedies:\n
          - Termination of the contract.
          - Seeking specific performance or injunctive relief.
          - Recovering damages incurred as a result of the default.
          - Any other remedies available under applicable law.
             '''),
        
                    // Force Majeure
                    _buildSectionTitle('6. Force Majeure'),
                    _buildText(
                        '''Definition \n - Force Majeure shall mean any event or circumstance beyond the reasonable control of the affected party, including but not limited to natural disasters (e.g., earthquakes, floods), acts of war or terrorism, labor strikes, governmental actions, and other unforeseeable events that prevent or hinder the performance of the contract. 
                        \nConsequences and Obligations in Case of Force Majeure:
                         \nNotice:\nThe affected party shall promptly notify the other party in writing of the occurrence of a Force Majeure event, providing details of the nature, expected duration, and impact on the contract performance.\n Suspension of Obligations: Upon the occurrence of a Force Majeure event, the obligations of the affected party shall be suspended to the extent and for the duration that such performance is prevented or delayed by the Force Majeure event.
                         \n Mitigation:\n The affected party shall use all reasonable efforts to mitigate the effects of the Force Majeure event and resume performance as soon as possible.- Alternative Performance: If the Force Majeure event continues for a prolonged period, the parties shall consult each other to determine whether alternative means of performance are feasible and mutually acceptable.
                         \n Termination: \n If the Force Majeure event prevents performance for an extended period, typically exceeding [specified number of days], either party may terminate the contract without liability, except for obligations accrued prior to the Force Majeure event'''),
        
                    // Governing Law
                    _buildSectionTitle(
                        '7. Governing Law and Dispute Resolution'),
                    _buildText('''
              Governing Law:\nThis contract shall be governed by and construed in accordance with the laws of [Jurisdiction].
             \nJurisdiction:\n Any disputes arising out of or in connection with this contract shall be subject to the exclusive jurisdiction of the courts of [Jurisdiction].
             '''),
        
                    // Miscellaneous
                    _buildSectionTitle('8. Miscellaneous'),
                    _buildText('''
             \nAmendments:
             Any amendments or modifications to this contract must be in writing and signed by both parties.
             \nNotices:\n All notices required or permitted under this contract shall be in writing and delivered to the addresses specified in the contract or as otherwise notified by the parties.
             \nEntire Agreement:\n This contract constitutes the entire agreement between the parties regarding its subject matter and supersedes all prior agreements, understandings, and representations.
             '''),
        
                    // Signatures
                    SizedBox(height: 32),
                    Text(
                      'IN WITNESS WHEREOF, the parties hereto have executed this Contract as of the Effective Date.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 24),
        
                    // Signature Section
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Party A:',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600),
                              ),
                              Center(
                                child: Container(
                                  child: SfSignaturePad(
                                    key: _signaturePadKey,
                                    minimumStrokeWidth: 1,
                                    maximumStrokeWidth: 3,
                                    strokeColor: Colors.blue,
                                    backgroundColor: Colors.white,
                                  ),
                                  height: 200,
                                  width: 300,
                                ),
                              ),
                              Row(
                                children: [
                                  Text("Clear"),
                                  IconButton(
                                      onPressed: () => _signaturePadKey
                                          .currentState!
                                          .clear(),
                                      icon: Icon(Icons.edit)),
                                ],
                              ),
                              _buildTextField('Name', partyANameController),
                              _buildTextField('Title', partyATitleController),
                              _buildText("$dateSigned")
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                      ],
                    ),
                    Text(
                      'Party B:',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    _buildTextField('Signature', partyBSignatureController),
                    _buildTextField('Name', partyBNameController),
                    _buildTextField('Title', partyBTitleController),
                 
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return body();
  }
}
