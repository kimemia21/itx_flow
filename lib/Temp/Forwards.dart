import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ForwardContractWidget extends StatelessWidget {
  const ForwardContractWidget({Key? key}) : super(key: key);

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

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  // Header
                  Center(
                    child: Text(
                      'iTX Forward Contract Template',
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
                        child: _buildTextField('Day'),
                        flex: 1,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField('Month'),
                        flex: 2,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField('Year'),
                        flex: 1,
                      ),
                    ],
                  ),

                  // Party Information
                  _buildSectionTitle('Party A (Seller)'),
                  _buildTextField('Name of Seller'),
                  _buildTextField('Address'),
                  _buildTextField('Contact Details'),

                  _buildSectionTitle('Party B (Buyer)'),
                  _buildTextField('Name of Buyer'),
                  _buildTextField('Address'),
                  _buildTextField('Contact Details'),

                  // Commodity Description
                  _buildSectionTitle('1. Commodity Description'),
                  _buildTextField('Type'),
                  _buildTextField('Grade/Quality'),
                  _buildTextField('Quantity'),

                  // Price and Payment
                  _buildSectionTitle('2. Price and Payment'),
                  _buildTextField('Unit Price'),
                  _buildTextField('Total Price'),
                  _buildTextField('Currency'),
                  _buildTextField('Payment Terms', maxLines: 3),
                  _buildTextField('Payment Method'),

                  // Delivery Terms
                  _buildSectionTitle('3. Delivery Terms'),
                  _buildTextField('Delivery Date'),
                  _buildTextField('Delivery Location'),
                  _buildTextField('Delivery Method'),
                  _buildTextField('Risk and Title Transfer'),

                  // Inspection and Quality
                  _buildSectionTitle('4. Inspection and Quality Assurance'),
                  _buildTextField('Inspection Rights', maxLines: 3),
                  _buildTextField('Quality Assurance', maxLines: 3),

                  // Default and Remedies
                  _buildSectionTitle('5. Default and Remedies'),
                  _buildTextField('Events of Default', maxLines: 3),
                  _buildTextField('Remedies', maxLines: 3),

                  // Force Majeure
                  _buildSectionTitle('6. Force Majeure'),
                  _buildTextField('Definition', maxLines: 3),
                  _buildTextField('Notice Requirements'),
                  _buildTextField('Consequences', maxLines: 3),

                  // Governing Law
                  _buildSectionTitle('7. Governing Law and Dispute Resolution'),
                  _buildTextField('Governing Law'),
                  _buildTextField('Dispute Resolution', maxLines: 3),

                  // Miscellaneous
                  _buildSectionTitle('8. Miscellaneous'),
                  _buildTextField('Amendments'),
                  _buildTextField('Notices'),

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
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                            ),
                            _buildTextField('Signature'),
                            _buildTextField('Name'),
                            _buildTextField('Title'),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Party B:',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                            ),
                            _buildTextField('Signature'),
                            _buildTextField('Name'),
                            _buildTextField('Title'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}